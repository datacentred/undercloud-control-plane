require 'sinatra'
require 'sequel'

DB = Sequel.sqlite

DB.create_table :installs do
    primary_key :id
    String :ip
    String :mac
end

installs = DB[:installs]

get '/show' do
    ips = installs.map(:ip)
    "installs = #{ips}"
end
                      
get '/add' do
    installs.insert(:ip => '10.123.123.123', :mac => 'silly')
end


