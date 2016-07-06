# coding: utf-8

require 'spec_helper'

require 'yaml'

describe Rubyang::Xpath do
	describe Rubyang::Xpath::BasicType do
		#describe NodeSet do
		#context '# ' do
		#let( :predicates1 ){ Rubyang::Xpath::Predicates.new }
		#subject { Rubyang::Xpath::Parser.parse( xpath_str ).to_yaml }
		#it { is_expected.to eq xpath_yaml }
		#end

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
