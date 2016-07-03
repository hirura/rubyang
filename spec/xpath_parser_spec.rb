# coding: utf-8

require 'spec_helper'

require 'yaml'

describe Rubyang::Xpath do
	let( :xpath_yaml )        { xpath.to_yaml }

	describe 'module-stmt' do
		context 'with module-header-stmts' do
			let( :xpath_str ){ '../leaf' }
			let( :xpath ){ expr }
			let( :expr ){ Rubyang::Xpath::Expr.new( or_expr ) }
			let( :or_expr ){ Rubyang::Xpath::OrExpr.new( and_expr ) }
			let( :and_expr ){ Rubyang::Xpath::AndExpr.new( equality_expr ) }
			let( :equality_expr ){ Rubyang::Xpath::EqualityExpr.new( relational_expr ) }
			let( :relational_expr ){ Rubyang::Xpath::RelationalExpr.new( additive_expr ) }
			let( :additive_expr ){ Rubyang::Xpath::AdditiveExpr.new( multiplicative_expr ) }
			let( :multiplicative_expr ){ Rubyang::Xpath::MultiplicativeExpr.new( unary_expr ) }
			let( :unary_expr ){ Rubyang::Xpath::UnaryExpr.new( union_expr ) }
			let( :union_expr ){ Rubyang::Xpath::UnionExpr.new( path_expr ) }
			let( :path_expr ){ Rubyang::Xpath::PathExpr.new( location_path ) }
			let( :location_path ){ Rubyang::Xpath::LocationPath.new( location_step0, location_step1 ) }
			let( :location_step0 ){ Rubyang::Xpath::LocationStep.new( axis0, nodetest0, predicates0 ) }
			let( :axis0 ){ Rubyang::Xpath::Axis.new( 'parent' ) }
			let( :nodetest0 ){ Rubyang::Xpath::NodeTest.new( Rubyang::Xpath::NodeTest::NodeTestType::NODE_TYPE, 'node' ) }
			let( :predicates0 ){ Rubyang::Xpath::Predicates.new }
			let( :location_step1 ){ Rubyang::Xpath::LocationStep.new( axis1, nodetest1, predicates1 ) }
			let( :axis1 ){ Rubyang::Xpath::Axis.new( 'child' ) }
			let( :nodetest1 ){ Rubyang::Xpath::NodeTest.new( Rubyang::Xpath::NodeTest::NodeTestType::NAME_TEST, 'leaf' ) }
			let( :predicates1 ){ Rubyang::Xpath::Predicates.new }
			subject { Rubyang::Xpath::Parser.parse( xpath_str ).to_yaml }
			it { is_expected.to eq xpath_yaml }
		end
	end
end
