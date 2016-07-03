# coding utf-8

require_relative 'xpath/parser'

module Rubyang
	module Xpath
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
			CURRENT ||= 'current'

			attr_reader :name, :args
			def initialize name, args=[]
				@name = name
				@args = args
			end
		end

		attr_reader :expr

		def initialize expr
			@expr = expr
		end
	end
end
