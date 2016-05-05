# coding: utf-8

require 'rexml/document'
require 'rexml/formatters/pretty'
require 'json'

require_relative 'helper'

module Rubyang
	class Database
		class DataTree
			class Node
				attr_reader :parent, :schema_tree, :schema, :children
				def initialize parent, schema_tree, schema
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
					@children = []
				end
				def load_merge_xml_recursive doc_xml
					doc_xml.each_element{ |e|
						child = edit( e.name )
						unless e.has_elements?
							if e.has_text?
								child.set e.text
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
				def evaluate_xpath location_steps, current=self
					location_step = location_steps.first
					candidates_by_axis = self.evaluate_xpath_axis( location_step, current )
					candidates_by_node_test = candidates_by_axis.inject([]){ |cs, c| cs + c.evaluate_xpath_node_test( location_step, current ) }
					candidates_by_predicates = candidates_by_node_test.inject([]){ |cs, c| cs + c.evaluate_xpath_predicates( location_step, current ) }
					if location_steps[1..-1].size == 0
						candidates_by_predicates
					else
						candidates_by_predicates.inject([]){ |cs, c| c.evaluate_xpath( location_steps[1..-1], current ) }
					end
				end
				def evaluate_xpath_axis location_step, current
					case location_step.axis.name
					when Rubyang::Xpath::Axis::SELF
						[self]
					when Rubyang::Xpath::Axis::PARENT
						[@parent]
					when Rubyang::Xpath::Axis::CHILD
						@children.inject([]){ |cs, c|
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
					case location_step.node_test.node_test_type
					when Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST
						if "/" == location_step.node_test.node_test
							[self.root]
						elsif self.schema.model.arg == location_step.node_test.node_test
							[self]
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
						location_step.predicates.inject([]){ |cs, predicate|
							self.evaluate_xpath_predicate_expr predicate.expr, current
						}
					end
				end
				def evaluate_xpath_predicate_expr expr, current
					case expr
					when Rubyang::Xpath::Predicate::OrExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in OrExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_predicate_expr( op2, current )
							op1_result | op2_result
						end
					when Rubyang::Xpath::Predicate::AndExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in AndExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_predicate_expr( op2, current )
							op1_result & op2_result
						end
					when Rubyang::Xpath::Predicate::EqualityExpr
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
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							case operator
							when /^\=$/
								op2_result = self.evaluate_xpath_predicate_expr( op2, current )
								op1_result.select{ |a| op2_result.map{ |b| b.value }.include? a.value }.map{ |c| c.parent }
							when /^\!\=$/
								raise "Equality Expr: '!=' not implemented"
							else
								raise "Equality Expr: other than '=' and '!=' not implemented"
							end
						end
					when Rubyang::Xpath::Predicate::RelationalExpr
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
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							case operator
							when /^\>$/
								raise "Relational Expr: '>' not implemented"
							when /^\<$/
								raise "Relational Expr: '<' not implemented"
							when /^\>\=$/
								raise "Relational Expr: '>=' not implemented"
							when /^\<\=$/
								raise "Relational Expr: '<=' not implemented"
							else
								raise "Relational Expr: other than '>', '<', '>=' and '<=' not implemented"
							end
						end
					when Rubyang::Xpath::Predicate::AdditiveExpr
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
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							case operator
							when /^\+$/
								raise "Additive Expr: '+' not implemented"
							when /^\-$/
								raise "Additive Expr: '-' not implemented"
							else
								raise "Additive Expr: other than '+' and '-' not implemented"
							end
						end
					when Rubyang::Xpath::Predicate::MultiplicativeExpr
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
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							case operator
							when /^\*$/
								raise "Multiplicative Expr: '*' not implemented"
							when /^\/$/
								raise "Multiplicative Expr: '/' not implemented"
							else
								raise "Multiplicative Expr: other than '*' and '/' not implemented"
							end
						end
					when Rubyang::Xpath::Predicate::UnaryExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in UnaryExpr"
							puts "op1: #{expr.op1}"
							puts "operator: #{expr.operator}"
							puts
						end
						op1 = expr.op1
						operator = expr.operator
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						case operator
						when nil
							op1_result
						when /^\-$/
							raise "Unary Expr: '-' not implemented"
						else
							raise "Unary Expr: other than '-' not implemented"
						end
					when Rubyang::Xpath::Predicate::UnionExpr
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
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							case operator
							when /^\|$/
								raise "Union Expr: '|' not implemented"
							else
								raise "Union Expr: other than '|' not implemented"
							end
						end
					when Rubyang::Xpath::Predicate::PathExpr
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
						case op1
						when Rubyang::Xpath::LocationSteps
							op1_result = self.evaluate_xpath( op1, current )
						when Rubyang::Xpath::Predicate::FilterExpr
							op1_result = self.evaluate_xpath_predicate_expr( op1, current )
							if op2 == nil
								op1_result
							else
								case operator
								when /^\/$/
									case op2
									when Rubyang::Xpath::LocationSteps
										current.evaluate_xpath (op1_result + op2), current
									else
										raise "Path Expr: op1 is not LocationSteps"
									end
								when /^\/\/$/
									raise "Path Expr: '//' not implemented"
								else
									raise "Path Expr: other than '/' and '//' not implemented"
								end
							end
						else
							raise ""
						end
					when Rubyang::Xpath::Predicate::FilterExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in FilterExpr"
							puts "op1: #{expr.op1}"
							puts "op2: #{expr.op2}"
							puts
						end
						op1 = expr.op1
						op2 = expr.op2
						op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						if op2 == nil
							op1_result
						else
							op2_result = self.evaluate_xpath_predicate_expr( op2.expr, current )
							raise "Filter Expr: Filter Predicate not implemented"
						end
					when Rubyang::Xpath::Predicate::PrimaryExpr
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in PrimaryExpr"
							puts "op1: #{expr.op1}"
							puts
						end
						op1 = expr.op1
						case op1
						when Rubyang::Xpath::Predicate::Expr
							raise "Primary Expr: '( Expr )' not implemented"
						when Rubyang::Xpath::Predicate::FunctionCall
							op1_result = self.evaluate_xpath_predicate_expr( op1, current )
						when /^\$.*$/
							raise "Primary Expr: 'Variable Reference' not implemented"
						else
							raise "Primary Expr: 'Literal' and 'Number' not implemented"
						end
					when Rubyang::Xpath::Predicate::FunctionCall
						if Rubyang::Xpath::Parser::DEBUG
							puts
							puts "in FunctionCall"
							puts "name: #{expr.name}"
							puts "args: #{expr.args}"
							puts
						end
						name = expr.name
						case name
						when Rubyang::Xpath::Predicate::FunctionCall::CURRENT
							Rubyang::Xpath::LocationSteps.new
						else
							raise "FunctionCall: #{name} not implemented"
						end
					else
						raise "Unrecognized predicate: #{predicate}"
					end
				end
			end

			class InteriorNode < Node
				def to_xml pretty: false
					doc = REXML::Document.new
					self.to_xml_recursive doc
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
				def to_xml_recursive _doc, current_namespace=''
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
						when Rubyang::Model::Container
							child_node = Container.new( self, @schema_tree, child_schema )
						when Rubyang::Model::Leaf
							child_node = Leaf.new( self, @schema_tree, child_schema )
						when Rubyang::Model::List
							child_node = List.new( self, @schema_tree, child_schema )
						when Rubyang::Model::LeafList
							child_node = LeafList.new( self, @schema_tree, child_schema )
						else
							raise ArgumentError, "#{arg} NOT match"
						end
						@children.push child_node
					end
					child_node
				end
				def edit_xpath arg
					xpath = Rubyang::Xpath::Parser.parse arg
					elements = self.evaluate_xpath( xpath )
					case elements.size
					when 0
						raise "no such xpath: #{arg}"
					when 1
						elements.first
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
				def commit
					backup = self.to_xml
					@parent.history.push backup
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
							child_node = ListElement.new( self, @schema_tree, @schema, args )
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
				def initialize parent, schema_tree, schema, key_values
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
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
							child_node = LeafListElement.new( self, @schema_tree, @schema, arg )
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
				def initialize parent, schema_tree, schema, value
					@parent = parent
					@schema_tree = schema_tree
					@schema = schema
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

			def initialize schema_tree
				@root = Root.new( self, schema_tree, schema_tree.root )
				@history = Array.new
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

