# coding: utf-8

require_relative '../../rubyang'

require 'fileutils'
require 'drb/drb'

module Rubyang
	module Server
		class Base
			def initialize
				@pid = Process.pid
				@sock_dir = "/tmp/rubyang/server"
				#@sock_file = "#{@sock_dir}/#{self.class.to_s}.#{@pid}.sock"
				@sock_file = "#{@sock_dir}/#{self.class.to_s}.sock"

				FileUtils.mkdir_p @sock_dir

				@db = Rubyang::Database.new
				@db.load_model Rubyang::Model::Parser.parse File.open( "#{File.dirname(__FILE__)}/../yang/rubyang.yang", 'r' ).read
			end

			def run
				DRb.start_service( "drbunix:#{@sock_file}", @db, safe_level: 1 )
				DRb.thread.join
			end
		end
	end
end
