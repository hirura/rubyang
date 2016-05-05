class Rubyang::Xpath::Parser

rule
	statement			:	"LocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts 'statement : LocationPath'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"LocationPath"			:	"RelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"LocationPath" : "RelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}
					|	"AbsoluteLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"LocationPath" : "AbsoluteLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"AbsoluteLocationPath"		:	"/"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbsoluteLocationPath" : "/"'
									puts "val: #{val.inspect}"
								end
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '/'
								predicates = Rubyang::Xpath::Predicates.new
								location_step = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
								result = Rubyang::Xpath::LocationSteps.new location_step
							}
					|	"/" "RelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbsoluteLocationPath" : "/" "RelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '/'
								predicates = Rubyang::Xpath::Predicates.new
								location_step = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
								location_steps = Array.new
								location_steps.push location_step
								location_steps.push *val[1]
								result = Rubyang::Xpath::LocationSteps.new *location_steps
							}
					|	"AbbreviatedAbsoluteLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbsoluteLocationPath" : "AbbreviatedAbsoluteLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"RelativeLocationPath"		:	"Step"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelativeLocationPath" : "Step"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::LocationSteps.new val[0]
							}
					|	"RelativeLocationPath" "/" "Step"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelativeLocationPath" : "RelativeLocationPath" "/" "Step"'
									puts "val: #{val.inspect}"
								end
								result = val[0].push val[2]
							}
					|	"AbbreviatedRelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelativeLocationPath" : "AbbreviatedRelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"Step"				:	"AxisSpecifier" "NodeTest" "Predicates"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Step" : "AxisSpecifier" "NodeTest" "Predicates"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::LocationStep.new val[0], val[1], val[2]
							}
					|	"AbbreviatedStep"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Step" : "AbbreviatedStep"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"AxisSpecifier"			:	"AxisName" "::"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisSpecifier" : "AxisName" "::"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis.new val[0]
							}
					|	"AbbreviatedAxisSpecifier"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisSpecifier" : "AbbreviatedAxisSpecifier"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis.new val[0]
							}

	"Predicates"			:
							{
								result = Rubyang::Xpath::Predicates.new
							}
					|	"Predicates" "Predicate"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Predicates" : "Predicates"			"'
									puts "val: #{val.inspect}"
								end
								result = val[0].push val[1]
							}

	"AxisName"			:	"ancestor"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "ancestor"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::ANCESTOR
							}
					|	"ancestor-or-self"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "ancestor-or-self"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::ANCESTOR_OR_SELF
							}
					|	"attribute"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "attribute"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::ATTRIBUTE
							}
					|	"child"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "child"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::CHILD
							}
					|	"descendant"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "descendant"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::DESCENDANT
							}
					|	"descendant-or-self"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "descendant-or-self"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::DESCENDANT_OR_SELF
							}
					|	"following"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "following"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::FOLLOWING
							}
					|	"following-sibling"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "following-sibling"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::FOLLOWING_SIBLING
							}
					|	"namespace"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "namespace"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::NAMESPACE
							}
					|	"parent"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "parent"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::PARENT
							}
					|	"preceding"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "preceding"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::PRECEDING
							}
					|	"preceding-sibling"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "preceding-sibling"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::PRECEDING_SIBLING
							}
					|	"self"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AxisName" : "self"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::SELF
							}

	"NodeTest"			:	"NameTest"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeTest" : "NameTest"'
									puts "val: #{val.inspect}"
								end
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}
					|	"NodeType" "(" ")"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeTest" : "NodeType" "(" ")"'
									puts "val: #{val.inspect}"
								end
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}
					|	"processing-instruction" "(" "Literal" ")"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeTest" : "processing-instruction" "(" "Literal" ")"'
									puts "val: #{val.inspect}"
								end
								name_test_type = Rubyang::Xpath::NodeTest::NodeTestType::PROCESSING_INSTRUCTION
								result = Rubyang::Xpath::NodeTest.new name_test_type, val[0]
							}

	"Predicate"			:	"[" "PredicateExpr" "]"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Predicate" : "[" "PredicateExpr" "]"'
									puts "val: #{val.inspect}"
								end
								result = val[1]
							}

	"PredicateExpr"			:	"Expr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PredicateExpr" : "Expr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate.new val[0]
							}

	"AbbreviatedAbsoluteLocationPath" :	"//" "RelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedAbsoluteLocationPath" : "//" "RelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								raise "AbbreviatedAbsoluteLocationPath is not implemented"
								result = val[0]
							}

	"AbbreviatedRelativeLocationPath" :	"RelativeLocationPath" "//" "Step"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedRelativeLocationPath" : "RelativeLocationPath" "//" "Step"'
									puts "val: #{val.inspect}"
								end
								raise "AbbreviatedRelativeLocationPath is not implemented"
								result = val[0]
							}

	"AbbreviatedStep"		:	"."
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedStep" : "."'
									puts "val: #{val.inspect}"
								end
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::SELF
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, '*'
								predicates = Rubyang::Xpath::Predicates.new
								result = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
							}
					|	".."
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedStep" : ".."'
									puts "val: #{val.inspect}"
								end
								axis = Rubyang::Xpath::Axis.new Rubyang::Xpath::Axis::PARENT
								node_test = Rubyang::Xpath::NodeTest.new Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE, Rubyang::Xpath::NodeTest::NodeType::NODE
								predicates = Rubyang::Xpath::Predicates.new
								result = Rubyang::Xpath::LocationStep.new axis, node_test, predicates
							}

	"AbbreviatedAxisSpecifier"	:	/* */
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedAxisSpecifier" : '
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::CHILD
							}
					|	"@"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AbbreviatedAxisSpecifier" : "@"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Axis::ATTRIBUTE
							}

	"Expr"				:	"OrExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Expr" : "OrExpr"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"PrimaryExpr"			:	"VariableReference"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrimaryExpr" : "VariableReference"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								raise "VariableReference is not implemented"
							}
					|	"(" "Expr" ")"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrimaryExpr" : "(" "Expr" ")"'
									puts "val: #{val.inspect}"
								end
								result = val[1]
								raise "'(' Expr ')' is not implemented"
							}
					|	"Literal"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrimaryExpr" : "Literal"'
									puts "val: #{val.inspect}"
								end
								literal = Rubyang::Xpath::Predicate::Literal.new val[0]
								result = Rubyang::Xpath::Predicate::PrimaryExpr.new literal
							}
					|	"Number"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrimaryExpr" : "Number"'
									puts "val: #{val.inspect}"
								end
								number = Rubyang::Xpath::Predicate::Number.new val[0]
								result = Rubyang::Xpath::Predicate::PrimaryExpr.new number
							}
					|	"FunctionCall"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrimaryExpr" : "FunctionCall"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::PrimaryExpr.new val[0]
							}

	"FunctionCall"			:	"FunctionName(" ")"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionCall" : "FunctionName(" ")"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall.new val[0]
							}
					|	"FunctionName(" "Arguments" ")"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionCall" : "FunctionName(" "Arguments" ")"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall.new val[0], val[1]
							}

	"Arguments"			:	"Argument"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Arguments" : "Argument"'
									puts "val: #{val.inspect}"
								end
								result = [val[0]]
							}
					|	"Arguments" "," "Argument"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Arguments" : "Arguments" "," "Argument"'
									puts "val: #{val.inspect}"
								end
								result = val[0] + [val[1]]
							}

	"Argument"			:	"Exp"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Argument" : "Exp"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"UnionExpr"			:	"PathExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"UnionExpr" : "PathExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::UnionExpr.new val[0]
							}
					|	"UnionExpr" "|" "PathExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"UnionExpr" : "UnionExpr" "|" "PathExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::UnionExpr.new val[0], val[1], val[2]
							}

	"PathExpr"			:	"LocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PathExpr" : "LocationPath"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::PathExpr.new val[0]
							}
					|	"FilterExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PathExpr" : "FilterExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::PathExpr.new val[0]
							}
					|	"FilterExpr" "/" "RelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PathExpr" : "FilterExpr" "/" "RelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::PathExpr.new val[0], val[1], val[2]
							}
					|	"FilterExpr" "//" "RelativeLocationPath"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PathExpr" : "FilterExpr" "//" "RelativeLocationPath"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::PathExpr.new val[0], val[1], val[2]
							}

	"FilterExpr"			:	"PrimaryExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FilterExpr" : "PrimaryExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FilterExpr.new val[0]
							}
					|	"FilterExpr Predicat"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FilterExpr" : "FilterExpr Predicat"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FilterExpr.new val[0], val[1]
							}

	"OrExpr"			:	"AndExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"OrExpr" : "AndExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::OrExpr.new val[0]
							}
					|	"OrExpr" "or" "AndExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"OrExpr" : "OrExpr" "or" "AndExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::OrExpr.new val[0], val[2]
							}

	"AndExpr"			:	"EqualityExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AndExpr" : "EqualityExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::AndExpr.new val[0]
							}
					|	"AndExpr" "and" "EqualityExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AndExpr" : "AndExpr" "and" "EqualityExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::AndExpr.new val[0], val[2]
							}

	"EqualityExpr"			:	"RelationalExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"EqualityExpr" : "RelationalExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::EqualityExpr.new val[0]
							}
					|	"EqualityExpr" "=" "RelationalExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"EqualityExpr" : "EqualityExpr" "=" "RelationalExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::EqualityExpr.new val[0], val[1], val[2]
							}
					|	"EqualityExpr" "!=" "RelationalExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"EqualityExpr" : "EqualityExpr" "!=" "RelationalExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::EqualityExpr.new val[0], val[1], val[2]
							}

	"RelationalExpr"		:	"AdditiveExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelationalExpr" : "AdditiveExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::RelationalExpr.new val[0]
							}
					|	"RelationalExpr" "<" "AdditiveExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelationalExpr" : "RelationalExpr" "<" "AdditiveExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" ">" "AdditiveExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelationalExpr" : "RelationalExpr" ">" "AdditiveExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" "<=" "AdditiveExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelationalExpr" : "RelationalExpr" "<=" "AdditiveExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::RelationalExpr.new val[0], val[1], val[2]
							}
					|	"RelationalExpr" ">=" "AdditiveExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"RelationalExpr" : "RelationalExpr" ">=" "AdditiveExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::RelationalExpr.new val[0], val[1], val[2]
							}

	"AdditiveExpr"			:	"MultiplicativeExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AdditiveExpr" : "MultiplicativeExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::AdditiveExpr.new val[0]
							}
					|	"AdditiveExpr" "+" "MultiplicativeExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AdditiveExpr" : "AdditiveExpr" "+" "MultiplicativeExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::AdditiveExpr.new val[0], val[1], val[2]
							}
					|	"AdditiveExpr" "-" "MultiplicativeExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"AdditiveExpr" : "AdditiveExpr" "-" "MultiplicativeExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::AdditiveExpr.new val[0], val[1], val[2]
							}

	"MultiplicativeExpr"		:	"UnaryExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"MultiplicativeExpr" : "UnaryExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::MultiplicativeExpr.new val[0]
							}
					|	"MultiplicativeExpr" "*" "UnaryExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"MultiplicativeExpr" : "MultiplicativeExpr" "*" "UnaryExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::MultiplicativeExpr.new val[0], val[1], val[2]
							}
					|	"MultiplicativeExpr" "div" "UnaryExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"MultiplicativeExpr" : "MultiplicativeExpr" "div" "UnaryExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::MultiplicativeExpr.new val[0], val[1], val[2]
							}
					|	"MultiplicativeExpr" "mod" "UnaryExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"MultiplicativeExpr" : "MultiplicativeExpr" "mod" "UnaryExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::MultiplicativeExpr.new val[0], val[1], val[2]
							}

	"UnaryExpr"			:	"UnionExpr"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"UnaryExp" : "UnionExpr"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::UnaryExpr.new val[0]
							}
					|	"-" "UnaryExp"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"UnaryExp" : "-" "UnaryExp"'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::UnaryExpr.new val[1], val[0]
							}

	"Number"			:	"Digits"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Number" : "Digits"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}
					|	"Digits" "."
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Number" : "Digits" "."'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}
					|	"Digits" "." "Digits"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Number" : "Digits" "." "Digits"'
									puts "val: #{val.inspect}"
								end
								result = val[0] + val[1] + val[2]
							}
					|	"." "Digits"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Number" : "." "Digits"'
									puts "val: #{val.inspect}"
								end
								result = "0" + val[1] + val[2]
							}

	"FunctionName("			:	"last("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "last("'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"position("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "position("'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
								result = val[0]
							}
					|	"count("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "count("'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
								result = val[0]
							}
					|	"id("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "id("'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
								result = val[0]
							}
					|	"local-name("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "local-name("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"namespace-uri("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "namespace-uri("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"name("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "name("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"string("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "string("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"concat("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "concat("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"starts-with("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "starts-with("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"contains("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "contains("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"substring-before("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "substring-before("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"substring-after("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "substring-after("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"substring("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "substring("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"string-length("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "string-length("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"normalize-space("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "normalize-space("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"translate("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "translate("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"boolean("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "boolean("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"not("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "not("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"true("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "true("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"false("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "false("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"lang("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "lang("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"number("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "number("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"sum("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "sum("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"floor("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "floor("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"ceiling("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "ceiling("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"round("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "round("'
									puts "val: #{val.inspect}"
								end
								result = val[0]
								result = Rubyang::Xpath::Predicate::FunctionCall::LAST
							}
					|	"current("
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"FunctionName(" : "current("'
									puts "val: #{val.inspect}"
								end
								result = Rubyang::Xpath::Predicate::FunctionCall::CURRENT
							}

	"VariableReference"		:	"$" "QName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"VariableReference" : "$" "QName"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"NameTest"			:	"*"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NameTest" : "*"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NameTest.new '*'
							}
					|	"NCName" ":" "*"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NameTest" : "NCName" ":" "*"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NameTest.new "#{val[0]}:*"
							}
					|	"QName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NameTest" : "QName"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NameTest.new val[0]
							}

	"NodeType"			:	"comment"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeType" : "comment"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NodeType::COMMENT
							}
					|	"text"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeType" : "text"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NodeType::TEXT
							}
					|	"node"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"NodeType" : "node"'
									puts "val: #{val.inspect}"
								end
								Rubyang::Xpath::NodeTest::NodeType::NODE
							}

	"QName"				:	"PrefixedName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"QName" : "PrefixedName"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}
					|	"UnprefixedName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"QName" : "UnprefixedName"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"PrefixedName"			:	"Prefix" ":" "LocalPart"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"PrefixedName" : "Prefix" ":" "LocalPart"'
									puts "val: #{val.inspect}"
								end
								result = val[0] + val[1] + val[2]
							}

	"UnprefixedName"		:	"LocalPart"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"UnprefixedName" : "LocalPart"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"Prefix"			:	"NCName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"Prefix" : "NCName"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}

	"LocalPart"			:	"NCName"
							{
								if Rubyang::Xpath::Parser::DEBUG
									puts '"LocalPart" : "NCName"'
									puts "val: #{val.inspect}"
								end
								result = val[0]
							}
end
