# coding utf-8

require_relative 'xpath/parser'
require_relative 'database/data_tree'

module Rubyang
	module Xpath
		module BasicType
			class NodeSet
				include Enumerable

				attr_reader :value
				def initialize value=[]
					raise "#{self.class} argument must be Array" unless Array === value
					value.each{ |v|
						unless Rubyang::Database::DataTree::Node === v
							raise "#{v.class} argument must be Rubyang::Database::DataTree::Node"
						end
					}
					@value = value
				end

				def each
					@value.each do |v|
						yield v
					end
				end

				def to_boolean
					value = if @value == [] then false else true end
					Boolean.new value
				end

				def == right
					case right
					when NodeSet
						p 'in =='
						p @value.map{ |v| v.value }, right.value.map{ |v| v.value }
						value = if (@value.map{ |v| v.value } & right.value.map{ |v| v.value }).size > 0 then true else false end
						Boolean.new value
					when Boolean
						value = if @value.size > 0
								if right.value then true else false end
							else
								if right.value then false else true end
							end
						Boolean.new value
					when Number
						value = @value.find{ |v|
							case v
							when NodeSet
								"NodeSet in NodeSet is not implemented"
							when Boolean
								"Boolean in NodeSet is not implemented"
							when Number
								v.value == right.value
							when String
								v.value == right.value.to_s
							end
						}
						Boolean.new value
					when String
						value = @value.any?{ |v| v.value == right.value }
						Boolean.new value
					end
				end
			end

			class Boolean
				attr_reader :value
				def initialize value
					raise "#{self.class} argument must be true or false" unless [true, false].include?( value )
					@value = value
				end

				def to_boolean
					self
				end

				def and right
					value = (@value and right.to_boolean.value)
					Boolean.new value
				end

				def or right
					value = (@value or right.to_boolean.value)
					Boolean.new value
				end
			end

			class Number
				attr_reader :value
				def initialize value
					@value = Float(value)
				end

				def to_boolean
					value = if @value == Float(0) then false else true end
					Boolean.new value
				end

				def -@
					value = (- @value)
					Number.new value
				end

				def + right
					case right
					when Number
						value = (@value + right.value)
						Number.new value
					else
						raise
					end
				end

				def - right
					case right
					when Number
						value = (@value - right.value)
						Number.new value
					else
						raise
					end
				end

				def * right
					case right
					when Number
						value = (@value * right.value)
						Number.new value
					else
						raise
					end
				end

				def / right
					case right
					when Number
						value = (@value / right.value)
						Number.new value
					else
						raise
					end
				end

				def == right
					case right
					when Number
						value = (@value == right.value)
						Boolean.new value
					else
						raise
					end
				end

				def != right
					case right
					when Number
						value = (@value != right.value)
						Boolean.new value
					else
						raise
					end
				end
			end

			class String
				attr_reader :value
				def initialize value
					@value = value
				end

				def to_boolean
					value = if @value == '' then false else true end
					Boolean.new value
				end

				def == right
					case right
					when String
						value = (@value == right.value)
						Boolean.new value
					else
						raise
					end
				end

				def != right
					case right
					when String
						value = (@value != right.value)
						Boolean.new value
					else
						raise
					end
				end
			end
		end

		class Expr
			attr_reader :op
			def initialize op
				@op = op
			end
		end

		class LocationPath
			attr_reader :location_step_sequence
			def initialize *location_step_sequence
				@location_step_sequence = location_step_sequence
			end
			def add *location_step_sequence
				@location_step_sequence.push *location_step_sequence
				self
			end
		end

		class LocationStep
			attr_reader :axis, :node_test, :predicates

			def initialize axis, node_test, predicates
				@axis = axis
				@node_test = node_test
				@predicates = predicates
			end
		end

		class Axis
			ANCESTOR           ||= 'ancestor'
			ANCESTOR_OR_SELF   ||= 'ancestor-or-self'
			ATTRIBUTE          ||= 'attribute'
			CHILD              ||= 'child'
			DESCENDANT         ||= 'descendant'
			DESCENDANT_OR_SELF ||= 'descendant-or-self'
			FOLLOWING          ||= 'following'
			FOLLOWING_SIBLING  ||= 'following-sibling'
			NAMESPACE          ||= 'namespace'
			PARENT             ||= 'parent'
			PRECEDING          ||= 'preceding'
			PRECEDING_SIBLING  ||= 'preceding-sibling'
			SELF               ||= 'self'

			attr_reader :name

			def initialize name
				@name = name
			end
		end

		class NodeTest
			module NodeTestType
				NAME_TEST              ||= 'name-test'
				NODE_TYPE              ||= 'node-type'
				PROCESSING_INSTRUCTION ||= 'processing-instruction'
			end

			class NameTest
				attr_reader :name

				def initialize name
					@name = name
				end
			end

			module NodeType
				COMMENT ||= 'comment'
				TEXT    ||= 'text'
				NODE    ||= 'node'
			end

			class ProcessingInstruction
				attr_reader :literal

				def initialize literal
					@literal = literal
				end
			end

			attr_reader :node_test_type, :node_test

			def initialize node_test_type, node_test
				@node_test_type = node_test_type
				@node_test = node_test
			end
		end

		class Predicates < Array
			def initialize *predicates
				self.push *predicates
			end
		end

		class Predicate
			attr_reader :expr
			def initialize expr
				@expr = expr
			end
		end

		class OrExpr
			attr_reader :op1, :op2
			def initialize op1, op2=nil
				@op1 = op1
				@op2 = op2
			end
		end

		class AndExpr
			attr_reader :op1, :op2
			def initialize op1, op2=nil
				@op1 = op1
				@op2 = op2
			end
		end

		class EqualityExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class RelationalExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class AdditiveExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class MultiplicativeExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class UnaryExpr
			attr_reader :op1, :operator
			def initialize op1, operator=nil
				@op1 = op1
				@operator = operator
			end
		end

		class UnionExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class PathExpr
			attr_reader :op1, :operator, :op2
			def initialize op1, operator=nil, op2=nil
				@op1 = op1
				@operator = operator
				@op2 = op2
			end
		end

		class FilterExpr
			attr_reader :op1, :op2
			def initialize op1, op2=nil
				@op1 = op1
				@op2 = op2
			end
		end

		class PrimaryExpr
			attr_reader :op1
			def initialize op1
				@op1 = op1
			end
		end

		class VariableReference
			attr_reader :name
			def initialize name
				@name = name
			end
		end

		class Literal
			attr_reader :value
			def initialize value
				@value = case value
					 when /^"(?:[^"])*"/
						 value.gsub(/^"/,'').gsub(/"$/,'').gsub(/\\n/,"\n").gsub(/\\t/,"\t").gsub(/\\"/,"\"").gsub(/\\\\/,"\\")
					 when /^'(?:[^'])*'/
						 value.gsub(/^'/,'').gsub(/'$/,'')
					 else
						 value
					 end
			end
		end

		class Number
			attr_reader :value
			def initialize value
				@value = value.to_f.to_s
			end
		end

		class FunctionCall
			CURRENT          ||= :current
			LAST             ||= :last
			POSITION         ||= 'position'
			COUNT            ||= 'count'
			ID               ||= 'id'
			LOCAL_NAME       ||= 'local-name'
			NAMESPACE_URI    ||= 'namespace-uri'
			NAME             ||= 'name'
			STRING           ||= 'string'
			CONCAT           ||= 'concat'
			STARTS_WITH      ||= 'starts-with'
			CONTAINS         ||= 'contains'
			SUBSTRING_BEFORE ||= 'substring-before'
			SUBSTRING_AFTER  ||= 'substring-after'
			SUBSTRING        ||= 'substring'
			STRING_LENGTH    ||= 'string-length'
			NORMALIZE_SPACE  ||= 'normalize-space'
			TRANSLATE        ||= 'translate'
			BOOLEAN          ||= 'boolean'
			NOT              ||= 'not'
			TRUE             ||= 'true'
			FALSE            ||= 'false'
			LANG             ||= 'lang'
			NUMBER           ||= 'number'
			SUM              ||= 'sum'
			FLOOR            ||= 'floor'
			CEILING          ||= 'ceiling'
			ROUND            ||= 'round'

			attr_reader :name, :args
			def initialize name, args=[]
				@name = name
				@args = args
			end
		end
	end
end
