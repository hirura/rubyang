# coding: utf-8

require 'spec_helper'

require 'rexml/document'
require 'rexml/formatters/pretty'
require 'json'

describe Rubyang::Database do
	let( :doc_xml_pretty ){
		pretty_formatter = REXML::Formatters::Pretty.new( 2 )
		pretty_formatter.compact = true
		output = ''
		pretty_formatter.write( doc_xml, output )
		output
	}
	let( :doc_xml ){
		REXML::Document.new
	}
	let( :root_xml ){
		root_xml = doc_xml.add_element( 'config' )
		root_xml.add_namespace( root_xml_namespace )
		root_xml
	}
	let( :root_xml_namespace ){
		'http://rubyang/config/0.1'
	}

	let( :doc_json_pretty ){
		JSON.pretty_generate( doc_hash )
	}
	let( :doc_json ){
		JSON.generate( doc_hash )
	}
	let( :doc_hash ){
		Hash.new
	}
	let( :root_hash ){
		doc_hash['config'] = Hash.new
		root_hash = doc_hash['config']
		root_hash
	}

	let( :db ){ Rubyang::Database.new }

	describe 'to_xml' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 { type int8; }
				}
			EOB
		}
		let( :value ){ '0' }
		let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
		let!( :leaf1_text ){ leaf1_element.add_text( value ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str )
			config = db.configure
			config.edit( 'leaf1' ).set( value )
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe 'to_json' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 { type int8; }
				}
			EOB
		}
		let( :value ){ '0' }
		let!( :leaf1 ){ root_hash['leaf1'] = value }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str )
			config = db.configure
			config.edit( 'leaf1' ).set( value )
			config.to_json( pretty: true )
		}
		it { is_expected.to eq doc_json_pretty }
	end

	describe 'load_merge_xml' do
		describe 'only leaf' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_xml doc_xml_pretty
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with container' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_xml doc_xml_pretty
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with list' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
						list list1 {
							key leaf3;
							leaf leaf3 { type string; }
							leaf leaf4 { type string; }
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element ){ list1_element.add_element( 'leaf3' ) }
			let!( :leaf3_text ){ leaf3_element.add_text( value ) }
			let!( :leaf4_element ){ list1_element.add_element( 'leaf4' ) }
			let!( :leaf4_text ){ leaf4_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_xml doc_xml_pretty
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with list 2' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
						list list1 {
							key leaf3;
							leaf leaf3 { type string; }
							leaf leaf4 { type string; }
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			let!( :list1_element_1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element_1 ){ list1_element_1.add_element( 'leaf3' ) }
			let!( :leaf3_text_1 ){ leaf3_element_1.add_text( value + '-1' ) }
			let!( :leaf4_element_1 ){ list1_element_1.add_element( 'leaf4' ) }
			let!( :leaf4_text_1 ){ leaf4_element_1.add_text( value ) }
			let!( :list1_element_2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element_2 ){ list1_element_2.add_element( 'leaf3' ) }
			let!( :leaf3_text_2 ){ leaf3_element_2.add_text( value + '-2' ) }
			let!( :leaf4_element_2 ){ list1_element_2.add_element( 'leaf4' ) }
			let!( :leaf4_text_2 ){ leaf4_element_2.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_xml doc_xml_pretty
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'load_merge_json' do
		describe 'only leaf' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let( :doc_json ){
				h = Hash.new
				h[:config] = Hash.new
				h[:config][:leaf1] = value
				h.to_json
			}
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_json doc_json
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with container' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			let( :doc_json ){
				h = Hash.new
				h[:config] = Hash.new
				h[:config][:leaf1] = value
				h[:config][:container1] = Hash.new
				h[:config][:container1][:leaf2] = value
				h.to_json
			}
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_json doc_json
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with list' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
						list list1 {
							key leaf3;
							leaf leaf3 { type string; }
							leaf leaf4 { type string; }
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element ){ list1_element.add_element( 'leaf3' ) }
			let!( :leaf3_text ){ leaf3_element.add_text( value ) }
			let!( :leaf4_element ){ list1_element.add_element( 'leaf4' ) }
			let!( :leaf4_text ){ leaf4_element.add_text( value ) }
			let( :doc_json ){
				h = Hash.new
				h[:config] = Hash.new
				h[:config][:leaf1] = value
				h[:config][:container1] = Hash.new
				h[:config][:container1][:leaf2] = value
				h[:config][:list1] = Array.new
				h[:config][:list1].push Hash.new
				h[:config][:list1].last[:leaf3] = value
				h[:config][:list1].last[:leaf4] = value
				h.to_json
			}
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_json doc_json
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end

		describe 'with list 2' do
			let( :yang_str ){
				<<-EOB
					module module1 {
						namespace "http://module1.rspec/";
						prefix module1;
						leaf leaf1 { type int8; }
						container container1 { leaf leaf2 { type string; } }
						list list1 {
							key leaf3;
							leaf leaf3 { type string; }
							leaf leaf4 { type string; }
						}
					}
				EOB
			}
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			let!( :list1_element_1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element_1 ){ list1_element_1.add_element( 'leaf3' ) }
			let!( :leaf3_text_1 ){ leaf3_element_1.add_text( value + '-1' ) }
			let!( :leaf4_element_1 ){ list1_element_1.add_element( 'leaf4' ) }
			let!( :leaf4_text_1 ){ leaf4_element_1.add_text( value ) }
			let!( :list1_element_2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf3_element_2 ){ list1_element_2.add_element( 'leaf3' ) }
			let!( :leaf3_text_2 ){ leaf3_element_2.add_text( value + '-2' ) }
			let!( :leaf4_element_2 ){ list1_element_2.add_element( 'leaf4' ) }
			let!( :leaf4_text_2 ){ leaf4_element_2.add_text( value ) }
			let( :doc_json ){
				h = Hash.new
				h[:config] = Hash.new
				h[:config][:leaf1] = value
				h[:config][:container1] = Hash.new
				h[:config][:container1][:leaf2] = value
				h[:config][:list1] = Array.new
				h[:config][:list1].push Hash.new
				h[:config][:list1].last[:leaf3] = value + '-1'
				h[:config][:list1].last[:leaf4] = value
				h[:config][:list1].push Hash.new
				h[:config][:list1].last[:leaf3] = value + '-2'
				h[:config][:list1].last[:leaf4] = value
				h.to_json
			}
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.load_merge_json doc_json
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'revert configuration' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 { type int8; }
				}
			EOB
		}
		let( :value ){ '0' }
		let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
		let!( :leaf1_text ){ leaf1_element.add_text( value ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str )
			config = db.configure
			config.edit( 'leaf1' ).set value
			config.commit
			config.edit( 'leaf1' ).set '-1'
			config.revert
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe '#edit' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 { type int8; }
				}
			EOB
		}
		context 'when valid element' do
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit 'leaf1'
				leaf1.set value
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'when invalid element' do
			let( :value ){ '128' }
			subject { ->{
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit 'leaf2'
			} }
			it { is_expected.to raise_exception Exception }
		end
	end

	describe '#edit_xpath' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 { type int8; }
				}
			EOB
		}
		context 'when valid element' do
			let( :value ){ '0' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.edit 'leaf1'
				leaf1 = config.edit_xpath '/leaf1'
				leaf1.set value
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'when invalid element' do
			let( :value ){ '128' }
			subject { ->{
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit_xpath '/leaf2'
			} }
			it { is_expected.to raise_exception Exception }
		end
	end

	describe 'temporal list 2' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					list list1 {
						key leaf1;
						leaf leaf1 {
							type int8;
						}
					}
				}
			EOB
		}
		context 'with valid value: 0, 1' do
			let!( :list1_element1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element1 ){ list1_element1.add_element( 'leaf1' ) }
			let!( :leaf1_text1 ){ leaf1_element1.add_text( '0' ) }
			let!( :list1_element2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element2 ){ list1_element2.add_element( 'leaf1' ) }
			let!( :leaf1_text2 ){ leaf1_element2.add_text( '1' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.edit( 'list1' ).edit( '0' )
				config.edit( 'list1' ).edit( '1' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal list 2' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					list list1 {
						key "leaf1 leaf2";
						leaf leaf1 { type int8; }
						leaf leaf2 { type string; }
						leaf leaf3 { type string; }
					}
				}
			EOB
		}
		context 'with valid value: 0, 1' do
			let!( :list1_element1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element1 ){ list1_element1.add_element( 'leaf1' ) }
			let!( :leaf1_text1 ){ leaf1_element1.add_text( '0' ) }
			let!( :leaf2_element1 ){ list1_element1.add_element( 'leaf2' ) }
			let!( :leaf2_text1 ){ leaf2_element1.add_text( 'a' ) }
			let!( :leaf3_element1 ){ list1_element1.add_element( 'leaf3' ) }
			let!( :leaf3_text1 ){ leaf3_element1.add_text( 'aa' ) }
			let!( :list1_element2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element2 ){ list1_element2.add_element( 'leaf1' ) }
			let!( :leaf1_text2 ){ leaf1_element2.add_text( '0' ) }
			let!( :leaf2_element2 ){ list1_element2.add_element( 'leaf2' ) }
			let!( :leaf2_text2 ){ leaf2_element2.add_text( 'b' ) }
			let!( :leaf3_element2 ){ list1_element2.add_element( 'leaf3' ) }
			let!( :leaf3_text2 ){ leaf3_element2.add_text( 'bb' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				config.edit( 'list1' ).edit( '0', 'a' ).edit( 'leaf3' ).set( 'aa' )
				config.edit( 'list1' ).edit( '0', 'b' ).edit( 'leaf3' ).set( 'bb' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal leaf-list 1' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf-list leaf-list1 {
						type string;
					}
				}
			EOB
		}
		context 'with 3 elements' do
			let!( :leaf_list1_element1 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf_list1_text1 ){ leaf_list1_element1.add_text( 'a' ) }
			let!( :leaf_list1_element2 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf_list1_text2 ){ leaf_list1_element2.add_text( 'b' ) }
			let!( :leaf_list1_element3 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf_list1_text3 ){ leaf_list1_element3.add_text( 'c' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf_list1 = config.edit( 'leaf-list1' )
				leaf_list1.set( 'a' )
				leaf_list1.set( 'b' )
				leaf_list1.set( 'c' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal choice 1' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					container container1 {
						choice choice1 {
							case case1 { leaf leaf1 { type string; } }
							case case2 { leaf leaf2 { type string; } }
						}
					}
				}
			EOB
		}
		context 'with valid value: 0, 1' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element ){ container1_element.add_element( 'leaf1' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf1' ).set( 'leaf1' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal choice 2' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					container container1 {
						leaf leaf0 { type string; }
						choice choice1 {
							case case1 { leaf leaf1 { type string; } }
							case case2 { leaf leaf2 { type string; } }
						}
					}
				}
			EOB
		}
		context 'with valid value: 0, 1' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf0_element ){ container1_element.add_element( 'leaf0' ) }
			let!( :leaf0_text ){ leaf0_element.add_text( 'leaf0' ) }
			let!( :leaf1_element ){ container1_element.add_element( 'leaf1' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf0' ).set( 'leaf0' )
				container1.edit( 'leaf1' ).set( 'leaf1' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal choice 3' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					container container1 {
						leaf leaf0 { type string; }
						choice choice1 {
							case case1 {
								choice choice2 {
									case case21 { leaf leaf21 { type string; } }
									case case22 { leaf leaf22 { type string; } }
								}
							}
							case case2 { leaf leaf2 { type string; } }
						}
					}
				}
			EOB
		}
		context 'with valid value: 0, 1' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf0_element ){ container1_element.add_element( 'leaf0' ) }
			let!( :leaf0_text ){ leaf0_element.add_text( 'leaf0' ) }
			let!( :leaf21_element ){ container1_element.add_element( 'leaf21' ) }
			let!( :leaf21_text ){ leaf21_element.add_text( 'leaf21' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf0' ).set( 'leaf0' )
				container1.edit( 'leaf21' ).set( 'leaf21' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'temporal choice 4' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					container container1 {
						leaf leaf0 { type string; }
						choice choice1 {
							case case1 {
								choice choice2 {
									case case21 { leaf leaf21 { type string; } }
									case case22 { leaf leaf22 { type string; } }
								}
							}
							case case2 { leaf leaf2 { type string; } }
							container container2 { leaf leaf3 { type string; } }
						}
					}
				}
			EOB
		}
		context 'with editing other case in same choice' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf0_element ){ container1_element.add_element( 'leaf0' ) }
			let!( :leaf0_text ){ leaf0_element.add_text( 'leaf0' ) }
			let!( :leaf22_element ){ container1_element.add_element( 'leaf22' ) }
			let!( :leaf22_text ){ leaf22_element.add_text( 'leaf22' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf0' ).set( 'leaf0' )
				container1.edit( 'leaf21' ).set( 'leaf21' )
				container1.edit( 'leaf22' ).set( 'leaf22' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'with editing other case in parent choice' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf0_element ){ container1_element.add_element( 'leaf0' ) }
			let!( :leaf0_text ){ leaf0_element.add_text( 'leaf0' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf0' ).set( 'leaf0' )
				container1.edit( 'leaf21' ).set( 'leaf21' )
				container1.edit( 'leaf2' ).set( 'leaf2' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'with editing other short-case in parent choice' do
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf0_element ){ container1_element.add_element( 'leaf0' ) }
			let!( :leaf0_text ){ leaf0_element.add_text( 'leaf0' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit( 'container1' )
				container1.edit( 'leaf0' ).set( 'leaf0' )
				container1.edit( 'leaf21' ).set( 'leaf21' )
				container1.edit( 'container2' ).edit( 'leaf3' ).set( 'leaf3' )
				container1.edit( 'leaf2' ).set( 'leaf2' )
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
	end

	describe 'leaf' do
		describe 'type int8' do
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type int8; }
						}
					EOB
				}
				context 'with valid value: 0' do
					let( :value ){ '0' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: +127' do
					let( :value ){ '+127' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: -128' do
					let( :value ){ '-128' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: 128' do
					let( :value ){ '128' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: -129' do
					let( :value ){ '-129' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'when edit same element' do
					let( :value ){ '-129' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set '20'
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with range "1"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type int8 { range "1"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: 2' do
					let( :value ){ '2' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: -0' do
					let( :value ){ '-0' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with range "1..10"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type int8 { range "1..10"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 2' do
					let( :value ){ '2' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 10' do
					let( :value ){ '10' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: 11' do
					let( :value ){ '11' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 0' do
					let( :value ){ '0' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with range "1..4 | 10..20"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type int8 { range "1..4 | 10..20"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 2' do
					let( :value ){ '2' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 4' do
					let( :value ){ '4' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 10' do
					let( :value ){ '10' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 11' do
					let( :value ){ '11' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 20' do
					let( :value ){ '20' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: 5' do
					let( :value ){ '5' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 9' do
					let( :value ){ '9' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 21' do
					let( :value ){ '21' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 0' do
					let( :value ){ '0' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type string' do
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type string; }
						}
					EOB
				}
				context 'with valid value: 0' do
					let( :value ){ '0' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: +127' do
					let( :value ){ '+127' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: -128' do
					let( :value ){ '-128' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
			end

			describe 'with length "1"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type string { length "1"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: ab' do
					let( :value ){ 'ab' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with length "1..10"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type string { length "1..10"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: abcdefghij' do
					let( :value ){ '2' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abcdefghijk' do
					let( :value ){ 'abcdefghijk' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with length "1..4 | 10..20"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type string { length "1..4 | 10..20"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: abcd' do
					let( :value ){ 'abcd' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: abcdefghijklmn' do
					let( :value ){ 'abcdefghijklmn' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: abcdefghijklmnopqrst' do
					let( :value ){ 'abcdefghijklmnopqrst' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abcde' do
					let( :value ){ 'abcde' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: abcdefghi' do
					let( :value ){ 'abcdefghi' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: abcdefghijklmnopqrstu' do
					let( :value ){ 'abcdefghijklmnopqrstu' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with pattern ".+"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type string { pattern ".+"; } }
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 12' do
					let( :value ){ '12' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: ' do
					let( :value ){ '' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with pattern ipv4' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type string {
									pattern
										'(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}'
										+ '([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])'
										+ '(%[\p{N}\p{L}]+)?';
								}
							}
						}
					EOB
				}
				context 'with valid value: 1.1.1.1' do
					let( :value ){ '1.1.1.1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 10.0.0.1' do
					let( :value ){ '10.0.0.1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with length "1..4 | 10..20" and pattern "[0-4]+"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type string {
									length "1..4 | 10..20";
									pattern "[0-4]+";
								}
							}
						}
					EOB
				}
				context 'with valid value: 1' do
					let( :value ){ '1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 12' do
					let( :value ){ '12' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: 1234012340' do
					let( :value ){ '1234012340' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: a' do
					let( :value ){ 'a' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 9' do
					let( :value ){ 'abcdefghi' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 01234' do
					let( :value ){ '01234' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: 0125' do
					let( :value ){ '0125' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type boolean' do
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type boolean; }
						}
					EOB
				}
				context 'with valid value: true' do
					let( :value ){ 'true' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: false' do
					let( :value ){ 'false' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type enumeration' do
=begin
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type enumeration; }
						}
					EOB
				}
				subject { ->{
					db.load_model Rubyang::Model::Parser.parse( yang_str )
				} }
				it { is_expected.to raise_exception Exception }
			end
=end

			describe 'with 1 enum' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type enumeration {
									enum 'enum1';
								}
							}
						}
					EOB
				}
				context 'with valid value: enum1' do
					let( :value ){ 'enum1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with multiple enum' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type enumeration {
									enum 'enum1';
									enum 'enum2';
									enum 'enum3';
								}
							}
						}
					EOB
				}
				context 'with valid value: enum1' do
					let( :value ){ 'enum1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: enum2' do
					let( :value ){ 'enum2' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type bits' do
=begin
			describe 'without bit' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type bits {
								}
							}
						}
					EOB
				}
				subject { ->{
					db.load_model Rubyang::Model::Parser.parse( yang_str )
				} }
				it { is_expected.to raise_exception Exception }
			end
=end

			describe 'with bit 0' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type bits {
									bit bit0 {
										position 0;
									}
								}
							}
						}
					EOB
				}
				context 'with valid value: bit0' do
					let( :value ){ 'bit0' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with multiple bit' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 {
								type bits {
									bit bit0 {
										position 0;
									}
									bit bit1 {
										position 1;
									}
									bit bit2 {
										position 2;
									}
								}
							}
						}
					EOB
				}
				context 'with valid value: bit0' do
					let( :value ){ 'bit0' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: bit0 bit1' do
					let( :value ){ 'bit0 bit1' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: bit0 bit1 bit2' do
					let( :value ){ 'bit0 bit1 bit2' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: abc' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: bit0 abc' do
					let( :value ){ 'bit0 abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type binary' do
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type binary; }
						}
					EOB
				}
				context 'with valid value: YWI=' do
					let( :value ){ 'YWI=' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: ab' do
					let( :value ){ 'ab' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with length "1"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type binary { length "1"; } }
						}
					EOB
				}
				context 'with valid value: YQ==' do
					let( :value ){ 'YQ==' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: YWI=' do
					let( :value ){ 'YWI=' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with length "1..10"' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type binary { length "1..10"; } }
						}
					EOB
				}
				context 'with valid value: YQ==' do
					let( :value ){ 'YQ==' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with valid value: YWJjZGVmZ2hpag==' do
					let( :value ){ 'YWJjZGVmZ2hpag==' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: YWJjZGVmZ2hpams=' do
					let( :value ){ 'YWJjZGVmZ2hpams=' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type leafref' do
			describe 'with invalid relative path of leaf' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf0 { type string; }
							leaf leaf1 { type leafref { path '../leaf2'; } }
						}
					EOB
				}
				subject { ->{
					db.load_model Rubyang::Model::Parser.parse( yang_str )
				} }
				it { is_expected.to raise_exception Exception }
			end

			describe 'with relative path of leaf' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf0 { type string; }
							leaf leaf1 { type leafref { path '../leaf0'; } }
						}
					EOB
				}
				context 'with valid value' do
					let( :value ){ 'value' }
					let!( :leaf0_element ){ root_xml.add_element( 'leaf0' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf0_text ){ leaf0_element.add_text( value ) }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf0 = config.edit 'leaf0'
						leaf0.set value
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value' do
					let( :value ){ 'abc' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf0 = config.edit 'leaf0'
						leaf0.set 'value'
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end

			describe 'with relative path of leaf with list' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							list list1 {
								key list1key;
								leaf list1key { type string; }
								leaf list1leaf { type string; }
							}
							leaf leaf1 { type leafref { path '../list1/list1leaf'; } }
						}
					EOB
				}
				context 'with valid value' do
					let( :value ){ 'value' }
					let!( :list1_element1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element1 ){ list1_element1.add_element( 'list1key' ) }
					let!( :list1key_text1 ){ list1key_element1.add_text( 'list1key1' ) }
					let!( :list1leaf_element1 ){ list1_element1.add_element( 'list1leaf' ) }
					let!( :list1leaf_text1 ){ list1leaf_element1.add_text( value ) }
					let!( :list1_element2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element2 ){ list1_element2.add_element( 'list1key' ) }
					let!( :list1key_text2 ){ list1key_element2.add_text( 'list1key2' ) }
					let!( :list1leaf_element2 ){ list1_element2.add_element( 'list1leaf' ) }
					let!( :list1leaf_text2 ){ list1leaf_element2.add_text( value ) }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						list1 = config.edit 'list1'
						list1_1 = list1.edit 'list1key1'
						list1_1_leaf = list1_1.edit 'list1leaf'
						list1_1_leaf.set value
						list1_2 = list1.edit 'list1key2'
						list1_2_leaf = list1_2.edit 'list1leaf'
						list1_2_leaf.set value
						leaf1 = config.edit 'leaf1'
						leaf1.set value
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
			end

			describe 'with relative path with predicate of leaf with list' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							list list1 {
								key list1key;
								leaf list1key { type string; }
								leaf list1leaf { type string; }
							}
							leaf leaf0 { type string; }
							leaf leaf1 { type leafref { path '../list1[list1key = current()/../leaf0]/list1leaf'; } }
						}
					EOB
				}
				context 'with valid value' do
					let( :value1 ){ 'value1' }
					let( :value2 ){ 'value2' }
					let!( :list1_element1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element1 ){ list1_element1.add_element( 'list1key' ) }
					let!( :list1key_text1 ){ list1key_element1.add_text( 'list1key1' ) }
					let!( :list1leaf_element1 ){ list1_element1.add_element( 'list1leaf' ) }
					let!( :list1leaf_text1 ){ list1leaf_element1.add_text( value1 ) }
					let!( :list1_element2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element2 ){ list1_element2.add_element( 'list1key' ) }
					let!( :list1key_text2 ){ list1key_element2.add_text( 'list1key2' ) }
					let!( :list1leaf_element2 ){ list1_element2.add_element( 'list1leaf' ) }
					let!( :list1leaf_text2 ){ list1leaf_element2.add_text( value2 ) }
					let!( :leaf0_element ){ root_xml.add_element( 'leaf0' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf0_text ){ leaf0_element.add_text( 'list1key1' ) }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value1 ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						list1 = config.edit 'list1'
						list1_1 = list1.edit 'list1key1'
						list1_1_leaf = list1_1.edit 'list1leaf'
						list1_1_leaf.set value1
						list1_2 = list1.edit 'list1key2'
						list1_2_leaf = list1_2.edit 'list1leaf'
						list1_2_leaf.set value2
						leaf0 = config.edit 'leaf0'
						leaf0.set 'list1key1'
						leaf1 = config.edit 'leaf1'
						leaf1.set value1
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value' do
					let( :value1 ){ 'value1' }
					let( :value2 ){ 'value2' }
					let!( :list1_element1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element1 ){ list1_element1.add_element( 'list1key' ) }
					let!( :list1key_text1 ){ list1key_element1.add_text( 'list1key1' ) }
					let!( :list1leaf_element1 ){ list1_element1.add_element( 'list1leaf' ) }
					let!( :list1leaf_text1 ){ list1leaf_element1.add_text( value1 ) }
					let!( :list1_element2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :list1key_element2 ){ list1_element2.add_element( 'list1key' ) }
					let!( :list1key_text2 ){ list1key_element2.add_text( 'list1key2' ) }
					let!( :list1leaf_element2 ){ list1_element2.add_element( 'list1leaf' ) }
					let!( :list1leaf_text2 ){ list1leaf_element2.add_text( value2 ) }
					let!( :leaf0_element ){ root_xml.add_element( 'leaf0' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf0_text ){ leaf0_element.add_text( 'list1key1' ) }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					let!( :leaf1_text ){ leaf1_element.add_text( value1 ) }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						list1 = config.edit 'list1'
						list1_1 = list1.edit 'list1key1'
						list1_1_leaf = list1_1.edit 'list1leaf'
						list1_1_leaf.set value1
						list1_2 = list1.edit 'list1key2'
						list1_2_leaf = list1_2.edit 'list1leaf'
						list1_2_leaf.set value2
						leaf0 = config.edit 'leaf0'
						leaf0.set 'list1key1'
						leaf1 = config.edit 'leaf1'
						leaf1.set value2
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type empty' do
			describe 'without restrictions' do
				let( :yang_str ){
					<<-EOB
						module module1 {
							namespace "http://module1.rspec/";
							prefix module1;
							leaf leaf1 { type empty; }
						}
					EOB
				}
				context 'with valid value: ' do
					let( :value ){ '0' }
					let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
					subject {
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						config.to_xml( pretty: true )
					}
					it { is_expected.to eq doc_xml_pretty }
				end
				context 'with invalid value: a' do
					let( :value ){ 'a' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
				context 'with invalid value: ""' do
					let( :value ){ '' }
					subject { ->{
						db.load_model Rubyang::Model::Parser.parse( yang_str )
						config = db.configure
						leaf1 = config.edit 'leaf1'
						leaf1.set value
					} }
					it { is_expected.to raise_exception Exception }
				end
			end
		end

		describe 'type union' do
			describe 'string and int32' do
				describe 'without restrictions' do
					let( :yang_str ){
						<<-EOB
							module module1 {
								namespace "http://module1.rspec/";
								prefix module1;
								leaf leaf1 {
									type union {
										type string;
										type int32;
									}
								}
							}
						EOB
					}
					context 'with valid value: 0' do
						let( :value ){ '0' }
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( value ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set value
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
					context 'with valid value: a' do
						let( :value ){ 'a' }
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( value ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set value
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'with restrictions' do
					describe 'with length "1" and range "-10..10"' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									leaf leaf1 {
										type union {
											type string {
												length 1;
											}
											type int32 {
												range -10..10;
											}
										}
									}
								}
							EOB
						}
						context 'with valid value: 1' do
							let( :value ){ '1' }
							let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
							let!( :leaf1_text ){ leaf1_element.add_text( value ) }
							subject {
								db.load_model Rubyang::Model::Parser.parse( yang_str )
								config = db.configure
								leaf1 = config.edit 'leaf1'
								leaf1.set value
								config.to_xml( pretty: true )
							}
							it { is_expected.to eq doc_xml_pretty }
						end
						context 'with valid value: a' do
							let( :value ){ 'a' }
							let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
							let!( :leaf1_text ){ leaf1_element.add_text( value ) }
							subject {
								db.load_model Rubyang::Model::Parser.parse( yang_str )
								config = db.configure
								leaf1 = config.edit 'leaf1'
								leaf1.set value
								config.to_xml( pretty: true )
							}
							it { is_expected.to eq doc_xml_pretty }
						end
						context 'with valid value: 10' do
							let( :value ){ '10' }
							let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
							let!( :leaf1_text ){ leaf1_element.add_text( value ) }
							subject {
								db.load_model Rubyang::Model::Parser.parse( yang_str )
								config = db.configure
								leaf1 = config.edit 'leaf1'
								leaf1.set value
								config.to_xml( pretty: true )
							}
							it { is_expected.to eq doc_xml_pretty }
						end
						context 'with invalid value: ab' do
							let( :value ){ 'ab' }
							subject { ->{
								db.load_model Rubyang::Model::Parser.parse( yang_str )
								config = db.configure
								leaf1 = config.edit 'leaf1'
								leaf1.set value
							} }
							it { is_expected.to raise_exception Exception }
						end
					end
				end
			end
		end
	end

	describe 'test2' do
		let( :yang_str1 ){
			<<-EOB
				module testmodule00 {
					yang-version "1";
					namespace "http://test/module00";
					prefix testprefix00;
					typedef hoge00 { type int32; }
				}
			EOB
		}
		let( :yang_str2 ){
			<<-EOB
				module testmodule01 {
					yang-version "1";
					namespace "http://test/module01";
					prefix testprefix01;
					import testmodule00 { prefix testmodule00; }
					typedef hoge01 { type testmodule00:hoge00; }
				}
			EOB
		}
		let( :yang_str3 ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					yang-version "1";
					import testmodule01 { prefix testmodule01; }
					container c1 {
						typedef c1type { type uint8; }
						leaf fuga { type testmodule01:hoge01; }
						leaf c1leaf { type c1type; }
					}
				}
			EOB
		}
		let!( :c1_element ){ root_xml.add_element( 'c1' ).add_namespace( 'http://module1.rspec/' ) }
		let!( :fuga_element ){ c1_element.add_element( 'fuga' ) }
		let!( :fuga_text ){ fuga_element.add_text( '8' ) }
		let!( :c1leaf_element ){ c1_element.add_element( 'c1leaf' ) }
		let!( :c1leaf_text ){ c1leaf_element.add_text( '5' ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str1 )
			db.load_model Rubyang::Model::Parser.parse( yang_str2 )
			db.load_model Rubyang::Model::Parser.parse( yang_str3 )
			config = db.configure
			c1 = config.edit 'c1'
			fuga = c1.edit 'fuga'
			fuga.set '8'
			c1leaf = c1.edit 'c1leaf'
			c1leaf.set '5'
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe 'test3' do
		let( :yang_str1 ){
			<<-EOB
				submodule inc1 {
					belongs-to 'test05' { prefix 'inc1'; }
					include inc2;
					typedef inc1type2 { type string; }
					typedef inc1type { type inc1:inc1type2; }
				}
			EOB
		}
		let( :yang_str2 ){
			<<-EOB
				submodule inc2 {
					belongs-to 'test05' { prefix 'inc2'; }
					typedef inc2type { type int8; }
				}
			EOB
		}
		let( :yang_str3 ){
			<<-EOB
				module test05 {
					namespace "http://com/example/test05";
					prefix test05;
					include inc1;
					include inc2;
					leaf inc1data { type inc1type; }
				}
			EOB
		}
		let!( :inc1data_element ){ root_xml.add_element( 'inc1data' ).add_namespace( 'http://com/example/test05' ) }
		let!( :inc1data_text ){ inc1data_element.add_text( '10' ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str1 )
			db.load_model Rubyang::Model::Parser.parse( yang_str2 )
			db.load_model Rubyang::Model::Parser.parse( yang_str3 )
			config = db.configure
			inc1data = config.edit 'inc1data'
			inc1data.set '10'
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe 'test4' do
		let( :yang_str1 ){
			<<-EOB
				module testmodule20 {
					namespace 'http://testmodule20.com';
					prefix 'testmodule20';
					include testsubmodule20;
					typedef testmodule20type { type testsubmodule20type; }
				}
			EOB
		}
		let( :yang_str2 ){
			<<-EOB
				submodule testsubmodule20 {
					belongs-to 'testmodule20' { prefix 'testsubmodule20'; }
					typedef testsubmodule20type { type int8; }
				}
			EOB
		}
		let( :yang_str3 ){
			<<-EOB
				module testmodule2 {
					namespace "http://com/example/testmodule2";
					prefix testmodule2;
        				import testmodule20 { prefix testmodule20; }
					leaf testsubmodule20data { type testmodule20:testmodule20type; }
				}
			EOB
		}
		let!( :testsubmodule20data_element ){ root_xml.add_element( 'testsubmodule20data' ).add_namespace( 'http://com/example/testmodule2' ) }
		let!( :testsubmodule20data_text ){ testsubmodule20data_element.add_text( '10' ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str1 )
			db.load_model Rubyang::Model::Parser.parse( yang_str2 )
			db.load_model Rubyang::Model::Parser.parse( yang_str3 )
			config = db.configure
			testsubmodule20data = config.edit 'testsubmodule20data'
			testsubmodule20data.set '10'
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe 'test5' do
		let( :yang_str1 ){
			<<-EOB
				module testmodule1 {
					yang-version "1";
					namespace "http://test/module1";
					prefix testprefix1;
					grouping hoge {
						leaf fuga {
							type string;
						}
					}
				}
			EOB
		}
		let( :yang_str2 ){
			<<-EOB
				module testmodule2 {
					yang-version "1";
					namespace "http://test/module2";
					prefix testprefix2;
					grouping foo {
						leaf bar {
							type string;
						}
					}
				}
			EOB
		}
		let( :yang_str3 ){
			<<-EOB
				module testmodule3 {
					yang-version "1";
					namespace "http://test/module3";
					prefix testprefix3;
					import testmodule1 {
						prefix "testmod1";
					}
					import testmodule2 {
						prefix "testmod2";
					}
					container testcontainer3 {
						leaf testleaf3 {
							type string;
						}
					}
					grouping piyo {
						leaf baz {
							type string;
						}
					}
					uses testmod1:hoge;
					uses testmod2:foo;
					uses piyo;
				}
			EOB
		}
		let( :yang_str4 ){
			<<-EOB
				module testmodule4 {
					yang-version "1";
					namespace "http://test/module4";
					prefix testprefix4;
					augment /testcontainer3 {
						container testcontainer4 {
							leaf testleaf4 {
								type string {
									length 1..10;
								}
							}
						}
					}
				}
			EOB
		}
		let( :yang_str5 ){
			<<-EOB
				module testmodule5 {
					yang-version "1";
					namespace "http://test/module5";
					prefix testprefix5;
					typedef test5typedef {
						type string {
							length 1..10;
						}
					}
					leaf testleaf5 {
						type test5typedef;
					}
				}
			EOB
		}
		let( :yang_str6 ){
			<<-EOB
				module testmodule6 {
					yang-version "1";
					namespace "http://test/module6";
					prefix testprefix6;
					import testmodule5 {
					  prefix testprefix5;
					}
					leaf testleaf6 {
						type testprefix5:test5typedef;
					}
				}
			EOB
		}
		let( :yang_str7 ){
			<<-EOB
				submodule testsubmodule7 {
					belongs-to testmodule8 {
						prefix testprefix8;
					}
					typedef test7typedef {
						type string {
							length 1..10;
						}
					}
				}
			EOB
		}
		let( :yang_str8 ){
			<<-EOB
				module testmodule8 {
					yang-version "1";
					namespace "http://test/module8";
					prefix testprefix8;
					include testsubmodule7;
					augment /testcontainer3 {
						leaf testleaf8 {
							type test7typedef;
						}
					}
				}
			EOB
		}
		let!( :testcontainer3_element ){ root_xml.add_element( 'testcontainer3' ).add_namespace( 'http://test/module3' ) }
		let!( :testleaf3_element ){ testcontainer3_element.add_element( 'testleaf3' ) }
		let!( :testleaf3_text ){ testleaf3_element.add_text( 'string' ) }
		let!( :testcontainer4_element ){ testcontainer3_element.add_element( 'testcontainer4' ).add_namespace( 'http://test/module4' ) }
		let!( :testleaf4_element ){ testcontainer4_element.add_element( 'testleaf4' ) }
		let!( :testleaf4_text ){ testleaf4_element.add_text( '9' ) }
		let!( :fuga_element ){ root_xml.add_element( 'fuga' ).add_namespace( 'http://test/module3' ) }
		let!( :fuga_text ){ fuga_element.add_text( 'string' ) }
		let!( :bar_element ){ root_xml.add_element( 'bar' ).add_namespace( 'http://test/module3' ) }
		let!( :bar_text ){ bar_element.add_text( 'string' ) }
		let!( :baz_element ){ root_xml.add_element( 'baz' ).add_namespace( 'http://test/module3' ) }
		let!( :baz_text ){ baz_element.add_text( 'string' ) }
		let!( :testleaf5_element ){ root_xml.add_element( 'testleaf5' ).add_namespace( 'http://test/module5' ) }
		let!( :testleaf5_text ){ testleaf5_element.add_text( '5' ) }
		let!( :testleaf6_element ){ root_xml.add_element( 'testleaf6' ).add_namespace( 'http://test/module6' ) }
		let!( :testleaf6_text ){ testleaf6_element.add_text( '6' ) }
		subject {
			db.load_model Rubyang::Model::Parser.parse( yang_str1 )
			db.load_model Rubyang::Model::Parser.parse( yang_str2 )
			db.load_model Rubyang::Model::Parser.parse( yang_str3 )
			db.load_model Rubyang::Model::Parser.parse( yang_str4 )
			db.load_model Rubyang::Model::Parser.parse( yang_str5 )
			db.load_model Rubyang::Model::Parser.parse( yang_str6 )
			db.load_model Rubyang::Model::Parser.parse( yang_str7 )
			db.load_model Rubyang::Model::Parser.parse( yang_str8 )
			config = db.configure
			testcontainer3 = config.edit 'testcontainer3'
			testleaf3 = testcontainer3.edit 'testleaf3'
			testleaf3.set 'string'
			testcontainer4 = testcontainer3.edit 'testcontainer4'
			testleaf4 = testcontainer4.edit 'testleaf4'
			testleaf4.set '9'
			fuga = config.edit 'fuga'
			fuga.set 'string'
			bar = config.edit 'bar'
			bar.set 'string'
			baz = config.edit 'baz'
			baz.set 'string'
			testleaf5 = config.edit 'testleaf5'
			testleaf5.set '5'
			testleaf6 = config.edit 'testleaf6'
			testleaf6.set '6'
			config.to_xml( pretty: true )
		}
		it { is_expected.to eq doc_xml_pretty }
	end

	describe 'when' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					leaf leaf1 {
						type string;
					}
					container container1 {
						when "../leaf1 = 'true'";
						leaf leaf2 {
							type string;
						}
					}
				}
			EOB
		}
		context 'with valid value: true' do
			let( :value ){ 'true' }
			let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit 'leaf1'
				leaf1.set value
				container1 = config.edit 'container1'
				leaf2 = container1.edit 'leaf2'
				leaf2.set value
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'with invalid value: false' do
			let( :value ){ 'false' }
			subject { ->{
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit 'leaf1'
				leaf1.set value
				container1 = config.edit 'container1'
			} }
			it { is_expected.to raise_exception Exception }
		end
		context 'with invalid value: false' do
			let( :value ){ 'false' }
			subject { ->{
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				leaf1 = config.edit 'leaf1'
				leaf1.set value
				container1 = config.edit 'container1'
			} }
			it { is_expected.to raise_exception Exception }
		end
	end

	describe 'must' do
		let( :yang_str ){
			<<-EOB
				module module1 {
					namespace "http://module1.rspec/";
					prefix module1;
					container container1 {
						must "leaf1 = leaf2";
						leaf leaf1 {
							type string;
						}
						leaf leaf2 {
							type string;
						}
					}
				}
			EOB
		}
		context 'with valid value' do
			let( :value ){ 'value' }
			let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
			let!( :leaf1_element ){ container1_element.add_element( 'leaf1' ) }
			let!( :leaf1_text ){ leaf1_element.add_text( value ) }
			let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
			let!( :leaf2_text ){ leaf2_element.add_text( value ) }
			subject {
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit 'container1'
				leaf1 = container1.edit 'leaf1'
				leaf1.set value
				leaf2 = container1.edit 'leaf2'
				leaf2.set value
				raise unless config.valid?
				config.to_xml( pretty: true )
			}
			it { is_expected.to eq doc_xml_pretty }
		end
		context 'with invalid value' do
			let( :value1 ){ 'value1' }
			let( :value2 ){ 'value2' }
			subject { ->{
				db.load_model Rubyang::Model::Parser.parse( yang_str )
				config = db.configure
				container1 = config.edit 'container1'
				leaf1 = container1.edit 'leaf1'
				leaf1.set value1
				leaf2 = container1.edit 'leaf2'
				leaf2.set value2
				raise unless config.valid?
				config.to_xml( pretty: true )
			} }
			it { is_expected.to raise_exception Exception }
		end
	end
end

