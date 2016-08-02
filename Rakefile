require 'sequel'
DB = Sequel.connect('postgres://dcup:ool1xou0ohP2@localhost/dcup')

namespace :db do
    desc "Creates the database"
    task :create do

		DB.create_table! :hosts do
			primary_key :id
			String :ip
			String :mac
			String :hostname

			String :manufacturer
			String :productname
			String :serialnumber

			String :processor
			String :processorcount
			Integer :physicalprocessorcount
			Integer :memorysize_mb
			Integer :disksize_mb

            Integer :state

			DateTime :install_started
			DateTime :install_finished
			Integer :duration_seconds
		end

		DB.create_table! :jobs do
			primary_key :id
			DateTime :started
		end

    end
end

