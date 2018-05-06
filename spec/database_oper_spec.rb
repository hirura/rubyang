# coding: utf-8

require 'spec_helper'

require 'rexml/document'
require 'rexml/formatters/pretty'
require 'json'

describe Rubyang::Database do
	context 'with config false' do
		let( :config_doc_xml_pretty ){
			pretty_formatter = REXML::Formatters::Pretty.new( 2 )
			pretty_formatter.compact = true
			output = ''
			pretty_formatter.write( config_doc_xml, output )
			output
		}
		let( :config_doc_xml ){
			REXML::Document.new
		}
		let( :config_root_xml ){
			root_xml = config_doc_xml.add_element( 'config' )
			root_xml.add_namespace( config_root_xml_namespace )
			root_xml
		}
		let( :config_root_xml_namespace ){
			'http://rubyang/0.1'
		}
		let( :config_doc_json_pretty ){
			JSON.pretty_generate( config_doc_hash )
		}
		let( :config_doc_json ){
			JSON.generate( config_doc_hash )
		}
		let( :config_doc_hash ){
			Hash.new
		}
		let( :config_root_hash ){
			config_doc_hash['config'] = Hash.new
			root_hash = config_doc_hash['config']
			root_hash
		}

		let( :oper_doc_xml_pretty ){
			pretty_formatter = REXML::Formatters::Pretty.new( 2 )
			pretty_formatter.compact = true
			output = ''
			pretty_formatter.write( oper_doc_xml, output )
			output
		}
		let( :oper_doc_xml ){
			REXML::Document.new
		}
		let( :oper_root_xml ){
			root_xml = oper_doc_xml.add_element( 'oper' )
			root_xml.add_namespace( oper_root_xml_namespace )
			root_xml
		}
		let( :oper_root_xml_namespace ){
			'http://rubyang/0.1'
		}
		let( :oper_doc_json_pretty ){
			JSON.pretty_generate( oper_doc_hash )
		}
		let( :oper_doc_json ){
			JSON.generate( oper_doc_hash )
		}
		let( :oper_doc_hash ){
			Hash.new
		}
		let( :oper_root_hash ){
			oper_doc_hash['oper'] = Hash.new
			root_hash = oper_doc_hash['oper']
			root_hash
		}

		let( :db ){ Rubyang::Database.new }

		describe 'to_xml' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf config-leaf1 {
							type int8;
						}
						leaf config-leaf2 {
							config true;
							type int8;
						}
						leaf oper-leaf1 {
							config false;
							type int8;
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :config_leaf1_element ){ config_root_xml.add_element( 'config-leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :config_leaf1_text ){ config_leaf1_element.add_text( value ) }
			let!( :config_leaf2_element ){ config_root_xml.add_element( 'config-leaf2' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :config_leaf2_text ){ config_leaf2_element.add_text( value ) }
			let!( :oper_leaf1_element ){ oper_root_xml.add_element( 'oper-leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :oper_leaf1_text ){ oper_leaf1_element.add_text( value ) }

			context 'with config' do
				subject {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					config = db.configure
					config.edit( 'config-leaf1' ).set( value )
					config.edit( 'config-leaf2' ).set( value )
					config.to_xml( pretty: true )
				}
				it { is_expected.to eq config_doc_xml_pretty }
			end
			context 'with oper' do
				subject {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					oper = db.oper
					oper.edit( 'oper-leaf1' ).set( value )
					oper.to_xml( pretty: true )
				}
				it { is_expected.to eq oper_doc_xml_pretty }
			end
			context 'with incorrect config' do
				subject { -> {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					config = db.configure
					config.edit( 'oper-leaf1' ).set( value )
				} }
				it { is_expected.to raise_exception Exception }
			end
			context 'with explicit incorrect oper' do
				subject { -> {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					oper = db.oper
					oper.edit( 'config-leaf1' ).set( value )
				} }
				it { is_expected.to raise_exception Exception }
			end
			context 'with implicit incorrect oper' do
				subject { -> {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					oper = db.oper
					oper.edit( 'config-leaf2' ).set( value )
				} }
				it { is_expected.to raise_exception Exception }
			end
		end

		describe 'to_json' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf config-leaf1 {
							type int8;
						}
						leaf config-leaf2 {
							config true;
							type int8;
						}
						leaf oper-leaf1 {
							config false;
							type int8;
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :config_leaf1_element ){ config_root_hash['config-leaf1'] = value }
			let!( :config_leaf2_element ){ config_root_hash['config-leaf2'] = value }
			let!( :oper_leaf1_element ){ oper_root_hash['oper-leaf1'] = value }

			context 'with config' do
				subject {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					config = db.configure
					config.edit( 'config-leaf1' ).set( value )
					config.edit( 'config-leaf2' ).set( value )
					config.to_json( pretty: true )
				}
				it { is_expected.to eq config_doc_json_pretty }
			end
			context 'with oper' do
				subject {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					oper = db.oper
					oper.edit( 'oper-leaf1' ).set( value )
					oper.to_json( pretty: true )
				}
				it { is_expected.to eq oper_doc_json_pretty }
			end
			context 'with incorrect config' do
				subject { -> {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					config = db.configure
					config.edit( 'oper-leaf1' ).set( value )
				} }
				it { is_expected.to raise_exception Exception }
			end
			context 'with incorrect oper' do
				subject { -> {
					db.load_model Rubyang::Model::Parser.parse( yang_str )
					oper = db.oper
					oper.edit( 'config-leaf1' ).set( value )
				} }
				it { is_expected.to raise_exception Exception }
			end
		end

		describe 'load_merge_xml' do
			context 'only leaf' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf config-leaf1 {
								type int8;
							}
							leaf config-leaf2 {
								config true;
								type int8;
							}
							leaf oper-leaf1 {
								config false;
								type int8;
							}
						}
					EOB
				}
				let( :value ){ '0' }
				let!( :config_leaf1_element ){ config_root_xml.add_element( 'config-leaf1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :config_leaf1_text ){ config_leaf1_element.add_text( value ) }
				let!( :config_leaf2_element ){ config_root_xml.add_element( 'config-leaf2' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :config_leaf2_text ){ config_leaf2_element.add_text( value ) }
				let!( :oper_leaf1_element ){ oper_root_xml.add_element( 'oper-leaf1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :oper_leaf1_text ){ oper_leaf1_element.add_text( value ) }

				context 'with config' do
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						config.load_merge_xml config_doc_xml_pretty
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq config_doc_xml_pretty }
				end
				context 'with oper' do
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end
				context 'with incorrect config' do
					subject { -> {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						config.load_merge_xml oper_doc_xml_pretty
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with incorrect oper' do
					subject { -> {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml config_doc_xml_pretty
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			context 'with implicit config container' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							container config-container1 {
								leaf config-leaf1 {
									type int8;
								}
								leaf config-leaf2 {
									config true;
									type int8;
								}
								leaf oper-leaf1 {
									config false;
									type int8;
								}
							}
						}
					EOB
				}

				context "when only config leaves are in the container" do
					let( :value ){ '0' }
					let!( :config_container1_element ){ config_root_xml.add_element( 'config-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :config_leaf1_element ){ config_container1_element.add_element( 'config-leaf1' ) }
					let!( :config_leaf1_text ){ config_leaf1_element.add_text( value ) }
					let!( :config_leaf2_element ){ config_container1_element.add_element( 'config-leaf2' ) }
					let!( :config_leaf2_text ){ config_leaf2_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						config.load_merge_xml config_doc_xml_pretty
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq config_doc_xml_pretty }
				end

				context "when an oper leaf is in the container" do
					let( :value ){ '0' }
					let!( :config_container1_element ){ oper_root_xml.add_element( 'config-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :oper_leaf1_element ){ config_container1_element.add_element( 'oper-leaf1' ) }
					let!( :oper_leaf1_text ){ oper_leaf1_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end
			end

			context 'with config container' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							container config-container1 {
								config true;
								leaf config-leaf1 {
									type int8;
								}
								leaf config-leaf2 {
									config true;
									type int8;
								}
								leaf oper-leaf1 {
									config false;
									type int8;
								}
							}
						}
					EOB
				}

				context "when only config leaves are in the container" do
					let( :value ){ '0' }
					let!( :config_container1_element ){ config_root_xml.add_element( 'config-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :config_leaf1_element ){ config_container1_element.add_element( 'config-leaf1' ) }
					let!( :config_leaf1_text ){ config_leaf1_element.add_text( value ) }
					let!( :config_leaf2_element ){ config_container1_element.add_element( 'config-leaf2' ) }
					let!( :config_leaf2_text ){ config_leaf2_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						config.load_merge_xml config_doc_xml_pretty
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq config_doc_xml_pretty }
				end

				context "when an oper leaf is in the container" do
					let( :value ){ '0' }
					let!( :config_container1_element ){ oper_root_xml.add_element( 'config-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :oper_leaf1_element ){ config_container1_element.add_element( 'oper-leaf1' ) }
					let!( :oper_leaf1_text ){ oper_leaf1_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end
			end

			context 'with oper container' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							container oper-container1 {
								config false;
								leaf oper-leaf1 {
									type int8;
								}
								leaf oper-leaf2 {
									config false;
									type int8;
								}
							}
						}
					EOB
				}

				context "when only oper leaves are in the container" do
					let( :value ){ '0' }
					let!( :oper_container1_element ){ oper_root_xml.add_element( 'oper-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :oper_leaf2_element ){ oper_container1_element.add_element( 'oper-leaf2' ) }
					let!( :oper_leaf2_text ){ oper_leaf2_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end

				context "when both implicit oper leaf and explicit oper leaf are in the container" do
					let( :value ){ '0' }
					let!( :oper_container1_element ){ oper_root_xml.add_element( 'oper-container1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :oper_leaf1_element ){ oper_container1_element.add_element( 'oper-leaf1' ) }
					let!( :oper_leaf1_text ){ oper_leaf1_element.add_text( value ) }
					let!( :oper_leaf2_element ){ oper_container1_element.add_element( 'oper-leaf2' ) }
					let!( :oper_leaf2_text ){ oper_leaf2_element.add_text( value ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end

			end

			context 'with implicit config list' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							list config-list1 {
								key config-leaf1;
								leaf config-leaf1 {
									type string;
								}
								leaf config-leaf2 {
									config true;
									type string;
								}
								leaf oper-leaf3 {
									config false;
									type string;
								}
							}
						}
					EOB
				}

				let!( :value1 ){ '1' }
				let!( :value2 ){ '2' }

				let!( :config_list1_element1 ){ config_root_xml.add_element( 'config-list1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :config_leaf1_element1 ){ config_list1_element1.add_element( 'config-leaf1' ) }
				let!( :config_leaf1_element1_text ){ config_leaf1_element1.add_text( value1 ) }
				let!( :config_leaf2_element1 ){ config_list1_element1.add_element( 'config-leaf2' ) }
				let!( :config_leaf2_element1_text ){ config_leaf2_element1.add_text( value1 ) }
				let!( :config_list1_element2 ){ config_root_xml.add_element( 'config-list1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :config_leaf1_element2 ){ config_list1_element2.add_element( 'config-leaf1' ) }
				let!( :config_leaf1_element2_text ){ config_leaf1_element2.add_text( value2 ) }
				let!( :config_leaf2_element2 ){ config_list1_element2.add_element( 'config-leaf2' ) }
				let!( :config_leaf2_element2_text ){ config_leaf2_element2.add_text( value2 ) }

				let!( :oper_list1_element1 ){ oper_root_xml.add_element( 'config-list1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :oper_leaf1_element1 ){ oper_list1_element1.add_element( 'config-leaf1' ) }
				let!( :oper_leaf1_element1_text ){ oper_leaf1_element1.add_text( value1 ) }
				let!( :oper_leaf3_element1 ){ oper_list1_element1.add_element( 'oper-leaf3' ) }
				let!( :oper_leaf3_element1_text ){ oper_leaf3_element1.add_text( value1 ) }
				let!( :oper_list1_element2 ){ oper_root_xml.add_element( 'config-list1' ).add_namespace( 'http://module1.rspec/' ) }
				let!( :oper_leaf1_element2 ){ oper_list1_element2.add_element( 'config-leaf1' ) }
				let!( :oper_leaf1_element2_text ){ oper_leaf1_element2.add_text( value2 ) }
				let!( :oper_leaf3_element2 ){ oper_list1_element2.add_element( 'oper-leaf3' ) }
				let!( :oper_leaf3_element2_text ){ oper_leaf3_element2.add_text( value2 ) }

				context "when only config leaves are in the list" do
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						config.load_merge_xml config_doc_xml_pretty
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq config_doc_xml_pretty }
				end

				context "when an oper leaf is in the list" do
					subject { -> {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			context 'with oper list' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							list oper-list1 {
								config false;
								key config-leaf1;
								leaf config-leaf1 {
									type string;
								}
								leaf oper-leaf1 {
									config false;
									type string;
								}
							}
						}
					EOB
				}

				let!( :value1 ){ '1' }
				let!( :value2 ){ '2' }

				context "when only config leaves are in the list" do
					let( :value1 ){ '1' }
					let( :value2 ){ '2' }
					let!( :oper_list1_element1 ){ oper_root_xml.add_element( 'oper-list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :config_leaf1_element1 ){ oper_list1_element1.add_element( 'config-leaf1' ) }
					let!( :config_leaf1_element1_text ){ config_leaf1_element1.add_text( value1 ) }
					let!( :oper_leaf1_element1 ){ oper_list1_element1.add_element( 'oper-leaf1' ) }
					let!( :oper_leaf1_element1_text ){ oper_leaf1_element1.add_text( value1 ) }
					let!( :oper_list1_element2 ){ oper_root_xml.add_element( 'oper-list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :config_leaf1_element2 ){ oper_list1_element2.add_element( 'config-leaf1' ) }
					let!( :config_leaf1_element2_text ){ config_leaf1_element2.add_text( value2 ) }
					let!( :oper_leaf1_element2 ){ oper_list1_element2.add_element( 'oper-leaf1' ) }
					let!( :oper_leaf1_element2_text ){ oper_leaf1_element2.add_text( value2 ) }

					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						oper = db.oper
						oper.load_merge_xml oper_doc_xml_pretty
						oper.to_xml( pretty: true )
					}
					it { is_expected.to eq oper_doc_xml_pretty }
				end

				# TODO: may support a list with no key
				#context 'with no key' do
				#end
			end
		end

		describe 'load_merge_json' do
		end

		describe 'revert configuration' do
		end

		describe '#edit' do
		end

		describe '#edit_xpath' do
		end
	end
end
