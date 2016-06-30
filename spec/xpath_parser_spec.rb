# coding: utf-8

require 'spec_helper'

describe Rubyang::Xpath do
	let( :xpath_yaml )        { xpath.to_yaml }

	describe 'module-stmt' do
		context 'with module-header-stmts' do
			let( :xpath_str ){ '../leaf' }
			let( :xpath ){ location_steps }
			let( :location_steps ){ Rubyang::Xpath::LocationSteps.new( location_step0, location_step1 ) }
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
