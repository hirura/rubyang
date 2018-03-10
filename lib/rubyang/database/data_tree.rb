# coding: utf-8

require 'drb/drb'
require 'rexml/document'
require 'rexml/formatters/pretty'
require 'json'

require_relative '../xpath'
require_relative 'helper'
require_relative 'component_manager'

module Rubyang
	class Database
		class DataTree
			include DRb::DRbUndumped

			module Mode
				CONFIG = :config
			end

			class Node
				attr_reader :parent, :schema_tree, :schema, :children
				def initialize parent, schema_tree, schema, mode
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
					@mode = mode
					@children = []
					@logger = Rubyang::Logger.instance
				end
				def to_s parent=true
					head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
					if parent
						vars.push "@parent=#{@parent.to_s(false)}"
						vars.push "@schema_tree=#{@schema_tree.to_s(false)}"
						vars.push "@schema=#{@schema.to_s(true)}"
						vars.push "@children=#{@children.to_s}"
					end
					head + vars.join(', ') + tail
				end
				def to_xml pretty: false
					doc = REXML::Document.new
					self.to_xml_recursive doc, ''
					if pretty
						pretty_formatter = REXML::Formatters::Pretty.new( 2 )
						pretty_formatter.compact = true
						output = ''
						pretty_formatter.write( doc, output )
						output
					else
						doc.to_s
					end
				end
				def to_json pretty: false
					hash = Hash.new
					self.to_json_recursive hash
					if pretty
						JSON.pretty_generate( hash )
					else
						JSON.generate( hash )
					end
				end
				def valid? current=true
					result = if current
							 self.root.valid?
						 else
							 case self
							 when Rubyang::Database::DataTree::Container
								 @children.inject(self.evaluate_musts){ |r, c|
									 r.and c.valid?( false )
								 }
							 when Rubyang::Database::DataTree::LeafList, Rubyang::Database::DataTree::List
								 tmp = Rubyang::Xpath::BasicType::Boolean.new( self.evaluate_min_elements )
								 tmp.and Rubyang::Xpath::BasicType::Boolean.new( self.evaluate_max_elements )
							 else
								 Rubyang::Xpath::BasicType::Boolean.new true
							 end
						 end
					@logger.debug "#{self.class}#valid?: return: #{result} #{result.value}"
					result
				end
				def load_merge_xml_recursive doc_xml
					doc_xml.each_element{ |e|
						child = edit( e.name )
						unless e.has_elements?
							if e.has_text?
								classes_have_set = [
									Rubyang::Database::DataTree::Leaf,
									Rubyang::Database::DataTree::LeafList,
								]
								if classes_have_set.include?(child.class)
									child.set e.text
								end
							end
						end
						child.load_merge_xml_recursive e
					}
				end
				def root
					case @parent
					when Rubyang::Database::DataTree::Root
						@parent
					else
						@parent.root
					end
				end

				# when start
				def evaluate_whens
					@schema.whens.inject( Rubyang::Xpath::BasicType::Boolean.new true ){ |r, w|
						puts
						puts 'evaluate whens:'
						puts 'r:'
						puts r.value
						puts 'w:'
						puts w.arg
						_when = r.and self.evaluate_xpath( w.xpath, self )
						puts '_when:'
						require 'yaml'
						puts _when.to_yaml
						puts 'evaluate whens done'
						puts
						r.and self.evaluate_xpath( w.xpath, self )
					}
				end
				# end

				# must start
				def evaluate_musts
					@schema.musts.inject( Rubyang::Xpath::BasicType::Boolean.new true ){ |r, w|
						puts
						puts 'evaluate musts:'
						puts 'r:'
						puts r.value
						puts 'w:'
						puts w.arg
						must = r.and self.evaluate_xpath( w.xpath, self )
						puts 'must:'
						require 'yaml'
						puts must.to_yaml
						puts 'evaluate musts done'
						puts
						r.and self.evaluate_xpath( w.xpath, self )
					}
				end
				# end

				# min-elements start
				def evaluate_min_elements
					if @schema.min_elements.size > 0
						@logger.debug "#{self.class}#evaluate_min_elements: @schema.min_elements.first.arg: #{@schema.min_elements.first.arg}"
						if @children.size >= @schema.min_elements.first.arg.to_i then true else false end
					else
						true
					end
				end
				# end

				# min-elements start
				def evaluate_max_elements
					if @schema.max_elements.size > 0
						@logger.debug "#{self.class}#evaluate_max_elements: @schema.max_elements.first.arg: #{@schema.max_elements.first.arg}"
						if @children.size <= @schema.max_elements.first.arg.to_i then true else false end
					else
						true
					end
				end
				# end

				def evaluate_xpath xpath, current=self
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'in evaluate_xpath:'
						puts
						puts 'xpath:'
						puts xpath.to_yaml
						puts
						puts 'self:'
						puts self.class
						puts self.schema.arg
						puts self.schema.value rescue ''
						puts 'current:'
						puts current.class
						puts current.schema.arg
						puts current.schema.value rescue ''
						puts
					end
					evaluate_xpath_expr xpath, current
				end

				def evaluate_xpath_path location_path, current
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'in evaluate_xpath_path:'
						puts
						puts 'location_path:'
						puts location_path.to_yaml
						puts
						puts 'self:'
						puts self.class
						puts self.schema.arg
						puts self.schema.value rescue ''
						puts 'current:'
						puts current.class
						puts current.schema.arg
						puts current.schema.value rescue ''
						puts
					end
					first_location_step = location_path.location_step_sequence.first
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'first_location_step:'
						puts first_location_step.to_yaml
					end
					candidates_by_axis = self.evaluate_xpath_axis( first_location_step, current )
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'candidates_by_axis:'
						puts candidates_by_axis.to_yaml
					end
					candidates_by_node_test = Rubyang::Xpath::BasicType::NodeSet.new candidates_by_axis.value.inject([]){ |cs, c| cs + c.evaluate_xpath_node_test( first_location_step, current ) }
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'candidates_by_node_test:'
						puts candidates_by_node_test.to_yaml
					end
					candidates_by_predicates = Rubyang::Xpath::BasicType::NodeSet.new candidates_by_node_test.value.inject([]){ |cs, c| cs + c.evaluate_xpath_predicates( first_location_step, current ) }
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'candidates_by_predicates:'
						puts candidates_by_predicates.to_yaml
					end
					if location_path.location_step_sequence[1..-1].size == 0
						candidates_by_predicates
					else
						Rubyang::Xpath::BasicType::NodeSet.new candidates_by_predicates.value.inject([]){ |cs, c|
							following_location_path = Rubyang::Xpath::LocationPath.new *(location_path.location_step_sequence[1..-1])
							if Rubyang::Xpath::Parser::DEBUG
								puts
								puts 'following_location_path:'
								puts following_location_path.to_yaml
								puts
							end
							cs + c.evaluate_xpath_path( following_location_path, current ).value
						}
					end
				end

				def evaluate_xpath_axis location_step, current
					if Rubyang::Xpath::Parser::DEBUG
						require 'yaml'
						puts
						puts 'in evaluate_xpath_axis:'
						puts
						puts 'location_step:'
						puts location_step.to_yaml
						puts
						puts 'self:'
						puts self.class
						puts self.schema.arg
						puts self.schema.value rescue ''
						puts 'current:'
						puts current.class
						puts current.schema.arg
						puts current.schema.value rescue ''
						puts
					end
					case location_step.axis.name
					when Rubyang::Xpath::Axis::SELF
						Rubyang::Xpath::BasicType::NodeSet.new [self]
					when Rubyang::Xpath::Axis::PARENT
						Rubyang::Xpath::BasicType::NodeSet.new [@parent]
					when Rubyang::Xpath::Axis::CHILD
						Rubyang::Xpath::BasicType::NodeSet.new @children.inject([]){ |cs, c|
							cs + case c
							when Rubyang::Database::DataTree::ListElement
								c.children
							else
								[c]
							end
						}
					else
						raise "location_step.axis.name: #{location_step.axis.name} NOT implemented"
					end
				end

				def evaluate_xpath_node_test location_step, current
					puts 
					p 'in node_test'
					p self.class
					p self.schema.arg
					p self.value rescue ''
					puts
					case location_step.node_test.node_test_type
					when Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST
						if "/" == location_step.node_test.node_test
							[self.root]
						elsif self.schema.model.arg == location_step.node_test.node_test
							case self
							when Rubyang::Database::DataTree::List
								self.children
							else
								[self]
							end
						else
							[]
						end
					when Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE
						case location_step.node_test.node_test
						when Rubyang::Xpath::NodeTest::NodeType::COMMENT
							raise "node-type: comment is not implemented"
						when Rubyang::Xpath::NodeTest::NodeType::TEXT
							raise "node-type: text is not implemented"
						when Rubyang::Xpath::NodeTest::NodeType::NODE
							[self]
						else
							raise "node-type not match to comment or text or node"
						end
					when Rubyang::Xpath::NodeTest::NodeTestType::PROCESSING_INSTRUCTION
						raise "processing-instruction is not implemented"
					else
						raise ""
					end
				end

				def evaluate_xpath_predicates location_step, current
					case location_step.predicates.size
					when 0
						[self]
					else
						location_step.predicates.inject([self]){ |cs, predicate|
							p 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
							p self.class
							if cs.size > 0
								result = cs[0].evaluate_xpath_expr predicate.expr, current
								case result
								when Rubyang::Xpath::BasicType::NodeSet
									raise
								when Rubyang::Xpath::BasicType::Boolean
									if result.value == true then cs else [] end
								when Rubyang::Xpath::BasicType::Number
									raise
								when Rubyang::Xpath::BasicType::String
									raise
								end
							else
								[]
							end
						}
					end
				end

				def evaluate_xpath_expr expr, current=self
					case expr
					when Rubyang::Xpath::Expr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in Expr"
							puts "op: #{expr.op}"
							puts
						end
						op = expr.op
						op_result = self.evaluate_xpath_expr( op, current )
					when Rubyang::Xpath::OrExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in OrExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if op1_result.class == Rubyang::Xpath::BasicType::NodeSet && op2_result.class == Rubyang::Xpath::BasicType::NodeSet
								if op1_result.empty? && op2_result.empty?
									Rubyang::Xpath::BasicType::Boolean.new false
								else
									Rubyang::Xpath::BasicType::Boolean.new true
								end
							else
								Rubyang::Xpath::BasicType::Boolean.new true
							end
						end
					when Rubyang::Xpath::AndExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in AndExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if op1_result.class == Rubyang::Xpath::BasicType::NodeSet
								Rubyang::Xpath::BasicType::Boolean.new false if op1_result.empty?
							elsif op2_result.class == Rubyang::Xpath::BasicType::NodeSet
								Rubyang::Xpath::BasicType::Boolean.new false if op2_result.empty?
							else
								Rubyang::Xpath::BasicType::Boolean.new true
							end
						end
					when Rubyang::Xpath::EqualityExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in EqualityExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if Rubyang::Xpath::Parser::DEBUG
								require 'yaml'
								puts
								puts "in EqualityExpr else:"
								puts "op1_result: #{op1_result.to_yaml}"
								puts "op2_result: #{op2_result.to_yaml}"
								puts
							end
							if op1_result.class == Rubyang::Xpath::BasicType::NodeSet && op2_result.class == Rubyang::Xpath::BasicType::String
								case operator
								when /^\=$/
									#op1_result.select{ |a| op2_result.map{ |b| b.value }.include? a.value }.map{ |c| c.parent }
									op1_result == op2_result
								when /^\!\=$/
									raise "Equality Expr: '!=' not implemented"
								else
									raise "Equality Expr: other than '=' and '!=' not implemented"
								end
							elsif op1_result.class == Rubyang::Xpath::BasicType::String && op2_result.class == Rubyang::Xpath::BasicType::NodeSet
								case operator
								when /^\=$/
									op2_result.select{ |a| op1_result.map{ |b| b.value }.include? a.value }.map{ |c| c.parent }
								when /^\!\=$/
									raise "Equality Expr: '!=' not implemented"
								else
									raise "Equality Expr: other than '=' and '!=' not implemented"
								end
							elsif op1_result.class == Rubyang::Xpath::BasicType::Number && op2_result.class == Rubyang::Xpath::BasicType::Number
								case operator
								when /^\=$/
									op1_result == op2_result
								when /^\!\=$/
									op1_result != op2_result
								else
									raise "Equality Expr: other than '=' and '!=' not implemented"
								end
							elsif op1_result.class == Rubyang::Xpath::BasicType::String && op2_result.class == Rubyang::Xpath::BasicType::String
								case operator
								when /^\=$/
									op1_result == op2_result
								when /^\!\=$/
									op1_result != op2_result
								else
									raise "Equality Expr: other than '=' and '!=' not implemented"
								end
							elsif op1_result.class == Rubyang::Xpath::BasicType::NodeSet && op2_result.class == Rubyang::Xpath::BasicType::NodeSet
								case operator
								when /^\=$/
									op1_result == op2_result
								when /^\!\=$/
									op1_result != op2_result
								else
									raise "Equality Expr: other than '=' and '!=' not implemented"
								end
							else
								Rubyang::Xpath::BasicType::Boolean.new false
							end
						end
					when Rubyang::Xpath::RelationalExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in RelationalExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if op1_result.class == Rubyang::Xpath::BasicType::Number && op2_result.class == Rubyang::Xpath::BasicType::Number
								case operator
								when /^\>$/
									op1_result > op2_result
								when /^\<$/
									op1_result < op2_result
								when /^\>\=$/
									op1_result >= op2_result
								when /^\<\=$/
									op1_result <= op2_result
								else
									raise "Relational Expr: other than '>', '<', '>=' and '<=' not valid"
								end
							else
								Rubyang::Xpath::BasicType::Boolean.new false
							end
						end
					when Rubyang::Xpath::AdditiveExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in AdditiveExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if op1_result.class == Rubyang::Xpath::BasicType::Number && op2_result.class == Rubyang::Xpath::BasicType::Number
								case operator
								when /^\+$/
									op1_result + op2_result
								when /^\-$/
									op1_result - op2_result
								else
									raise "Additive Expr: other than '+' and '-' not valid"
								end
							else
								Rubyang::Xpath::BasicType::Number.new Float::NAN
							end
						end
					when Rubyang::Xpath::MultiplicativeExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in MultiplicativeExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							if op1_result.class == Rubyang::Xpath::BasicType::Number && op2_result.class == Rubyang::Xpath::BasicType::Number
								case operator
								when /^\*$/
									op1_result * op2_result
								when /^\/$/
									op1_result / op2_result
								else
									raise "Multiplicative Expr: other than '*' and '/' not valid"
								end
							else
								Rubyang::Xpath::BasicType::Number.new Float::NAN
							end
						end
					when Rubyang::Xpath::UnaryExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in UnaryExpr"
							puts "op1: #{expr.op1}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						case operator
						when nil
							op1_result
						when /^\-$/
							case op1_result
							when Rubyang::Xpath::BasicType::Number
								- op1_result
							else
								Rubyang::Xpath::BasicType::Number.new Float::NAN
							end
						else
							raise "Unary Expr: other than '-' not valid"
						end
					when Rubyang::Xpath::UnionExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in UnionExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2, current )
							case operator
							when /^\|$/
								raise "Union Expr: '|' not implemented"
							else
								raise "Union Expr: other than '|' not implemented"
							end
						end
					when Rubyang::Xpath::PathExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in PathExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						operator = expr.operator
						op1_result = case op1
							     when Rubyang::Xpath::LocationPath
								     self.evaluate_xpath_path( op1, current )
							     when Rubyang::Xpath::FilterExpr
								     op1_result = self.evaluate_xpath_expr( op1, current )
							     else
								     raise "PathExpr: #{op1} not supported"
							     end
						if op2 == nil
							op1_result
						else
							case operator
							when /^\/$/
								case op1_result
								when Rubyang::Database::DataTree::Node
									op1_result.evaluate_xpath_path op2, current
								when Rubyang::Xpath::LocationPath
									self.evaluate_xpath_path Rubyang::Xpath::LocationPath.new( *(op1_result.location_step_sequence + op2.location_step_sequence) ), current
								else
									raise
								end
							when /^\/\/$/
								raise "Path Expr: '//' not implemented"
							else
								raise "Path Expr: other than '/' and '//' not valid"
							end
						end
					when Rubyang::Xpath::FilterExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in FilterExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_expr( op2.expr, current )
							Rubyang::Xpath::BasicType::NodeSet.new
						end
					when Rubyang::Xpath::PrimaryExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in PrimaryExpr"
							puts "op1: #{expr.op1}"
							puts
						end
						op1 = expr.op1
						case op1
						when Rubyang::Xpath::VariableReference
							raise "Primary Expr: '#{op1}' not implemented"
						when Rubyang::Xpath::Expr
							op1_result = self.evaluate_xpath_expr( op1, current )
						when Rubyang::Xpath::Literal
							Rubyang::Xpath::BasicType::String.new op1.value
						when Rubyang::Xpath::Number
							Rubyang::Xpath::BasicType::Number.new op1.value
						when Rubyang::Xpath::FunctionCall
							op1_result = self.evaluate_xpath_expr( op1, current )
						else
							raise "Primary Expr: '#{op1}' not valid"
						end
					when Rubyang::Xpath::FunctionCall
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in FunctionCall"
							puts "name: #{expr.name}"
							puts "args: #{expr.args}"
							puts
						end
						name = expr.name
						case name
						when Rubyang::Xpath::FunctionCall::CURRENT
							current
						else
							raise "FunctionCall: #{name} not implemented"
						end
					else
						raise "Unrecognized Expr: #{expr}"
					end
				end
			end

			class InteriorNode < Node
				def to_xml_recursive _doc, current_namespace
					doc = _doc.add_element( @schema.model.arg )
					unless @schema.namespace == current_namespace
						current_namespace = @schema.namespace
						doc.add_namespace current_namespace
					end
					@children.each{ |c|
						c.to_xml_recursive doc, current_namespace
					}
				end
				def to_json_recursive( _hash )
					hash = Hash.new
					_hash[@schema.model.arg] = hash
					@children.each{ |c|
						c.to_json_recursive hash
					}
				end
				def find_child_schema schema, arg
					schema.children.map{ |c|
						case c
						when Rubyang::Database::SchemaTree::Choice
							find_child_schema c, arg
						when Rubyang::Database::SchemaTree::Case
							find_child_schema c, arg
						else
							if c.model.arg == arg
								c
							else
								nil
							end
						end
					}.find{ |c| c }
				end
				def delete_same_choice_other_case schema, arg, children
					child_schema = nil
					schema.children.each{ |c|
						case c
						when Rubyang::Database::SchemaTree::Choice
							child_schema = delete_same_choice_other_case c, arg, children
						when Rubyang::Database::SchemaTree::Case
							child_schema = delete_same_choice_other_case c, arg, children
							if Rubyang::Database::SchemaTree::Choice === schema
								other_schema_children = schema.children.select{ |c2| c2 != c }
								children.delete_if{ |c2|
									other_schema_children.find{ |sc|
										find_child_schema sc, c2.schema.model.arg or sc.model.arg == c2.schema.model.arg
									}
								}
							end
						else
							if c.model.arg == arg
								child_schema = c
								if Rubyang::Database::SchemaTree::Choice === schema
									other_schema_children = schema.children.select{ |c2| c2 != c }
									children.delete_if{ |c2|
										other_schema_children.find{ |sc|
											find_child_schema sc, c2.schema.model.arg or sc.model.arg == c2.schema.model.arg
										}
									}
								end
							else
								nil
							end
						end
					}
					child_schema
				end
				def edit arg
					child_schema = find_child_schema @schema, arg
					delete_same_choice_other_case @schema, arg, @children
					child_node = @children.find{ |c| c.schema == child_schema }
					unless child_node
						case child_schema.model
						when Rubyang::Model::Anyxml
							child_node = Anyxml.new( self, @schema_tree, child_schema, @mode )
						when Rubyang::Model::Container
							child_node = Container.new( self, @schema_tree, child_schema, @mode )
							# when start
							unless child_node.evaluate_whens.value
								raise "#{arg} is not valid because of 'when' conditions"
							end
							# end
						when Rubyang::Model::Leaf
							child_node = Leaf.new( self, @schema_tree, child_schema, @mode )
						when Rubyang::Model::List
							child_node = List.new( self, @schema_tree, child_schema, @mode )
						when Rubyang::Model::LeafList
							child_node = LeafList.new( self, @schema_tree, child_schema, @mode )
						else
							raise ArgumentError, "#{arg} NOT match"
						end
						@children.push child_node
					end
					child_node
				end
				def edit_xpath arg
					xpath = Rubyang::Xpath::Parser.parse arg
					candidates = self.evaluate_xpath( xpath )
					case candidates.value.size
					when 0
						raise "no such xpath: #{arg}"
					when 1
						candidates.value.first
					else
						raise "too many match to xpath: #{arg}"
					end
				end
			end

			class LeafNode < Node
			end

			class ListNode < Node
			end

			class Root < InteriorNode
				def valid? current=true
					result = @children.inject(Rubyang::Xpath::BasicType::Boolean.new true){ |r, c|
						r.and c.valid?( false )
					}
					result.value
				end
				def commit
					begin
						components = self.edit( "rubyang" ).edit( "component" ).children.map{ |c|
							component = c.key_values.first
							hook = c.edit("hook").value
							file_path = c.edit("file-path").value
							[component, hook, file_path]
						}
						self.root.parent.component_manager.update components
						self.root.parent.component_manager.run "commit"
					rescue => e
						puts 'rescue in commit'
						puts e
					ensure 
						backup = self.to_xml
						@parent.history.push backup
					end
				end
				def revert
					backup = @parent.history.pop
					if backup
						self.load_override_xml backup
					else
						self.load_override_xml self.new.to_xml
					end
				end
				def to_xml_recursive _doc, current_namespace=''
					doc = _doc.add_element( 'config' )
					current_namespace = @schema_tree.root.namespace
					doc.add_namespace( current_namespace )
					@children.each{ |c|
						c.to_xml_recursive doc, current_namespace
					}
				end
				def to_json_recursive _hash
					hash = Hash.new
					_hash['config'] = hash
					@children.each{ |c|
						c.to_json_recursive hash
					}
				end
				def load_xml xml_str
					doc_xml = REXML::Document.new( xml_str ).root
					self.load_merge_xml_recursive doc_xml
				end
				def load_merge_xml xml_str
					self.load_xml xml_str
				end
				def load_override_xml xml_str
					@children.clear
					self.load_xml xml_str
				end
				def load_merge_json json_str
					xml_str = json_to_xml( json_str )
					self.load_merge_xml xml_str
				end
				def load_override_json json_str
					xml_str = json_to_xml( json_str )
					self.load_override_xml xml_str
				end
			end

			class Anyxml < Node
				def set arg
					@value = REXML::Document.new( arg )
				end
				def value
					@value.to_s
				end
				def to_xml_recursive _doc, current_namespace
					doc = _doc.add_element @value
					unless @schema.namespace == current_namespace
						current_namespace = @schema.namespace
						doc.add_namespace current_namespace
					end
				end
				def to_json_recursive _hash
					raise "anyxml to json is not implemented"
					hash = _hash
					hash[@schema.model.arg] = @value.to_s
				end
			end

			class Container < InteriorNode
			end

			class Leaf < LeafNode
				attr_accessor :value
				def set arg
					case @schema.type
					when SchemaTree::LeafrefType
						elements = self.evaluate_xpath( @schema.type.path )
						values = elements.inject([]){ |vs, v| vs + [v.value] }
						unless values.include? arg
							raise ArgumentError, "#{arg} is not valid for #{@schema.type.inspect}"
						end
					else
						unless @schema.type.valid? arg
							raise ArgumentError, "#{arg} is not valid for #{@schema.type.inspect}"
						end
					end
					self.value = arg
				end
				def has_value?
					if @value
						true
					else
						false
					end
				end
				def to_xml_recursive _doc, current_namespace
					doc = _doc.add_element( @schema.model.arg )
					unless @schema.namespace == current_namespace
						current_namespace = @schema.namespace
						doc.add_namespace current_namespace
					end
					doc.add_text( @value )
				end
				def to_json_recursive _hash
					hash = _hash
					hash[@schema.model.arg] = @value
				end
			end

			class List < ListNode
				def edit *args
					child_node = @children.find{ |c| c.key_values == args }
					unless child_node
						begin
							child_node = ListElement.new( self, @schema_tree, @schema, @mode, args )
						rescue
							raise ArgumentError, "#{args} NOT match"
						end
						@children.push child_node
					end
					child_node
				end
				def to_xml_recursive _doc, current_namespace
					doc = _doc
					@children.each{ |c|
						c.to_xml_recursive doc, current_namespace
					}
				end
				def to_json_recursive _hash
					array = Array.new
					_hash[@schema.model.arg] = array
					@children.each{ |c|
						c.to_json_recursive array
					}
				end
				def load_merge_xml_recursive doc_xml
					return if doc_xml.elements.size == 0
					key_args = @schema.keys.map{ |k| doc_xml.elements[k].text }
					child = edit( *key_args )
					elements = REXML::Document.new('<tmp />')
					doc_xml.each_element{ |e|
						next if @schema.keys.include? e.name
						elements.root.add_element e
					}
					child.load_merge_xml_recursive elements.root
				end
			end

			class ListElement < InteriorNode
				def initialize parent, schema_tree, schema, mode, key_values
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
					@mode = mode
					@children = []
					@key_values = key_values
					@schema.keys.zip( key_values ).each{ |key, value|
						self.edit( key, true ).set( value )
					}
				end
				def key_values
					@key_values
				end
				def edit arg, in_initialize=false
					unless in_initialize
						if @schema.model.substmt( 'key' ).find{ |s| s.arg == arg }
							raise "#{arg} is key"
						end
					end
					super arg
				end
				def to_json_recursive _array
					hash = Hash.new
					_array.push hash
					@children.each{ |c|
						c.to_json_recursive hash
					}
				end
			end

			class LeafList < InteriorNode
				def set arg
					child_node = @children.find{ |c| c.value == arg }
					unless child_node
						begin
							child_node = LeafListElement.new( self, @schema_tree, @schema, @mode, arg )
						rescue
							raise ArgumentError
						end
						@children.push child_node
					end
					child_node
				end
				def to_xml_recursive _doc, current_namespace
					doc = _doc
					@children.each{ |c|
						c.to_xml_recursive doc, current_namespace
					}
				end
			end

			class LeafListElement < LeafNode
				attr_accessor :value
				def initialize parent, schema_tree, schema, mode, value
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
					@mode = mode
					@value = value
				end
				def to_xml_recursive _doc, current_namespace
					doc = _doc.add_element( @schema.model.arg )
					unless @schema.namespace == current_namespace
						current_namespace = @schema.namespace
						doc.add_namespace current_namespace
					end
					doc.add_text( @value )
				end
			end

			attr_accessor :component_manager
			def initialize schema_tree, mode=Rubyang::Database::DataTree::Mode::CONFIG
				@root = Root.new( self, schema_tree, schema_tree.root, mode )
				@mode = mode
				@history = Array.new
				@component_manager = Rubyang::Database::ComponentManager.new
			end
			def to_s parent=true
				head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
				if parent
					vars.push "@yang=#{@root.to_s}"
					vars.push "@history=#{@history.to_s}"
					vars.push "@component_manager=#{@component_manager.to_s}"
				end
				head + vars.join(', ') + tail
			end
			def history
				@history
			end
			def root
				@root
			end
		end
	end
end
