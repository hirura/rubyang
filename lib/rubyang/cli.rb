# coding: utf-8

require 'readline'

require_relative 'cli/parser'

require_relative '../rubyang'

module Rubyang
	module Cli
	end
end

target_yang = File.expand_path( File.dirname( __FILE__ ) ) + '/cli/target.yang'
model = Rubyang::Model::Parser.parse( File.open( target_yang, 'r' ).read )
db = Rubyang::Database.new
db.load_model model
$config_tree = db.configure

$fo = File.open('./cli/log.txt', 'w')
$fo.sync = true

def set config_tree, tokens
	set_recursive config_tree, tokens
end

def set_recursive config_tree, tokens
	return config_tree if tokens.size == 0
	token = tokens[0]
	case tokens[1..-1].size
	when 0
		config_tree.set token
	else
		child_tree = config_tree.edit token
		set_recursive child_tree, tokens[1..-1]
	end
end

def get_candidates config_tree, tokens
	$fo.puts config_tree.class
	$fo.puts tokens.inspect
	token = tokens[0].to_s
	case config_tree
	when Rubyang::Database::DataTree::Leaf
		if tokens.size == 1
			[config_tree.value]
		else
			[]
		end
	else
		if tokens.size > 1 and config_tree.schema.children.map{ |c| c.arg }.include? token
			child_tree = config_tree.edit token
			get_candidates child_tree, tokens[1..-1]
		else
			config_tree.schema.children.map{ |c| c.arg }
		end
	end
end


#Readline.basic_word_break_characters = ""
#Readline.completer_word_break_characters = ""
Readline.completion_append_character = " "
Readline.completion_proc = proc { |buf|
	$fo.puts "line_buffer: #{Readline.line_buffer}"
	begin
		tokens = Rubyang::Cli::Parser.parse( Readline.line_buffer )
	rescue
		next
	end
	command_type = tokens.shift
	case command_type
	when /^set$/
		if tokens.size == 0
			all_candidates = ['set']
			candidates = all_candidates
		else
			value = tokens.last.to_s
			all_candidates = get_candidates( $config_tree, tokens )
			candidates = all_candidates.grep(/^#{Regexp.escape(value.to_s)}/)
		end
	when /^show$/
		format = tokens[0].to_s
		all_candidates = ['xml', 'json']
		candidates = all_candidates.grep(/^#{Regexp.escape(format.to_s)}/)
		candidates
	else
		all_candidates = ['set', 'show']
		candidates = all_candidates.grep(/^#{Regexp.escape(command_type.to_s)}/)
		candidates
	end
	$fo.puts "tokens = #{tokens.inspect}"
	$fo.puts "all_candidates = #{all_candidates.inspect}"
	$fo.puts "candidates = #{candidates.inspect}"
	$fo.puts
	$fo.puts
	candidates
}

while buf = Readline.readline("> ", true)
	tokens = Rubyang::Cli::Parser.parse( buf )
	command_type = tokens.shift
	case command_type
	when /^set$/
		begin
			set $config_tree, tokens
			$config_tree.commit
		rescue => e
			puts e
		end
	when /^show$/
		show_type = tokens.shift
		case show_type
		when /^xml$/
			puts $config_tree.to_xml( pretty: true )
		when /^json$/
			puts $config_tree.to_json( pretty: true )
		end
	end
end
