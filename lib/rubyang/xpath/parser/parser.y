class Rubyang::Xpath::Parser

rule
	statement			:	"Expr"
							{
								@@logger.debug { 'statement : Expr' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Expr.new val[0]
							}

	"LocationPath"			:	"RelativeLocationPath"
							{
								@@logger.debug { '"LocationPath" : "RelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}
					|	"AbsoluteLocationPath"
							{
								@@logger.debug { '"LocationPath" : "AbsoluteLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"AbsoluteLocationPath"		:	"/"
							{
								@@logger.debug { '"AbsoluteLocationPath" : "/"' }
								@@logger.debug { "val: #{val.inspect}" }
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '/'
								predicates = Rubyang::Xpath::Predicates.new
								location_step = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
								result = Rubyang::Xpath::LocationPath.new location_step
							}
					|	"/" "RelativeLocationPath"
							{
								@@logger.debug { '"AbsoluteLocationPath" : "/" "RelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '/'
								predicates = Rubyang::Xpath::Predicates.new
								location_step = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
								result = Rubyang::Xpath::LocationPath.new location_step, *(val[1].location_step_sequence)
							}
					|	"AbbreviatedAbsoluteLocationPath"
							{
								@@logger.debug { '"AbsoluteLocationPath" : "AbbreviatedAbsoluteLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"RelativeLocationPath"		:	"Step"
							{
								@@logger.debug { '"RelativeLocationPath" : "Step"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::LocationPath.new val[0]
							}
					|	"RelativeLocationPath" "/" "Step"
							{
								@@logger.debug { '"RelativeLocationPath" : "RelativeLocationPath" "/" "Step"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0].add val[2]
							}
					|	"AbbreviatedRelativeLocationPath"
							{
								@@logger.debug { '"RelativeLocationPath" : "AbbreviatedRelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"Step"				:	"AxisSpecifier" "NodeTest" "Predicates"
							{
								@@logger.debug { '"Step" : "AxisSpecifier" "NodeTest" "Predicates"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::LocationStep.new val[0], val[1], val[2]
							}
					|	"AbbreviatedStep"
							{
								@@logger.debug { '"Step" : "AbbreviatedStep"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"AxisSpecifier"			:	"AxisName" "::"
							{
								@@logger.debug { '"AxisSpecifier" : "AxisName" "::"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis.new val[0]
							}
					|	"AbbreviatedAxisSpecifier"
							{
								@@logger.debug { '"AxisSpecifier" : "AbbreviatedAxisSpecifier"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis.new val[0]
							}

	"Predicates"			:
							{
								result = Rubyang::Xpath::Predicates.new
							}
					|	"Predicates" "Predicate"
							{
								@@logger.debug { '"Predicates" : "Predicates" "Predicate"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0].push val[1]
							}

	"AxisName"			:	"ancestor"
							{
								@@logger.debug { '"AxisName" : "ancestor"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::ANCESTOR
							}
					|	"ancestor-or-self"
							{
								@@logger.debug { '"AxisName" : "ancestor-or-self"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::ANCESTOR_OR_SELF
							}
					|	"attribute"
							{
								@@logger.debug { '"AxisName" : "attribute"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::ATTRIBUTE
							}
					|	"child"
							{
								@@logger.debug { '"AxisName" : "child"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::CHILD
							}
					|	"descendant"
							{
								@@logger.debug { '"AxisName" : "descendant"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::DESCENDANT
							}
					|	"descendant-or-self"
							{
								@@logger.debug { '"AxisName" : "descendant-or-self"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::DESCENDANT_OR_SELF
							}
					|	"following"
							{
								@@logger.debug { '"AxisName" : "following"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::FOLLOWING
							}
					|	"following-sibling"
							{
								@@logger.debug { '"AxisName" : "following-sibling"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::FOLLOWING_SIBLING
							}
					|	"namespace"
							{
								@@logger.debug { '"AxisName" : "namespace"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::NAMESPACE
							}
					|	"parent"
							{
								@@logger.debug { '"AxisName" : "parent"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::PARENT
							}
					|	"preceding"
							{
								@@logger.debug { '"AxisName" : "preceding"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::PRECEDING
							}
					|	"preceding-sibling"
							{
								@@logger.debug { '"AxisName" : "preceding-sibling"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::PRECEDING_SIBLING
							}
					|	"self"
							{
								@@logger.debug { '"AxisName" : "self"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::SELF
							}

	"NodeTest"			:	"NameTest"
							{
								@@logger.debug { '"NodeTest" : "NameTest"' }
								@@logger.debug { "val: #{val.inspect}" }
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}
					|	"NodeType" "(" ")"
							{
								@@logger.debug { '"NodeTest" : "NodeType" "(" ")"' }
								@@logger.debug { "val: #{val.inspect}" }
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}
					|	"processing-instruction" "(" "Literal" ")"
							{
								@@logger.debug { '"NodeTest" : "processing-instruction" "(" "Literal" ")"' }
								@@logger.debug { "val: #{val.inspect}" }
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::PROCESSING_INSTRUCTION
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}

	"Predicate"			:	"[" "PredicateExpr" "]"
							{
								@@logger.debug { '"Predicate" : "[" "PredicateExpr" "]"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Predicate.new val[1]
							}

	"PredicateExpr"			:	"Expr"
							{
								@@logger.debug { '"PredicateExpr" : "Expr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"AbbreviatedAbsoluteLocationPath" :	"//" "RelativeLocationPath"
							{
								@@logger.debug { '"AbbreviatedAbsoluteLocationPath" : "//" "RelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								raise "AbbreviatedAbsoluteLocationPath is not implemented"
								result = val[0]
							}

	"AbbreviatedRelativeLocationPath" :	"RelativeLocationPath" "//" "Step"
							{
								@@logger.debug { '"AbbreviatedRelativeLocationPath" : "RelativeLocationPath" "//" "Step"' }
								@@logger.debug { "val: #{val.inspect}" }
								raise "AbbreviatedRelativeLocationPath is not implemented"
								result = val[0]
							}

	"AbbreviatedStep"		:	"."
							{
								@@logger.debug { '"AbbreviatedStep" : "."' }
								@@logger.debug { "val: #{val.inspect}" }
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '*'
								predicates = Rubyang::Xpath::Predicates.new
								result = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
							}
					|	".."
							{
								@@logger.debug { '"AbbreviatedStep" : ".."' }
								@@logger.debug { "val: #{val.inspect}" }
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::PARENT
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE, Rubyang::Xpath::NodeTest::NodeType::NODE
								predicates = Rubyang::Xpath::Predicates.new
								result = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
							}

	"AbbreviatedAxisSpecifier"	:	/* */
							{
								@@logger.debug { '"AbbreviatedAxisSpecifier" : ' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::CHILD
							}
					|	"@"
							{
								@@logger.debug { '"AbbreviatedAxisSpecifier" : "@"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::Axis::ATTRIBUTE
							}

	"Expr"				:	"OrExpr"
							{
								@@logger.debug { '"Expr" : "OrExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"PrimaryExpr"			:	"VariableReference"
							{
								@@logger.debug { '"PrimaryExpr" : "VariableReference"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								raise "VariableReference is not implemented"
							}
					|	"(" "Expr" ")"
							{
								@@logger.debug { '"PrimaryExpr" : "(" "Expr" ")"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[1]
							}
					|	"Literal"
							{
								@@logger.debug { '"PrimaryExpr" : "Literal"' }
								@@logger.debug { "val: #{val.inspect}" }
								literal = Rubyang::Xpath::Literal.new val[0]
								result = Rubyang::Xpath::PrimaryExpr.new literal
							}
					|	"Number"
							{
								@@logger.debug { '"PrimaryExpr" : "Number"' }
								@@logger.debug { "val: #{val.inspect}" }
								number = Rubyang::Xpath::Number.new val[0]
								result = Rubyang::Xpath::PrimaryExpr.new number
							}
					|	"FunctionCall"
							{
								@@logger.debug { '"PrimaryExpr" : "FunctionCall"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::PrimaryExpr.new val[0]
							}

	"FunctionCall"			:	"FunctionName(" ")"
							{
								@@logger.debug { '"FunctionCall" : "FunctionName(" ")"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall.new val[0]
							}
					|	"FunctionName(" "Arguments" ")"
							{
								@@logger.debug { '"FunctionCall" : "FunctionName(" "Arguments" ")"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall.new val[0], val[1]
							}

	"Arguments"			:	"Argument"
							{
								@@logger.debug { '"Arguments" : "Argument"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = [val[0]]
							}
					|	"Arguments" "," "Argument"
							{
								@@logger.debug { '"Arguments" : "Arguments" "," "Argument"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0] + [val[1]]
							}

	"Argument"			:	"Exp"
							{
								@@logger.debug { '"Argument" : "Exp"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"UnionExpr"			:	"PathExpr"
							{
								@@logger.debug { '"UnionExpr" : "PathExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::UnionExpr.new val[0]
							}
					|	"UnionExpr" "|" "PathExpr"
							{
								@@logger.debug { '"UnionExpr" : "UnionExpr" "|" "PathExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::UnionExpr.new val[0], val[1], val[2]
							}

	"PathExpr"			:	"LocationPath"
							{
								@@logger.debug { '"PathExpr" : "LocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::PathExpr.new val[0]
							}
					|	"FilterExpr"
							{
								@@logger.debug { '"PathExpr" : "FilterExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::PathExpr.new val[0]
							}
					|	"FilterExpr" "/" "RelativeLocationPath"
							{
								@@logger.debug { '"PathExpr" : "FilterExpr" "/" "RelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::PathExpr.new val[0], val[1], val[2]
							}
					|	"FilterExpr" "//" "RelativeLocationPath"
							{
								@@logger.debug { '"PathExpr" : "FilterExpr" "//" "RelativeLocationPath"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::PathExpr.new val[0], val[1], val[2]
							}

	"FilterExpr"			:	"PrimaryExpr"
							{
								@@logger.debug { '"FilterExpr" : "PrimaryExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FilterExpr.new val[0]
							}
					|	"FilterExpr Predicat"
							{
								@@logger.debug { '"FilterExpr" : "FilterExpr Predicat"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FilterExpr.new val[0], val[1]
							}

	"OrExpr"			:	"AndExpr"
							{
								@@logger.debug { '"OrExpr" : "AndExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::OrExpr.new val[0]
							}
					|	"OrExpr" "or" "AndExpr"
							{
								@@logger.debug { '"OrExpr" : "OrExpr" "or" "AndExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::OrExpr.new val[0], val[2]
							}

	"AndExpr"			:	"EqualityExpr"
							{
								@@logger.debug { '"AndExpr" : "EqualityExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::AndExpr.new val[0]
							}
					|	"AndExpr" "and" "EqualityExpr"
							{
								@@logger.debug { '"AndExpr" : "AndExpr" "and" "EqualityExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::AndExpr.new val[0], val[2]
							}

	"EqualityExpr"			:	"RelationalExpr"
							{
								@@logger.debug { '"EqualityExpr" : "RelationalExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::EqualityExpr.new val[0]
							}
					|	"EqualityExpr" "=" "RelationalExpr"
							{
								@@logger.debug { '"EqualityExpr" : "EqualityExpr" "=" "RelationalExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::EqualityExpr.new val[0], val[1], val[2]
							}
					|	"EqualityExpr" "!=" "RelationalExpr"
							{
								@@logger.debug { '"EqualityExpr" : "EqualityExpr" "!=" "RelationalExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::EqualityExpr.new val[0], val[1], val[2]
							}

	"RelationalExpr"		:	"AdditiveExpr"
							{
								@@logger.debug { '"RelationalExpr" : "AdditiveExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::RelationalExpr.new val[0]
							}
					|	"RelationalExpr" "<" "AdditiveExpr"
							{
								@@logger.debug { '"RelationalExpr" : "RelationalExpr" "<" "AdditiveExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" ">" "AdditiveExpr"
							{
								@@logger.debug { '"RelationalExpr" : "RelationalExpr" ">" "AdditiveExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" "<=" "AdditiveExpr"
							{
								@@logger.debug { '"RelationalExpr" : "RelationalExpr" "<=" "AdditiveExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" ">=" "AdditiveExpr"
							{
								@@logger.debug { '"RelationalExpr" : "RelationalExpr" ">=" "AdditiveExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::RelationalExpr.new val[0], val[1], val[2]
							}

	"AdditiveExpr"			:	"MultiplicativeExpr"
							{
								@@logger.debug { '"AdditiveExpr" : "MultiplicativeExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::AdditiveExpr.new val[0]
							}
					|	"AdditiveExpr" "+" "MultiplicativeExpr"
							{
								@@logger.debug { '"AdditiveExpr" : "AdditiveExpr" "+" "MultiplicativeExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::AdditiveExpr.new val[0], val[1], val[2]
							}
					|	"AdditiveExpr" "-" "MultiplicativeExpr"
							{
								@@logger.debug { '"AdditiveExpr" : "AdditiveExpr" "-" "MultiplicativeExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::AdditiveExpr.new val[0], val[1], val[2]
							}

	"MultiplicativeExpr"		:	"UnaryExpr"
							{
								@@logger.debug { '"MultiplicativeExpr" : "UnaryExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::MultiplicativeExpr.new val[0]
							}
					|	"MultiplicativeExpr" "*" "UnaryExpr"
							{
								@@logger.debug { '"MultiplicativeExpr" : "MultiplicativeExpr" "*" "UnaryExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::MultiplicativeExpr.new val[0], val[1], val[2]
							}
					|	"MultiplicativeExpr" "div" "UnaryExpr"
							{
								@@logger.debug { '"MultiplicativeExpr" : "MultiplicativeExpr" "div" "UnaryExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::MultiplicativeExpr.new val[0], val[1], val[2]
							}
					|	"MultiplicativeExpr" "mod" "UnaryExpr"
							{
								@@logger.debug { '"MultiplicativeExpr" : "MultiplicativeExpr" "mod" "UnaryExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::MultiplicativeExpr.new val[0], val[1], val[2]
							}

	"UnaryExpr"			:	"UnionExpr"
							{
								@@logger.debug { '"UnaryExp" : "UnionExpr"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::UnaryExpr.new val[0]
							}
					|	"-" "UnaryExp"
							{
								@@logger.debug { '"UnaryExp" : "-" "UnaryExp"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::UnaryExpr.new val[1], val[0]
							}

	"Number"			:	"Digits"
							{
								@@logger.debug { '"Number" : "Digits"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}
					|	"Digits" "."
							{
								@@logger.debug { '"Number" : "Digits" "."' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}
					|	"Digits" "." "Digits"
							{
								@@logger.debug { '"Number" : "Digits" "." "Digits"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0] + val[1] + val[2]
							}
					|	"." "Digits"
							{
								@@logger.debug { '"Number" : "." "Digits"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = "0" + val[1] + val[2]
							}

	"FunctionName("			:	"last("
							{
								@@logger.debug { '"FunctionName(" : "last("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"position("
							{
								@@logger.debug { '"FunctionName(" : "position("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall::LAST
								result = val[0]
							}
					|	"count("
							{
								@@logger.debug { '"FunctionName(" : "count("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall::LAST
								result = val[0]
							}
					|	"id("
							{
								@@logger.debug { '"FunctionName(" : "id("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall::LAST
								result = val[0]
							}
					|	"local-name("
							{
								@@logger.debug { '"FunctionName(" : "local-name("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"namespace-uri("
							{
								@@logger.debug { '"FunctionName(" : "namespace-uri("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"name("
							{
								@@logger.debug { '"FunctionName(" : "name("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"string("
							{
								@@logger.debug { '"FunctionName(" : "string("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"concat("
							{
								@@logger.debug { '"FunctionName(" : "concat("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"starts-with("
							{
								@@logger.debug { '"FunctionName(" : "starts-with("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"contains("
							{
								@@logger.debug { '"FunctionName(" : "contains("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"substring-before("
							{
								@@logger.debug { '"FunctionName(" : "substring-before("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"substring-after("
							{
								@@logger.debug { '"FunctionName(" : "substring-after("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"substring("
							{
								@@logger.debug { '"FunctionName(" : "substring("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"string-length("
							{
								@@logger.debug { '"FunctionName(" : "string-length("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"normalize-space("
							{
								@@logger.debug { '"FunctionName(" : "normalize-space("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"translate("
							{
								@@logger.debug { '"FunctionName(" : "translate("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"boolean("
							{
								@@logger.debug { '"FunctionName(" : "boolean("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"not("
							{
								@@logger.debug { '"FunctionName(" : "not("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"true("
							{
								@@logger.debug { '"FunctionName(" : "true("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"false("
							{
								@@logger.debug { '"FunctionName(" : "false("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"lang("
							{
								@@logger.debug { '"FunctionName(" : "lang("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"number("
							{
								@@logger.debug { '"FunctionName(" : "number("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"sum("
							{
								@@logger.debug { '"FunctionName(" : "sum("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"floor("
							{
								@@logger.debug { '"FunctionName(" : "floor("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"ceiling("
							{
								@@logger.debug { '"FunctionName(" : "ceiling("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"round("
							{
								@@logger.debug { '"FunctionName(" : "round("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
								result = Rubyang::Xpath::FunctionCall::LAST
							}
					|	"current("
							{
								@@logger.debug { '"FunctionName(" : "current("' }
								@@logger.debug { "val: #{val.inspect}" }
								result = Rubyang::Xpath::FunctionCall::CURRENT
							}

	"VariableReference"		:	"$" "QName"
							{
								@@logger.debug { '"VariableReference" : "$" "QName"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"NameTest"			:	"*"
							{
								@@logger.debug { '"NameTest" : "*"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NameTest.new '*'
							}
					|	"NCName" ":" "*"
							{
								@@logger.debug { '"NameTest" : "NCName" ":" "*"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NameTest.new "#{val[0]}:*"
							}
					|	"QName"
							{
								@@logger.debug { '"NameTest" : "QName"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NameTest.new val[0]
							}

	"NodeType"			:	"comment"
							{
								@@logger.debug { '"NodeType" : "comment"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NodeType::COMMENT
							}
					|	"text"
							{
								@@logger.debug { '"NodeType" : "text"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NodeType::TEXT
							}
					|	"node"
							{
								@@logger.debug { '"NodeType" : "node"' }
								@@logger.debug { "val: #{val.inspect}" }
								Rubyang::Xpath::NodeTest::NodeType::NODE
							}

	"QName"				:	"PrefixedName"
							{
								@@logger.debug { '"QName" : "PrefixedName"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}
					|	"UnprefixedName"
							{
								@@logger.debug { '"QName" : "UnprefixedName"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"PrefixedName"			:	"Prefix" ":" "LocalPart"
							{
								@@logger.debug { '"PrefixedName" : "Prefix" ":" "LocalPart"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0] + val[1] + val[2]
							}

	"UnprefixedName"		:	"LocalPart"
							{
								@@logger.debug { '"UnprefixedName" : "LocalPart"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"Prefix"			:	"NCName"
							{
								@@logger.debug { '"Prefix" : "NCName"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}

	"LocalPart"			:	"NCName"
							{
								@@logger.debug { '"LocalPart" : "NCName"' }
								@@logger.debug { "val: #{val.inspect}" }
								result = val[0]
							}
end

---- inner
@@logger = Logger.new(self.name)
