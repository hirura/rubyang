# coding: utf-8

require 'strscan'

require_relative '../xpath.rb'

require_relative 'parser/parser.tab.rb'

module Rubyang
	module Xpath
		class Parser
			DEBUG ||= false

			def self.parse( xpath_str )
				parser = self.new
				parser.parse( xpath_str )
			end

			def initialize
			end

			def parse( xpath_str )
				@tokens = Array.new

				s = StringScanner.new( xpath_str )

				scanre_list = [
					["(",                      /^\(/],
					[")",                      /^\)/],
					["[",                      /^\[/],
					["]",                      /^\]/],
					["..",                     /^\.\./],
					[".",                      /^\./],
					["@",                      /^\@/],
					[",",                      /^\,/],
					["::",                     /^\:\:/],
					["Literal",                /^(?:"[^"]*"|'[^']*')/],
					["Digits",                 /^[0-9]+/],
					["//",                     /^\/\//],
					["/",                      /^\//],
					["|",                      /^\|/],
					["+",                      /^\+/],
					["-",                      /^\-/],
					["!=",                     /^\!\=/],
					["<=",                     /^\<\=/],
					[">=",                     /^\>\=/],
					["=",                      /^\=/],
					["<",                      /^\</],
					[">",                      /^\>/],
					["and",                    /^and/],
					["or",                     /^or/],
					["mod",                    /^mod/],
					["div",                    /^div/],
					["$",                      /^\$/],
					["*",                      /^\*/],
					[":",                      /^\:/],
					["S",                      /^[ \t]+/],
					# NodeType
					["comment",                /^comment/],
					["text",                   /^text/],
					["node",                   /^node/],
					# ProcessingInstruction
					["processing-instruction", /^processing-instruction/],
					# Axis
					["ancestor",               /^ancestor/],
					["ancestor-or-self",       /^ancestor-or-self/],
					["attribute",              /^attribute/],
					["child",                  /^child/],
					["descendant",             /^descendant/],
					["descendant-or-self",     /^descendant-or-self/],
					["following",              /^following/],
					["following-sibling",      /^following-sibling/],
					["namespace",              /^namespace/],
					["parent",                 /^parent/],
					["preceding",              /^preceding/],
					["preceding-sibling",      /^preceding-sibling/],
					["self",                   /^self/],
					# FunctionName
					["last(",                  /^last[ \t]*\(/],
					["position(",              /^position[ \t]*\(/],
					["count(",                 /^count[ \t]*\(/],
					["id(",                    /^id[ \t]*\(/],
					["local-name(",            /^local-name[ \t]*\(/],
					["namespace-uri(",         /^namespace-uri[ \t]*\(/],
					["name(",                  /^name[ \t]*\(/],
					["string(",                /^string[ \t]*\(/],
					["concat(",                /^concat[ \t]*\(/],
					["starts-with(",           /^starts-with[ \t]*\(/],
					["contains(",              /^contains[ \t]*\(/],
					["substring-before(",      /^substring-before[ \t]*\(/],
					["substring-after(",       /^substring-after[ \t]*\(/],
					["substring(",             /^substring[ \t]*\(/],
					["string-length(",         /^string-length[ \t]*\(/],
					["normalize-space(",       /^normalize-space[ \t]*\(/],
					["translate(",             /^translate[ \t]*\(/],
					["boolean(",               /^boolean[ \t]*\(/],
					["not(",                   /^not[ \t]*\(/],
					["true(",                  /^true[ \t]*\(/],
					["false(",                 /^false[ \t]*\(/],
					["lang(",                  /^lang[ \t]*\(/],
					["number(",                /^number[ \t]*\(/],
					["sum(",                   /^sum[ \t]*\(/],
					["floor(",                 /^floor[ \t]*\(/],
					["ceiling(",               /^ceiling[ \t]*\(/],
					["round(",                 /^round[ \t]*\(/],
					["current(",               /^current[ \t]*\(/],
					# NCName
					["NCName",                 /^(?:[A-Z]|\_|[a-z])(?:[A-Z]|\_|[a-z]|\-|\.|[0-9])*/],
				]

				scanre = Regexp.union( scanre_list.map{ |scanre| scanre[1] } )

                                until s.eos?
                                        token = s.scan( scanre )
					#p token
					next if "S" == scanre_list.find{ |s| s[1] =~ token }[0]
					@tokens.push [scanre_list.find{ |s| s[1] =~ token }[0], token]
                                end

                                result = self.do_parse
				result
                        end

                        def next_token
                                #p @tokens.first
                                @tokens.shift
                        end
		end
	end
end

if __FILE__ == $0
	require 'yaml'

	#str = "../leaf0"
	#xpath = Rubyang::Xpath::Parser.parse(str)
	#puts xpath.to_yaml

	#str = "/hoge"
	#xpath = Rubyang::Xpath::Parser.parse(str)
	#puts xpath.to_yaml

	str = "../hoge[name1 = current()/../container1/name]/leaf"
	xpath = Rubyang::Xpath::Parser.parse(str)
	puts xpath.to_yaml
end
