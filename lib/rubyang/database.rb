# coding: utf-8
# vim: et ts=2 sw=2

require 'rubyang/model'
require 'rubyang/xpath'
require 'rubyang/database/logger'
require 'rubyang/database/module_dependency_tree'
require 'rubyang/database/schema_tree'
require 'rubyang/database/data_tree'

module Rubyang
  class Database
    def initialize
      @yangs       = Array.new
      @schema_tree = SchemaTree.new @yangs
      @config_tree = DataTree.new @schema_tree, Rubyang::Database::DataTree::Mode::CONFIG
      @oper_tree   = DataTree.new @schema_tree, Rubyang::Database::DataTree::Mode::OPER
    end

    def to_s parent=true
      head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
      if parent
        vars.push "@yangs=#{@yangs.to_s}"
        vars.push "@schema_tree=#{@schema_tree.to_s( false )}"
        vars.push "@config_tree=#{@config_tree.to_s( false )}"
        vars.push "@oper_tree=#{@oper_tree.to_s( false )}"
      end
      head + vars.join(', ') + tail
    end

    def load_model model
      case model
      when String
        @schema_tree.load Rubyang::Model::Parser.parse(model)
      when Model::Module, Model::Submodule
        @schema_tree.load model
      else
        raise ArgumentError, "Argument must be one of an instance of String, Rubyang::Model::Module or Rubyang::Model::Submodule"
      end
    end

    def load_models models
      module_dependency_tree = ModuleDependencyTree.new
      models.each{ |m|
        case m
        when String
          module_dependency_tree.register Rubyang::Model::Parser.parse(m)
        when Model::Module, Model::Submodule
          module_dependency_tree.register m
        else
          raise ArgumentError, "Element of argument must be one of an instance of String, Rubyang::Model::Module or Rubyang::Model::Submodule"
        end
      }
      module_dependency_tree.list_loadable.each{ |m|
        @schema_tree.load m
      }
    end

    def configure
      @config_tree.root
    end

    def configuration
      @config_tree.root
    end

    def oper
      @oper_tree.root
    end

    def operational
      @oper_tree.root
    end
  end
end
