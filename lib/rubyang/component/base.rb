# coding: utf-8

require 'bundler/setup'

require 'fileutils'
require 'drb/drb'

module Rubyang
	module Component
		class Base
			include DRb::DRbUndumped

			def initialize
				@rubyang_sock_file = "/tmp/rubyang/server/Example.sock"
				@db = DRbObject.new_with_uri( "drbunix:#{@rubyang_sock_file}" )

				#@pid = Process.pid
				@sock_dir = "/tmp/rubyang/component"
				#@sock_file = "#{@sock_dir}/#{self.class}.#{pid}.sock"
				@sock_file = "#{@sock_dir}/#{self.class}.sock"

				FileUtils.mkdir_p @sock_dir

				DRb.start_service( "drbunix:#{@sock_file}", self )
				DRb.thread.join
			end

			def run
			end

			def finish
			end
		end
	end
end
