# coding: utf-8

require 'uri'
require 'strscan'

require_relative 'parser/parser.tab'

module Rubyang
	module Model
		class Parser
			def self.parse( yang_str )
				parser = self.new
				parser.parse( yang_str )
			end

			def initialize
			end

			def parse( yang_str )
				@tokens = Array.new

				s = StringScanner.new( yang_str )

				keywords = {
					## statement keywords
					"anyxml-keyword"           => "anyxml",
					"argument-keyword"         => "argument",
					"augment-keyword"          => "augment",
					"base-keyword"             => "base",
					"belongs-to-keyword"       => "belongs-to",
					"bit-keyword"              => "bit",
					"case-keyword"             => "case",
					"choice-keyword"           => "choice",
					"config-keyword"           => "config",
					"contact-keyword"          => "contact",
					"container-keyword"        => "container",
					"default-keyword"          => "default",
					"description-keyword"      => "description",
					"enum-keyword"             => "enum",
					"error-app-tag-keyword"    => "error-app-tag",
					"error-message-keyword"    => "error-message",
					"extension-keyword"        => "extension",
					"deviation-keyword"        => "deviation",
					"deviate-keyword"          => "deviate",
					"feature-keyword"          => "feature",
					"fraction-digits-keyword"  => "fraction-digits",
					"grouping-keyword"         => "grouping",
					"identity-keyword"         => "identity",
					"if-feature-keyword"       => "if-feature",
					"import-keyword"           => "import",
					"include-keyword"          => "include",
					"input-keyword"            => "input",
					"key-keyword"              => "key",
					"leaf-keyword"             => "leaf",
					"leaf-list-keyword"        => "leaf-list",
					"length-keyword"           => "length",
					"list-keyword"             => "list",
					"mandatory-keyword"        => "mandatory",
					"max-elements-keyword"     => "max-elements",
					"min-elements-keyword"     => "min-elements",
					"module-keyword"           => "module",
					"must-keyword"             => "must",
					"namespace-keyword"        => "namespace",
					"notification-keyword"     => "notification",
					"ordered-by-keyword"       => "ordered-by",
					"organization-keyword"     => "organization",
					"output-keyword"           => "output",
					"path-keyword"             => "path",
					"pattern-keyword"          => "pattern",
					"position-keyword"         => "position",
					"prefix-keyword"           => "prefix",
					"presence-keyword"         => "presence",
					"range-keyword"            => "range",
					"reference-keyword"        => "reference",
					"refine-keyword"           => "refine",
					"require-instance-keyword" => "require-instance",
					"revision-keyword"         => "revision",
					"revision-date-keyword"    => "revision-date",
					"rpc-keyword"              => "rpc",
					"status-keyword"           => "status",
					"submodule-keyword"        => "submodule",
					"type-keyword"             => "type",
					"typedef-keyword"          => "typedef",
					"unique-keyword"           => "unique",
					"units-keyword"            => "units",
					"uses-keyword"             => "uses",
					"value-keyword"            => "value",
					"when-keyword"             => "when",
					"yang-version-keyword"     => "yang-version",
					"yin-element-keyword"      => "yin-element",

					## other keywords
					#"add-keyword"              => "add",
					#"current-keyword"          => "current",
					#"delete-keyword"           => "delete",
					#"deprecated-keyword"       => "deprecated",
					#"false-keyword"            => "false",
					#"max-keyword"              => "max",
					#"min-keyword"              => "min",
					#"not-supported-keyword"    => "not-supported",
					#"obsolete-keyword"         => "obsolete",
					#"replace-keyword"          => "replace",
					#"system-keyword"           => "system",
					#"true-keyword"             => "true",
					#"unbounded-keyword"        => "unbounded",
					#"user-keyword"             => "user",
				}

				scanre_list = [
					["slcomment", /^\/\/.*$/],
					["blcomment", /^\/\*.*\*\//m],
					["dqstr",     /^"(?:\\.|[^"])*"/],
					["sqstr",     /^'(?:[^']|\\.)*'/],
					["nqstr",     /^[a-zA-Z0-9:\/\|\.=_-]+/],
					["+",         /^\+/],
					[";",         /^\;/],
					#[":",         /^\:/],
					#["/",         /^\//],
					#["|",         /^\|/],
					#["..",        /^\.\./],
					#["=",         /^\=/],
					["{",         /^\{/],
					["}",         /^\}/],
					["wsp",       /^[ \t]+/],
					["newline",   /^\n/],
					["return",    /^\r/],
				]
				scanres = scanre_list.to_h

				scanre = Regexp.union( scanre_list.map{ |scanre| scanre[1] } )

				next_to_kw = false
				until s.eos?
					token = s.scan( scanre )
					#p token
					case token
					when scanres["slcomment"] then
						;
					when scanres["blcomment"] then
						;
					when scanres["dqstr"] then
						token_ = token.gsub(/^"/,'').gsub(/"$/,'').gsub(/\\n/,"\n").gsub(/\\t/,"\t").gsub(/\\"/,"\"").gsub(/\\\\/,"\\")
						#if 0 == (token_ =~ URI.regexp)
							#@tokens.push [:URI, token_]
						#else
						@tokens.push [:STRING, token_]
						next_to_kw = false
						#end
					when scanres["sqstr"] then
						token_ = token.gsub(/^'/,'').gsub(/'$/,'')
						#case token_
						#when URI.regexp then @tokens.push [:URI, token_]
						#else @tokens.push [:STRING, token_]
						#end
						@tokens.push [:STRING, token_]
						next_to_kw = false
					when scanres["nqstr"] then
						if (! next_to_kw) and keywords.values.include?(token)
							@tokens.push [keywords.key(token), token]
							next_to_kw = true
						else
							@tokens.push [:STRING, token]
							next_to_kw = false
						end
					when scanres["+"] then
						@tokens.push ["+", token]
						next_to_kw = false
					when scanres[";"] then
						@tokens.push [";", token]
						next_to_kw = false
					when scanres[":"] then
						@tokens.push [":", token]
						next_to_kw = false
					when scanres["/"] then
						@tokens.push ["/", token]
						next_to_kw = false
					when scanres["|"] then
						@tokens.push ["|", token]
						next_to_kw = false
					when scanres[".."] then
						@tokens.push ["..", token]
						next_to_kw = false
					when scanres["="] then
						@tokens.push ["=", token]
						next_to_kw = false
					when scanres["{"] then
						@tokens.push ["{", token]
						next_to_kw = false
					when scanres["}"] then
						@tokens.push ["}", token]
						next_to_kw = false
					when scanres["wsp"] then
						; #@tokens.push [:WSP, token]
					when scanres["newline"] then
						; #@tokens.push [:NEWLINE, token]
					when scanres["return"] then
						; #@tokens.push [:RETURN, token]
					else
						raise "token not match to any scanres: #{token.inspect}"
					end
				end

				result = self.do_parse
			end

			def next_token
				#p @tokens.first
				@tokens.shift
			end
		end
	end
end

