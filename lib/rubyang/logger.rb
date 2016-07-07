# coding: utf-8

require 'logger'
require 'singleton'

module Rubyang
	class Logger
		include Singleton

		def initialize
			@logger = ::Logger.new STDOUT
			@logger.level = ::Logger::DEBUG
		end

		def method_missing method, *arg
			@logger.send method, *arg
		end
	end
end
