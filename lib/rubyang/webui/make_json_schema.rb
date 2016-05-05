# coding: utf-8

def make_json_schema schema_tree
	json_schema_tree = Array.new
	make_json_schema_recursive json_schema_tree, schema_tree
	return JSON.pretty_generate(json_schema_tree)
end

def make_json_schema_recursive json_schema_tree, schema_tree
	case schema_tree.model
	when nil
		json_schema_tree.push Hash.new
		json_schema_tree.last[:root] = Hash.new
		json_schema_tree.last[:root][:name] = "root"
		json_schema_tree.last[:root][:description] = "root"
		json_schema_tree.last[:root][:children] = Array.new
		schema_tree.children.each{ |child_schema_tree|
			make_json_schema_recursive json_schema_tree.last[:root][:children], child_schema_tree
		}
	when Rubyang::Model::Container
		json_schema_tree.push Hash.new
		json_schema_tree.last[:container] = Hash.new
		json_schema_tree.last[:container][:name] = schema_tree.model.arg
		json_schema_tree.last[:container][:description] = schema_tree.model.substmt('description').first.arg
		json_schema_tree.last[:container][:children] = Array.new
		schema_tree.children.each{ |child_schema_tree|
			make_json_schema_recursive json_schema_tree.last[:container][:children], child_schema_tree
		}
	when Rubyang::Model::List
		json_schema_tree.push Hash.new
		json_schema_tree.last[:list] = Hash.new
		json_schema_tree.last[:list][:key] = schema_tree.model.substmt('key')[0].arg
		json_schema_tree.last[:list][:name] = schema_tree.model.arg
		json_schema_tree.last[:list][:description] = schema_tree.model.substmt('description').first.arg
		json_schema_tree.last[:list][:children] = Array.new
		schema_tree.children.each{ |child_schema_tree|
			make_json_schema_recursive json_schema_tree.last[:list][:children], child_schema_tree
		}
	when Rubyang::Model::Leaf
		json_schema_tree.push Hash.new
		json_schema_tree.last[:leaf] = Hash.new
		json_schema_tree.last[:leaf][:name] = schema_tree.model.arg
		json_schema_tree.last[:leaf][:description] = schema_tree.model.substmt('description').first.arg
		json_schema_tree.last[:leaf][:type] = schema_tree.type.arg
	end
end


if __FILE__ == $0
	require 'yaml'
	require_relative '../../rubyang'

	target_yang = File.expand_path( File.dirname( __FILE__ ) ) + '/target.yang'

	model = Rubyang::Model::Parser.parse( File.open( target_yang, 'r' ).read )
	db = Rubyang::Database.new
	db.load_model model

	schema_tree = db.configure.schema

	json = make_json_schema schema_tree
	puts json
end
