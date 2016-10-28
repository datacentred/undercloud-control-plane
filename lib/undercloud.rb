require 'json'
require 'logger'
require 'securerandom'
require 'sequel'
require 'sinatra'
require 'tilt/erb'
require 'yaml'

CONFIG = YAML::load_file('/etc/undercloud-control-plane/undercloud.conf.yaml')
DB = Sequel.sqlite(CONFIG['database_path'])
logger = Logger.new(CONFIG['log_path'])

set :content_type => 'text/plain'
set :server, %w[passenger unicorn thin]
set :sessions, true

class UndercloudProvisioner < Sinatra::Base
  states = ['unstarted', 'installing', 'installed', 'booted']

  ## Run this at the start, once
  before do
    @hosts = DB[:hosts]
  end

  ## Sinatra Helpers ##
  helpers do
    def register_host(data)
      # Lookup the hash key that has blockdev...size and pick the first one (then bytes -> mb)
      disk_size = ((data[(data.keys.grep(/blockdevice\S+size/).first)])/(1024 * 1024)).to_i

      host_to_update = @hosts.where(:mac => data['macaddress'])
      host_to_update.update(:install_finished => Time.now,
                             :state => 2,
                             :hostname => data['hostname'],
                             :manufacturer => data['manufacturer'],
                             :productname => data['productname'],
                             :serialnumber => data['serialnumber'],
                             :processor => data['processor0'],
                             :processorcount => data['processorcount'],
                             :physicalprocessorcount => data['physicalprocessorcount'],
                             :memorysize_mb => data['memorysize_mb'].to_i,
                             :disksize_mb => disk_size )

    end

    def lookup_mac(mac)
      (@hosts.map(:mac)).include?(mac.to_s) ? true : false
    end


    def show_status
      status = Hash.new
      status['installing'] = @hosts.where(:state => 1).all
      status['installed'] = @hosts.where(:state => 2).all
      status['booted'] = @hosts.where(:state => 3).all
      status
    end
  end

  get '/status.json' do
    content_type :json
    show_status.to_json
  end 
  get '/status.yaml' do
    content_type :yaml
    show_status.to_yaml
  end 

  ## Sinatra Routes ##

    
  get '/check_installed' do
    if (@hosts.where(:state => 1).all.count == 0) and
      (@hosts.where(:state => 2).all.count == 0) and
      (@hosts.where(:state => 3).all.count > 0) 
    then
      halt 200
    else
      halt 400
    end

  end

  get '/reset_state' do
    begin
      %x[rake db:create]
    rescue
      halt 400
    end
  end

  # Route that's called at the end of the preseed
  post '/installed' do
    # Rewind the body, may not be needed in later versions of sinatra
    request.body.rewind
    # Parse
    request_payload = JSON.parse(request.body.read)

    register_host(request_payload)

    # Return the facts to the client
    request_payload.to_json
  end

  # Route used from the iPXE http chainload
  get '/boot' do
    # hard drive boot 
    if lookup_mac(params[:mac]) then
      logger.info  "Booting into OS : #{request.ip}"
      @hosts.where(:mac => params[:mac]).update(:state => 3)
      erb :boot
    else
      # install ubuntu    
      logger.info  "Installing OS : #{request.ip}"
      @hosts.insert(:install_started => Time.now, :ip => request.ip, :mac => params[:mac], :state => 1)
      erb :os_install
    end
  end 
end
