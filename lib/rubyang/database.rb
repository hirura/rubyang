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
			@data_tree   = DataTree.new   @schema_tree
		end

		def load_model model
			@schema_tree.load model
		end

		def configure
			@data_tree.root
		end

		def configuration
			@data_tree.root
		end
	end
end
