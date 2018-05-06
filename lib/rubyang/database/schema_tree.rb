# coding: utf-8
# vim: et ts=2 sw=2

require 'json'
require 'yaml'
require 'base64'

require_relative '../model'
require_relative '../xpath'

module Rubyang
  class Database
    class SchemaTree
      # when start
      class When
        attr_reader :arg, :xpath
        def initialize schema_node, schema
          @logger = Logger.new(self.class.name)
          @schema_node = schema_node
          @schema = schema
          @arg = schema.arg
          @xpath = Rubyang::Xpath::Parser.parse @arg
          @logger.debug { 'when xpath:' }
          @logger.debug { @xpath.to_yaml }
          @schema_node.evaluate_xpath @xpath
        end
      end
      # end

      # must start
      class Must
        attr_reader :arg, :xpath
        def initialize schema_node, schema
          @schema_node = schema_node
          @schema = schema
          @arg = schema.arg
          @xpath = Rubyang::Xpath::Parser.parse @arg
          @logger = Logger.new(self.class.name)
          @logger.debug { @xpath }
          @schema_node.evaluate_xpath @xpath
        end
      end
      # end

      # min-elements start
      class MinElements
        attr_reader :arg
        def initialize schema_node
          @schema_node = schema_node
          @arg = schema_node.arg
        end
      end
      # end

      # max-elements start
      class MaxElements
        attr_reader :arg
        def initialize schema_node
          @schema_node = schema_node
          @arg = schema_node.arg
        end
      end
      # end

      class Type
        attr_reader :arg
      end
      class IntegerType < Type
        def initialize arg
          @arg = arg
          range = case arg
                  when 'int8'   then '-128..127'
                  when 'int16'  then '-32768..32767'
                  when 'int32'  then '-2147483648..2147483647'
                  when 'int64'  then '-9223372036854775808..9223372036854775807'
                  when 'uint8'  then '0..255'
                  when 'uint16' then '0..65535'
                  when 'uint32' then '0..4294967295'
                  when 'uint64' then '0..18446744073709551615'
                  end
          @range = Range.new range
        end
        def update_range arg
          @range.update arg
        end
        def valid? value
          result = true
          result &&= @range.valid? value
          result
        end
      end
      class Decimal64Type < Type
        def initialize arg
          @arg = arg
        end
        def valid? value
          result = true
          result
        end
      end
      class StringType < Type
        attr_reader :length, :pattern
        def initialize
          @arg = 'string'
          @length = Length.new
          @pattern = Pattern.new
        end
        def update_length arg
          @length.update arg
        end
        def update_pattern arg
          @pattern.update arg
        end
        def valid? value
          result = true
          result &&= @length.valid? value
          result &&= @pattern.valid? value
          result
        end
      end
      class BooleanType < Type
        def initialize
          @arg = 'boolean'
        end
        def valid? value
          if 'true' == value
            true
          elsif 'false' == value
            true
          else
            false
          end
        end
      end
      class EnumerationType < Type
        def initialize
          @arg = 'enumeration'
          @enum = Enum.new
        end
        def update_enum arg
          @enum.update arg
        end
        def valid? value
          result = true
          result &&= @enum.valid? value
          result
        end
      end
      class BitsType < Type
        def initialize
          @arg = 'bits'
          @bit = Bit.new
        end
        def update_bit arg
          @bit.update arg
        end
        def valid? value
          result = true
          result &&= @bit.valid? value
          result
        end
      end
      class BinaryType < Type
        def initialize
          @arg = 'binary'
          @length = Length.new
        end
        def update_length arg
          @length.update arg
        end
        def valid? value
          result = true
          result &&= @length.valid? Base64.strict_decode64( value )
          result
        end
      end
      class LeafrefType < Type
        def initialize schema_node, path_arg
          @arg = 'leafref'
          @path_arg = path_arg
          @path = Path.new schema_node, path_arg
        end
        def path
          @path.xpath
        end
        def valid? data_tree, value
          result = true
          result &&= @path.valid? data_tree, true
          result
        end
      end
      class EmptyType < Type
        def initialize
          @arg = 'empty'
        end
        def valid?
          result = true
          result
        end
      end
      class UnionType < Type
        def initialize
          @arg = 'union'
          @types = Array.new
        end
        def add_type type
          @types.push type
        end
        def valid? value
          result = false
          result ||= @types.inject( false ){ |r, t| r || t.valid?( value ) }
          result
        end
      end
      class Identityref < Type
        def initialize identity_list, type_stmt
          @arg = 'identityref'
          @base_arg = type_stmt.substmt( 'base' ).first.arg
          @identity_list = identity_list
        end
        def valid? value
          @identity_list.select{ |identity| (identity.substmt( 'base' ).first.arg rescue nil) == @base_arg }.any?{ |identity| identity.arg == value }
        end
      end

      class Path
        attr_reader :xpath

        def initialize schema_node, arg
          @xpath = Rubyang::Xpath::Parser.parse arg
          @logger = Logger.new(self.class.name)
          #if !(@xpath[0].axis.name == Rubyang::Xpath::Axis::PARENT && @xpath[0].node_test.node_test == Rubyang::Xpath::NodeTest::NodeType::NODE)
          #raise "unsupported path: #{@xpath}"
          #end
          @logger.debug { 'in Path:' }
          @logger.debug { 'schema_node:' }
          @logger.debug { schema_node.to_yaml }
          @logger.debug { '@xpath:' }
          @logger.debug { @xpath.to_yaml }
          target = schema_node.evaluate_xpath( @xpath )
          if target.class != Array || target.size == 0
            raise ArgumentError, "#{arg} is not valid"
          end
          @target = target
        end
        def valid? data_tree, value
          true
        end
      end
      class Range
        def initialize arg
          @range = [[-Float::INFINITY, Float::INFINITY]]
          self.update arg
        end
        def valid? value
          if @range.find{ |min2, max2| (min2..max2).include?( Integer(value) ) }
            true
          else
            false
          end
        end
        def update arg
          new_range = Array.new
          arg.delete( ' ' ).split( '|' ).each{ |range_part|
            case range_part
            when /[^\.]+\.\.[^\.]+/
              min, max = range_part.split('..')
            else
              min = max = range_part
            end
            case min
            when /^min$/
              min = @range.map{ |r| r[0] }.min
            else
              min = min.to_i
            end
            case max
            when /^max$/
              max = @range.map{ |r| r[1] }.max
            else
              max = max.to_i
            end
            unless @range.find{ |min2, max2| (min2..max2).include?( min ) && (min2..max2).include?( max ) }
              raise ArgumentError, "#{range_part} is not valid"
            end
            new_range.push [min, max]
          }
          @range = new_range
        end
        def to_s
          @range.map{ |l| "#{l[0]}..#{l[1]}" }.join( "|" )
        end
      end
      class Length
        def initialize
          @length = [[0, 18446744073709551615]]
        end
        def valid? value
          if @length.find{ |min2, max2| (min2..max2).include?( value.size ) }
            true
          else
            false
          end
        end
        def update arg
          new_length = Array.new
          arg.delete( ' ' ).split( '|' ).each{ |length_part|
            case length_part
            when /[^\.]+\.\.[^\.]+/
              min, max = length_part.split('..')
            else
              min = max = length_part
            end
            case min
            when /^min$/
              min = @length.map{ |r| r[0] }.min
            else
              min = min.to_i
            end
            case max
            when /^max$/
              max = @length.map{ |r| r[1] }.max
            else
              max = max.to_i
            end
            unless @length.find{ |min2, max2| (min2..max2).include?( min ) && (min2..max2).include?( max ) }
              raise ArgumentError, "#{length_part} is not valid"
            end
            new_length.push [min, max]
          }
          @length = new_length
        end
        def to_s
          @length.map{ |l| "#{l[0]}..#{l[1]}" }.join( "|" )
        end
      end
      class Pattern
        def initialize
          @pattern = Regexp.new( '^.*$' )
        end
        def valid? value
          if @pattern =~ value
            true
          else
            false
          end
        end
        def update arg
          p arg
          @pattern = Regexp.new( '^' + arg + '$' )
        end
        def to_s
          @pattern.inspect
        end
      end
      class Enum
        def initialize
          @enum = []
        end
        def valid? value
          if @enum.find{ |e| e == value }
            true
          else
            false
          end
        end
        def update arg
          if @enum.find{ |e| e == arg }
            raise ArgumentError, "#{arg} is not valid"
          end
          @enum.push arg
        end
      end
      class Bit
        def initialize
          @bit = []
        end
        def valid? value
          values = value.split( ' ' )
          if values.inject( true ){ |result, v| result && @bit.find{ |b| b == v } }
            true
          else
            false
          end
        end
        def update arg
          if @bit.find{ |b| b == arg }
            raise ArgumentError, "#{arg} is not valid"
          end
          @bit.push arg
        end
      end

      # TODO: should add config_mode_context to validate and raise error if there is config true stmt in config false stmt
      class SchemaNode
        attr_accessor :yangs, :arg, :yang, :parent, :module
        def initialize yangs, arg, yang, parent, _module
          @logger = Logger.new(self.class.name)
          @yangs = yangs
          @arg = arg
          @yang = yang
          @parent = parent
          @module = _module
        end
        def to_s parent=true
          head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
          if parent
            vars.push "@yangs=#{@yangs.to_s}"
            vars.push "@arg=#{@arg.to_s}"
            vars.push "@yang=#{@yang.to_s(false) rescue @yang.to_s}"
            vars.push "@parent=#{@parent.to_s(false) rescue @parent.to_s}"
            vars.push "@module=#{@module.to_s(false) rescue @module.to_s}"
          end
          head + vars.join(', ') + tail
        end
        def model
          @yang
        end
        def namespace
          @module.substmt( 'namespace' )[0].arg
        end
        def prefix
          @module.substmt( 'prefix' )[0].arg
        end
        def root
          if @parent == nil
            self
          else
            @parent.root
          end
        end
        def to_json
          h = Hash.new
          self.to_json_recursive( h )
          h.to_json
        end

        def evaluate_xpath xpath, current=self
          @logger.debug { 'in evaluate_xpath:' }
          @logger.debug { 'xpath:' }
          @logger.debug { xpath.to_yaml }
          @logger.debug { 'current:' }
          @logger.debug { current.class }
          evaluate_xpath_expr xpath, current
        end

        def evaluate_xpath_path location_path, current
          @logger.debug { 'in evaluate_xpath_path:' }
          @logger.debug { 'location_path:' }
          @logger.debug { location_path.to_yaml }
          @logger.debug { 'current:' }
          @logger.debug { current.class }
          first_location_step = location_path.location_step_sequence.first
          @logger.debug { 'first_location_step:' }
          @logger.debug { first_location_step.to_yaml }
          candidates_by_axis = self.evaluate_xpath_axis( first_location_step, current )
          @logger.debug { 'candidates_by_axis:' }
          @logger.debug { candidates_by_axis.to_yaml }
          candidates_by_node_test = candidates_by_axis.inject([]){ |cs, c| cs + c.evaluate_xpath_node_test( first_location_step, current ) }
          @logger.debug { 'candidates_by_node_test:' }
          @logger.debug { candidates_by_node_test.to_yaml }
          candidates_by_predicates = candidates_by_node_test.inject([]){ |cs, c| cs + c.evaluate_xpath_predicates( first_location_step, current ) }
          @logger.debug { 'candidates_by_predicates:' }
          @logger.debug { candidates_by_predicates.to_yaml }
          if location_path.location_step_sequence[1..-1].size == 0
            candidates_by_predicates
          else
            candidates_by_predicates.inject([]){ |cs, c|
              following_location_path = Rubyang::Xpath::LocationPath.new *(location_path.location_step_sequence[1..-1])
              @logger.debug { 'following_location_path:' }
              @logger.debug { following_location_path.to_yaml }
              c.evaluate_xpath_path( following_location_path, current )
            }
          end
        end

        def evaluate_xpath_axis location_step, current
          @logger.debug { 'in evaluate_xpath_axis:' }
          @logger.debug { 'location_step:' }
          @logger.debug { location_step.to_yaml }
          @logger.debug { 'current:' }
          @logger.debug { current.class }
          case location_step.axis.name
          when Rubyang::Xpath::Axis::SELF
            [self]
          when Rubyang::Xpath::Axis::PARENT
            [@parent]
          when Rubyang::Xpath::Axis::CHILD
            @children
          else
            raise "location_step.axis.name: #{location_step.axis.name} NOT implemented"
          end
        end

        def evaluate_xpath_node_test location_step, current
          case location_step.node_test.node_test_type
          when Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST
            if self.model.arg == location_step.node_test.node_test
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
            location_step.predicates.each{ |predicate|
              self.evaluate_xpath_expr predicate.expr, current
            }
            [self]
          end
        end

        def evaluate_xpath_expr expr, current
          case expr
          when Rubyang::Xpath::Expr
            @logger.debug { "in Expr" }
            @logger.debug { "op: #{expr.op}" }
            op = expr.op
            op_result = self.evaluate_xpath_expr( op, current )
          when Rubyang::Xpath::OrExpr
            @logger.debug { "in OrExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            op1 = expr.op1
            op2 = expr.op2
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Boolean
            end
          when Rubyang::Xpath::AndExpr
            @logger.debug { "in AndExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            op1 = expr.op1
            op2 = expr.op2
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Boolean
            end
          when Rubyang::Xpath::EqualityExpr
            @logger.debug { "in EqualityExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Boolean
            end
          when Rubyang::Xpath::RelationalExpr
            @logger.debug { "in RelationalExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Boolean
            end
          when Rubyang::Xpath::AdditiveExpr
            @logger.debug { "in AdditiveExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Number
            end
          when Rubyang::Xpath::MultiplicativeExpr
            @logger.debug { "in MultiplicativeExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::Number
            end
          when Rubyang::Xpath::UnaryExpr
            @logger.debug { "in UnaryExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if operator == nil
              op1_result
            else
              Rubyang::Xpath::BasicType::Number
            end
          when Rubyang::Xpath::UnionExpr
            @logger.debug { "in UnionExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2, current )
              Rubyang::Xpath::BasicType::NodeSet
            end
          when Rubyang::Xpath::PathExpr
            @logger.debug { "in PathExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            @logger.debug { "operator: #{expr.operator}" }
            op1 = expr.op1
            op2 = expr.op2
            operator = expr.operator
            op1_result = case op1
                         when Rubyang::Xpath::LocationPath
                           self.evaluate_xpath_path( op1, current )
                         when Rubyang::Xpath::FilterExpr
                           self.evaluate_xpath_expr( op1, current )
                         else
                           raise "PathExpr: #{op1} not supported"
                         end
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_path( op2, current )
              Rubyang::Xpath::BasicType::NodeSet
            end
          when Rubyang::Xpath::FilterExpr
            @logger.debug { "in FilterExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            @logger.debug { "op2: #{expr.op2}" }
            op1 = expr.op1
            op2 = expr.op2
            op1_result = self.evaluate_xpath_expr( op1, current )
            if op2 == nil
              op1_result
            else
              op2_result = self.evaluate_xpath_expr( op2.expr, current )
              Rubyang::Xpath::BasicType::NodeSet
            end
          when Rubyang::Xpath::PrimaryExpr
            @logger.debug { "in PrimaryExpr" }
            @logger.debug { "op1: #{expr.op1}" }
            op1 = expr.op1
            case op1
            when Rubyang::Xpath::VariableReference
              Rubyang::Xpath::BasicType::String
            when Rubyang::Xpath::Expr
              op1_result = self.evaluate_xpath_expr( op1, current )
            when Rubyang::Xpath::Literal
              Rubyang::Xpath::BasicType::String
            when Rubyang::Xpath::Number
              Rubyang::Xpath::BasicType::Boolean
            when Rubyang::Xpath::FunctionCall
              op1_result = self.evaluate_xpath_expr( op1, current )
            else
              raise "Primary Expr: '#{op1}' not implemented"
            end
          when Rubyang::Xpath::FunctionCall
            @logger.debug { "in FunctionCall" }
            @logger.debug { "name: #{expr.name}" }
            @logger.debug { "args: #{expr.args}" }
            name = expr.name
            case name
            when Rubyang::Xpath::FunctionCall::CURRENT
              Rubyang::Xpath::BasicType::NodeSet
            else
              raise "FunctionCall: #{name} not implemented"
            end
          else
            raise "Unrecognized Expr: #{expr}"
          end
        end

        def load_yang yang, yangs=@yangs, parent_module=yang, current_module=yang, grouping_list=[], typedef_list=[], identity_list=[]
          case yang
          when Rubyang::Model::Module
            yangs.push yang
            module_arg    = yang.arg
            namespace_arg = yang.substmt( 'namespace' )[0].arg
            prefix_arg    = yang.substmt( 'prefix' )[0].arg
            grouping_list += yang.substmt( 'grouping' )
            typedef_list  += yang.substmt( 'typedef' )
            identity_list += yang.substmt( 'identity' )
            yang.substmt( 'include' ).each{ |i|
              i.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                self.load_yang s, yangs, parent_module, i, i.substmt( 'grouping' ), i.substmt( 'typedef' ), i.substmt( 'identity' )
              }
            }
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              self.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
          when Rubyang::Model::Submodule
            yangs.push yang
          when Rubyang::Model::Anyxml
            arg = yang.arg
            self.children.push Anyxml.new( yangs, arg, yang, self, parent_module )
          when Rubyang::Model::Container
            container_arg = yang.arg
            grouping_list += yang.substmt( 'grouping' )
            typedef_list  += yang.substmt( 'typedef' )
            identity_list  += yang.substmt( 'identity' )
            self.children.push Container.new( yangs, container_arg, yang, self, parent_module )
            # when start
            yang.substmt( "when" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
            # must start
            yang.substmt( "must" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
          when Rubyang::Model::Leaf
            leaf_arg = yang.arg
            self.children.push Leaf.new( yangs, leaf_arg, yang, self, parent_module, current_module, typedef_list, identity_list )
          when Rubyang::Model::LeafList
            leaf_arg = yang.arg
            self.children.push LeafList.new( yangs, leaf_arg, yang, self, parent_module, current_module, typedef_list, identity_list )
            # min-elements start
            yang.substmt( "min-elements" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
            # max-elements start
            yang.substmt( "max-elements" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
          when Rubyang::Model::List
            list_arg = yang.arg
            grouping_list += yang.substmt( 'grouping' )
            typedef_list  += yang.substmt( 'typedef' )
            identity_list  += yang.substmt( 'identity' )
            self.children.push List.new( yangs, list_arg, yang, self, parent_module )
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # min-elements start
            yang.substmt( "min-elements" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
            # max-elements start
            yang.substmt( "max-elements" ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
            # end
          when Rubyang::Model::Choice
            choice_arg = yang.arg
            grouping_list += yang.substmt( 'grouping' )
            typedef_list  += yang.substmt( 'typedef' )
            identity_list  += yang.substmt( 'identity' )
            self.children.push Choice.new( yangs, choice_arg, yang, self, parent_module )
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
          when Rubyang::Model::Case
            case_arg = yang.arg
            grouping_list += yang.substmt( 'grouping' )
            typedef_list  += yang.substmt( 'typedef' )
            self.children.push Case.new( yangs, case_arg, yang, self, parent_module )
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              self.children.last.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
          when Rubyang::Model::Augment
            target_node = self.resolve_node( yang.arg )
            yang.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
              target_node.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
            }
          when Rubyang::Model::Uses
            self.resolve_uses( yang, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list )
            # when start
          when Rubyang::Model::When
            @logger.debug { 'when statement' }
            @logger.debug { '' }
            @logger.debug { 'yang' }
            @logger.debug { yang.to_yaml }
            self.whens.push When.new( self, yang )
            # end
            # must start
          when Rubyang::Model::Must
            @logger.debug { yang }
            self.musts.push Must.new( self, yang )
            # end
            # min-elements start
          when Rubyang::Model::MinElements
            @logger.debug { yang }
            self.min_elements.push MinElements.new( yang )
            # end
            # max-elements start
          when Rubyang::Model::MaxElements
            @logger.debug { yang }
            self.max_elements.push MaxElements.new( yang )
            # end
          else
            raise "#{yang.class} is not impletented yet"
          end
        end
      end

      class InteriorSchemaNode < SchemaNode
        attr_accessor :yangs, :arg, :yang, :parent, :children

        def initialize yangs, arg, yang, parent, _module
          super yangs, arg, yang, parent, _module
          @children = []
          @logger = Logger.new(self.class.name)
        end

        def resolve_uses uses_stmt, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
          case uses_stmt.arg
          when /^[^:]+$/
            arg = uses_stmt.arg
            if grouping_list.find{ |s| s.arg == arg }
              grouping_stmt = grouping_list.find{ |s| s.arg == arg }
              grouping_list += grouping_stmt.substmt( 'grouping' )
              typedef_list  += grouping_stmt.substmt( 'typedef' )
              identity_list += grouping_stmt.substmt( 'identity' )
              grouping_stmt.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                self.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
              }
            else
              include_submodule = current_module.substmt( 'include' ).map{ |s|
                yangs.find{ |y| y.arg == s.arg }
              }.find{ |s|
                s.substmt( 'grouping' ).find{ |t| t.arg == arg }
              }
              grouping_stmt = include_submodule.substmt( 'grouping' ).find{ |s| s.arg == arg }
              grouping_list = include_submodule.substmt( 'grouping' ) + grouping_stmt.substmt( 'grouping' )
              typedef_list  = include_submodule.substmt( 'typedef' )  + grouping_stmt.substmt( 'typedef' )
              identity_list = include_submodule.substmt( 'identity' )  + grouping_stmt.substmt( 'identity' )
              grouping_stmt.substmt( Rubyang::Model::DataDefStmtList ).each{ |s|
                self.load_yang s, yangs, parent_module, include_submodule, grouping_list, typedef_list, identity_list
              }
            end
          when /^[^:]+:[^:]+$/
            prefix, arg = uses_stmt.arg.split(':')
            case current_module
            when Rubyang::Model::Module
              case prefix
              when current_module.substmt( 'prefix' )[0].arg
                grouping_stmt = grouping_list.find{ |s| s.arg == arg }
                grouping_list += grouping_stmt.substmt( 'grouping' )
                typedef_list  += grouping_stmt.substmt( 'typedef' )
                identity_list += grouping_stmt.substmt( 'identity' )
                grouping_stmt.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                  self.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
                }
              else
                import_module = yangs.find{ |y|
                  y.arg == current_module.substmt( 'import' ).find{ |s| s.substmt( 'prefix' )[0].arg == prefix }.arg
                }
                grouping_stmt = import_module.substmt( 'grouping' ).find{ |s| s.arg == arg }
                grouping_list = import_module.substmt( 'grouping' ) + grouping_stmt.substmt( 'grouping' )
                typedef_list  = import_module.substmt( 'typedef' )  + grouping_stmt.substmt( 'typedef' )
                identity_list = import_module.substmt( 'identity' )  + grouping_stmt.substmt( 'identity' )
                grouping_stmt.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                  self.load_yang s, yangs, parent_module, import_module, grouping_list, typedef_list, identity_list
                }
              end
            when Rubyang::Model::Submodule
              case prefix
              when current_module.substmt( 'belongs-to' )[0].substmt( 'prefix' )[0].arg
                grouping_stmt = grouping_list.find{ |s| s.arg == arg }
                grouping_list += grouping_stmt.substmt( 'grouping' )
                typedef_list  += grouping_stmt.substmt( 'typedef' )
                identity_list += grouping_stmt.substmt( 'identity' )
                grouping_stmt.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                  self.load_yang s, yangs, parent_module, current_module, grouping_list, typedef_list, identity_list
                }
              else
                import_module = yangs.find{ |y|
                  y.arg == current_module.substmt( 'import' ).find{ |s| s.substmt( 'prefix' )[0].arg == prefix }.arg
                }
                grouping_stmt = import_module.substmt( 'grouping' ).find{ |s| s.arg == arg }
                grouping_list = import_module.substmt( 'grouping' ) + grouping_stmt.substmt( 'grouping' )
                typedef_list  = import_module.substmt( 'typedef' )  + grouping_stmt.substmt( 'typedef' )
                identity_list = import_module.substmt( 'identity' )  + grouping_stmt.substmt( 'identity' )
                grouping_stmt.substmts( Rubyang::Model::DataDefStmtList ).each{ |s|
                  self.load_yang s, yangs, parent_module, import_module, grouping_list, typedef_list, identity_list
                }
              end
            else
              raise
            end
          end
        end
        def resolve_node path
          path_splitted = path.split( '/' )
          next_node = case path_splitted.first
                      when '', '.'
                        self
                      when '..'
                        self
                      when /[^:]+:[^:]+/
                        @children.find{ |c| [c.prefix, c.model.arg].join(':') == path_splitted.first }
                      else
                        @children.find{ |c| c.model.arg == path_splitted.first }
                      end
          if path_splitted.size == 1
            next_node
          else
            next_node.resolve_node( path_splitted[1..-1].join( '/' ) )
          end
        end
      end

      class LeafSchemaNode < SchemaNode
        attr_reader :yangs, :arg, :yang, :parent, :module, :current_module, :typedef_list, :identity_list
        def initialize yangs, arg, yang, parent, _module, current_module, typedef_list, identity_list
          super yangs, arg, yang, parent, _module
          @type = self.resolve_type yang.substmt( 'type' )[0], yangs, current_module, typedef_list, identity_list
        end

        def type
          @type
        end

        def resolve_type type_stmt, yangs, current_module, typedef_list, identity_list
          case type_stmt.arg
          when 'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64'
            type = IntegerType.new type_stmt.arg
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              case s
              when Rubyang::Model::Range
                type.update_range s.arg
              else
                raise ArgumentError, "#{s} is not valid"
              end
            }
          when 'decimal64'
            type = Decimal64Type.new type_stmt.arg
          when 'string'
            type = StringType.new
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              case s
              when Rubyang::Model::Length
                type.update_length s.arg
              when Rubyang::Model::Pattern
                type.update_pattern s.arg
              else
                raise ArgumentError, "#{s} is not valid"
              end
            }
          when 'boolean'
            type = BooleanType.new
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              raise ArgumentError, "#{s} is not valid"
            }
          when 'enumeration'
            type = EnumerationType.new
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              case s
              when Rubyang::Model::Enum
                type.update_enum s.arg
              else
                raise ArgumentError, "#{s} is not valid"
              end
            }
          when 'bits'
            type = BitsType.new
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              case s
              when Rubyang::Model::Bit
                type.update_bit s.arg
              else
                raise ArgumentError, "#{s} is not valid"
              end
            }
          when 'binary'
            type = BinaryType.new
            type_stmt.substmts( Rubyang::Model::TypeBodyStmtList ).each{ |s|
              case s
              when Rubyang::Model::Length
                type.update_length s.arg
              else
                raise ArgumentError, "#{s} is not valid"
              end
            }
          when 'leafref'
            type = LeafrefType.new self, type_stmt.substmt( 'path' )[0].arg
          when 'empty'
            type = EmptyType.new
          when 'union'
            type = UnionType.new
            type_stmt.substmt( "type" ).each{ |s|
              type.add_type( resolve_type s, yangs, current_module, typedef_list, identity_list )
            }
          when 'identityref'
            type = Identityref.new identity_list, type_stmt
          else
            case type_stmt.arg
            when /^[^:]+$/
              arg = type_stmt.arg
              if typedef_list.find{ |s| s.arg == arg }
                typedef_stmt = typedef_list.find{ |s| s.arg == arg }
                type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, current_module, typedef_list, identity_list
              else
                include_submodule = current_module.substmt( 'include' ).map{ |s|
                  yangs.find{ |y| y.arg == s.arg }
                }.find{ |s|
                  s.substmt( 'typedef' ).find{ |t| t.arg == arg }
                }
                typedef_stmt = include_submodule.substmt( 'typedef' ).find{ |s| s.arg == arg }
                type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, include_submodule, include_submodule.substmt( 'typedef' ), include_submodule.substmt( 'identity' )
              end
            when /^[^:]+:[^:]+$/
              prefix, arg = type_stmt.arg.split(':')
              case current_module
              when Rubyang::Model::Module
                case prefix
                when current_module.substmt( 'prefix' )[0].arg
                  typedef_stmt = typedef_list.find{ |s| s.arg == arg }
                  type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, current_module, typedef_list, identity_list
                else
                  import_module = yangs.find{ |y|
                    y.arg == current_module.substmt( 'import' ).find{ |s| s.substmt( 'prefix' )[0].arg == prefix }.arg
                  }
                  typedef_stmt = import_module.substmt( 'typedef' ).find{ |s| s.arg == arg }
                  type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, import_module, import_module.substmt( 'typedef' ), import_module.substmt( 'identity' )
                end
              when Rubyang::Model::Submodule
                case prefix
                when current_module.substmt( 'belongs-to' )[0].substmt( 'prefix' )[0].arg
                  typedef_stmt = typedef_list.find{ |s| s.arg == arg }
                  type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, current_module, typedef_list, identity_list
                else
                  import_module = yangs.find{ |y|
                    y.arg == current_module.substmt( 'import' ).find{ |s| s.substmt( 'prefix' )[0].arg == prefix }.arg
                  }
                  typedef_stmt = import_module.substmt( 'typedef' ).find{ |s| s.arg == arg }
                  type = resolve_type typedef_stmt.substmt( 'type' )[0], yangs, import_module, import_module.substmt( 'typedef' ), import_module.substmt( 'identity' )
                end
              else
                raise
              end
            end
          end
          type
        end
      end

      class Root < InteriorSchemaNode
        def initialize yangs, arg=nil, yang=nil, parent=nil, _module=nil
          super
        end
        def namespace
          'http://rubyang/0.1'
        end
        def prefix
          ''
        end
        def to_json_recursive h
          @children.each{ |c|
            c.to_json_recursive h
          }
          h
        end
      end

      class Anyxml < SchemaNode
        def initialize *args
          super
          @logger = Logger.new(self.class.name)
        end
      end

      class Container < InteriorSchemaNode
        attr_accessor :whens, :musts
        def initialize *args
          super
          @whens = []
          @musts = []
        end
        def to_json_recursive h
          h['type'] = 'container'
          h['arg'] = @arg
          h['children'] = Hash.new
          @children.each{ |c|
            c.to_json_recursive h['children']
          }
          h
        end
      end

      class Leaf < LeafSchemaNode
        def to_json_recursive h
          h['type'] = 'leaf'
          h['arg'] = @arg
          case @type
          when Rubyang::Database::SchemaTree::StringType
            h['datatype'] = 'string'
            h['parameters'] = Hash.new
            h['parameters']['length'] = @type.length.to_s
            h['parameters']['pattern'] = @type.pattern.to_s
          else
            raise
          end
          h
        end
      end

      class List < InteriorSchemaNode
        # min-elements start
        # max-elements start
        attr_reader :min_elements, :max_elements
        def initialize *args
          super
          @min_elements = []
          @max_elements = []
        end
        # end
        # end

        def keys
          @yang.substmt( 'key' )[0].arg.split( /[ \t]+/ )
        end
      end

      class LeafList < LeafSchemaNode
        # min-elements start
        # max-elements start
        attr_reader :min_elements, :max_elements
        def initialize *args
          super
          @min_elements = []
          @max_elements = []
        end
        # end
        # end
      end

      class Choice < InteriorSchemaNode
      end

      class Case < InteriorSchemaNode
      end

      class Rpc < SchemaNode
      end
      class Input < SchemaNode
      end
      class Output < SchemaNode
      end
      class Notification < SchemaNode
      end

      def initialize yangs
        @yangs = yangs
        @root  = Root.new @yangs
      end
      def to_s parent=true
        head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
        if parent
          vars.push "@yangs=#{@yangs.to_s}"
          vars.push "@root=#{@root.to_s( false )}"
        end
        head + vars.join(', ') + tail
      end
      def root
        @root
      end
      def load model
        @root.load_yang( model )
      end
    end
  end
end

if __FILE__ == $0
  require_relative '../../rubyang'
  yang_str =<<-EOB
    module module1 {
      namespace "http://module1.rspec/";
      prefix module1;
      container container1 {
        leaf leaf1 {
          type string {
            length 0..10;
            pattern '[0-9]+';
          }
        }
      }
    }
  EOB
  db = Rubyang::Database.new
  db.load_model Rubyang::Model::Parser.parse( yang_str )
  @logger.debug { db.configure.schema.to_json }
end
