# coding: utf-8

require 'spec_helper'

require 'yaml'

describe Rubyang::Xpath do
	describe Rubyang::Xpath::BasicType do
		let( :yang_str_m0 ){
			<<-EOB
				module m0 {
					namespace "http://m0.rspec/";
					prefix m0;
					leaf leaf0 { type string; }
					leaf leaf_ { type string; }
				}
			EOB
		}
		let( :yang_str_m1 ){
			<<-EOB
				module m1 {
					namespace "http://m1.rspec/";
					prefix m1;
					leaf leaf1 { type string; }
					leaf leafA { type string; }
				}
			EOB
		}
		let( :yang_str_m2 ){
			<<-EOB
				module m2 {
					namespace "http://m2.rspec/";
					prefix m2;
					leaf leaf2 { type string; }
					leaf leafB { type string; }
				}
			EOB
		}
		let( :db_config ){
			db = Rubyang::Database.new
			db.load_model Rubyang::Model::Parser.parse( yang_str_m0 )
			db.load_model Rubyang::Model::Parser.parse( yang_str_m1 )
			db.load_model Rubyang::Model::Parser.parse( yang_str_m2 )
			db.configure
		}
		let( :leaf0 ){ db_config.edit( 'leaf0' ).set( '0' ); db_config.edit( 'leaf0' ) }
		let( :leaf1 ){ db_config.edit( 'leaf1' ).set( '1' ); db_config.edit( 'leaf1' ) }
		let( :leaf2 ){ db_config.edit( 'leaf2' ).set( '2' ); db_config.edit( 'leaf2' ) }
		let( :leaf_ ){ db_config.edit( 'leaf_' ).set( ''  ); db_config.edit( 'leaf_' ) }
		let( :leafA ){ db_config.edit( 'leafA' ).set( 'A' ); db_config.edit( 'leafA' ) }
		let( :leafB ){ db_config.edit( 'leafB' ).set( 'B' ); db_config.edit( 'leafB' ) }

		describe Rubyang::Xpath::BasicType::NodeSet do
			describe '#initialize' do
				context '' do
					let( :result ){ Rubyang::Xpath::BasicType::NodeSet.new }
					subject { result.value }
					it { is_expected.to eq [] }
				end

				context '[]' do
					let( :result ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
					subject { result.value }
					it { is_expected.to eq [] }
				end

				context 'leaf1' do
					let( :result ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
					subject { result.value }
					it { is_expected.to eq [leaf1] }
				end

				context 'leaf1, leaf2' do
					let( :result ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
					subject { result.value }
					it { is_expected.to eq [leaf1, leaf2] }
				end
			end

			describe '#to_boolean' do
				let( :result ){ node_set.to_boolean }
				context '' do
					let( :node_set ){ Rubyang::Xpath::BasicType::NodeSet.new }
					subject { result.value }
					it { is_expected.to eq false }
				end

				context '[]' do
					let( :node_set ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
					subject { result.value }
					it { is_expected.to eq false }
				end

				context 'leaf1' do
					let( :node_set ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
					subject { result.value }
					it { is_expected.to eq true }
				end

				context 'leaf1, leaf2' do
					let( :node_set ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
					subject { result.value }
					it { is_expected.to eq true }
				end
			end

			describe '#==' do
				let( :result ){ left == right }

				describe 'left _' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left []' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leaf_]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leafA]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leaf0]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leaf1]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leafA, leafB]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leafA, leaf1]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left [leaf1, leaf2]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end
			end

			describe '#!=' do
				let( :result ){ left != right }

				describe 'left _' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left []' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leaf_]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leafA]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leaf0]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leaf1]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leafA, leafB]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leafA, leaf1]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left [leaf1, leaf2]' do
					let( :left ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
					context 'right NodeSet.new' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf_])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf_] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf0])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf0] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leafA, leafB])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leafB] }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right NodeSet.new([leafA, leaf1])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leafA, leaf1] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right NodeSet.new([leaf1, leaf2])' do
						let( :right ){ Rubyang::Xpath::BasicType::NodeSet.new [leaf1, leaf2] }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(true)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(-1)' do
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'A\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'A' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'0\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '0' }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '1' }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'-1\')' do
						let( :right ){ Rubyang::Xpath::BasicType::String.new '-1' }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end
			end
		end

		describe Rubyang::Xpath::BasicType::Boolean do
			describe '#initialize' do
				context 'true' do
					let( :result ){ Rubyang::Xpath::BasicType::Boolean.new true }
					subject { result.value }
					it { is_expected.to eq true }
				end

				context 'false' do
					let( :result ){ Rubyang::Xpath::BasicType::Boolean.new false }
					subject { result.value }
					it { is_expected.to eq false }
				end
			end

			describe '#and' do
				describe 'left true' do
					context 'right Boolean.new(true)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left false' do
					context 'right Boolean.new(true)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Boolean.new(false)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left.and right }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end
			end

			describe '#or' do
				describe 'left true' do
					context 'right Boolean.new(true)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end

				describe 'left false' do
					context 'right Boolean.new(true)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new true }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right Boolean.new(false)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Boolean.new false }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left.or right }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end
			end
		end

		describe Rubyang::Xpath::BasicType::Number do
			describe '#initialize' do
				context '0' do
					let( :result ){ Rubyang::Xpath::BasicType::Number.new 0 }
					subject { result.value }
					it { is_expected.to eq Float(0) }
				end

				context '1' do
					let( :result ){ Rubyang::Xpath::BasicType::Number.new 1 }
					subject { result.value }
					it { is_expected.to eq Float(1) }
				end

				context '-1' do
					let( :result ){ Rubyang::Xpath::BasicType::Number.new -1 }
					subject { result.value }
					it { is_expected.to eq Float(-1) }
				end
			end

			describe '#-@' do
				context '0' do
					let( :result ){ - Rubyang::Xpath::BasicType::Number.new( 0 ) }
					subject { result.value }
					it { is_expected.to eq (- Float(0)) }
				end

				context '1' do
					let( :result ){ - Rubyang::Xpath::BasicType::Number.new( 1 ) }
					subject { result.value }
					it { is_expected.to eq (- Float(1)) }
				end

				context '-1' do
					let( :result ){ - Rubyang::Xpath::BasicType::Number.new( -1 ) }
					subject { result.value }
					it { is_expected.to eq (- Float(-1)) }
				end
			end

			describe '#+' do
				describe 'left 0' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) + Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) + Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) + Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) + Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) + Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) + Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) + Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) + Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left + right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) + Float( -1 ) }
					end
				end
			end

			describe '#-' do
				describe 'left 0' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) - Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) - Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) - Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) - Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) - Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) - Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) - Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) - Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left - right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) - Float( -1 ) }
					end
				end
			end

			describe '#*' do
				describe 'left 0' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) * Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) * Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) * Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) * Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) * Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) * Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) * Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) * Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left * right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) * Float( -1 ) }
					end
				end
			end

			describe '#/' do
				describe 'left 0' do
					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) / Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) / Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) / Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) / Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) / Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) / Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) / Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left / right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) / Float( -1 ) }
					end
				end
			end

			describe '#==' do
				describe 'left 0' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) == Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) == Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) == Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) == Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) == Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) == Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) == Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) == Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) == Float( -1 ) }
					end
				end
			end

			describe '#!=' do
				describe 'left 0' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) != Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) != Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 0 ) != Float( -1 ) }
					end
				end

				describe 'left 1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) != Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) != Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( 1 ) != Float( -1 ) }
					end
				end

				describe 'left -1' do
					context 'right Number.new(0)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 0 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) != Float( 0 ) }
					end

					context 'right Number.new(1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new 1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) != Float( 1 ) }
					end

					context 'right Number.new(-1)' do
						let( :left  ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :right ){ Rubyang::Xpath::BasicType::Number.new -1 }
						let( :result ){ left != right }
						subject { result.value }
						it { is_expected.to eq Float( -1 ) != Float( -1 ) }
					end
				end
			end
		end

		describe Rubyang::Xpath::BasicType::String do
			describe '#initialize' do
				context '' do
					let( :result ){ Rubyang::Xpath::BasicType::String.new '' }
					subject { result.value }
					it { is_expected.to eq '' }
				end

				context 'a' do
					let( :result ){ Rubyang::Xpath::BasicType::String.new 'a' }
					subject { result.value }
					it { is_expected.to eq 'a' }
				end
			end

			describe '#==' do
				describe 'left \'\'' do
					context 'right String.new(\'\')' do
						let( :left  ){ Rubyang::Xpath::BasicType::String.new '' }
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq true }
					end

					context 'right String.new(\'a\')' do
						let( :left  ){ Rubyang::Xpath::BasicType::String.new '' }
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'a' }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq false }
					end
				end

				describe 'left \'a\'' do
					context 'right String.new(\'\')' do
						let( :left  ){ Rubyang::Xpath::BasicType::String.new 'a' }
						let( :right ){ Rubyang::Xpath::BasicType::String.new '' }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq false }
					end

					context 'right String.new(\'a\')' do
						let( :left  ){ Rubyang::Xpath::BasicType::String.new 'a' }
						let( :right ){ Rubyang::Xpath::BasicType::String.new 'a' }
						let( :result ){ left == right }
						subject { result.value }
						it { is_expected.to eq true }
					end
				end
			end
		end
	end
end
