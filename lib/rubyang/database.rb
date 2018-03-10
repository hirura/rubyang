# coding: utf-8

require_relative 'model'
require_relative 'xpath'

require_relative 'database/schema_tree'
require_relative 'database/data_tree'

module Rubyang
	class Database
		def initialize
			@yangs       = Array.new
			@schema_tree = SchemaTree.new @yangs
			@config_tree = DataTree.new @schema_tree, Rubyang::Database::DataTree::Mode::CONFIG
		end

		def to_s parent=true
			head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
			if parent
				vars.push "@yangs=#{@yangs.to_s}"
				vars.push "@schema_tree=#{@schema_tree.to_s( false )}"
				vars.push "@config_tree=#{@config_tree.to_s( false )}"
			end
			head + vars.join(', ') + tail
		end

		def load_model model
			@schema_tree.load model
		end

		def configure
			@config_tree.root
		end

		def configuration
			@config_tree.root
		end
	end
end
