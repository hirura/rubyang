# coding: utf-8

require_relative 'base'

class Example < Rubyang::Component::Base
	def run
		config = @db.configure
		File.open( '/tmp/rubyang_component_example.txt', 'w' ){ |fo|
			fo.puts config.to_xml( pretty: true )
		}
	end
end

example = Example.new
example.run
