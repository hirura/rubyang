# coding: utf-8

require 'spec_helper'

require 'rexml/document'
require 'rexml/formatters/pretty'
require 'json'

describe 'RFC6020' do
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
	let( :db ){
		Rubyang::Database.new
	}

	describe '7. YANG Statements' do
		describe '7.1. The module Statement' do
			describe '7.1.1. The module\'s Substatements' do
				# TODO
				describe 'anyxml' do
					context '0 anyxml' do
					end

					context '1 anyxml' do
					end

					context '2 anyxmls' do
					end
				end

				describe 'augment' do
					context '0 augment' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 augment' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
									augment /container1 {
										leaf leaf1 { type string; }
									}
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_element ){ container1_element.add_element( 'leaf1' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							leaf1 = container1.edit 'leaf1'
							leaf1.set 'leaf1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 augments' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
									augment /container1 {
										leaf leaf1 { type string; }
									}
									augment /container1 {
										leaf leaf2 { type string; }
									}
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_element ){ container1_element.add_element( 'leaf1' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :leaf2_element ){ container1_element.add_element( 'leaf2' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							leaf1 = container1.edit 'leaf1'
							leaf1.set 'leaf1'
							leaf2 = container1.edit 'leaf2'
							leaf2.set 'leaf2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'choice' do
					context '0 choice' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 choice' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									choice choice1 {
										case case1 {
											leaf leaf1 { type string; }
										}
									}
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit( 'leaf1' ).set( 'leaf1' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 choices' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									choice choice1 {
										case case1 {
											leaf leaf1 { type string; }
										}
									}
									choice choice2 {
										case case2 {
											leaf leaf2 { type string; }
										}
									}
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :leaf2_element ){ root_xml.add_element( 'leaf2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit( 'leaf1' ).set( 'leaf1' )
							leaf2 = config.edit( 'leaf2' ).set( 'leaf2' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'contact' do
					context '0 contact' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 contact' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									contact contact1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 contacts' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									contact contact1;
									contact contact2;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end

				describe 'container' do
					context '0 container' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 container' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 containers' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
									container container2;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :container2_element ){ root_xml.add_element( 'container2' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							container2 = config.edit 'container2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'description' do
					context '0 description' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 description' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									description description1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 descriptions' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									description description1;
									description description2;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end

				# TODO
				describe 'deviation' do
					context '0 deviation' do
					end

					context '1 deviation' do
					end

					context '2 deviations' do
					end
				end

				# TODO
				describe 'extension' do
					context '0 extension' do
					end

					context '1 extension' do
					end

					context '2 extensions' do
					end
				end

				# TODO
				describe 'feature' do
					context '0 feature' do
					end

					context '1 feature' do
					end

					context '2 features' do
					end
				end

				describe 'grouping' do
					context '0 grouping' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 grouping' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									grouping grouping1 {
										leaf leaf1 { type string; }
									}
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 groupings' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									grouping grouping1 {
										leaf leaf1 { type string; }
									}
									grouping grouping2 {
										leaf leaf2 { type string; }
									}
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				# TODO
				describe 'identity' do
					context '0 identity' do
					end

					context '1 identity' do
					end

					context '2 identitys' do
					end
				end

				describe 'import' do
					context '0 import' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 import' do
						let( :yang_str1 ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let( :yang_str2 ){
							<<-EOB
								module module2 {
									namespace "http://module2.rspec/";
									prefix module2;
									import module1 {
										prefix module1;
									}
									container container2;
								}
							EOB
						}
						let!( :container2_element ){ root_xml.add_element( 'container2' ).add_namespace( 'http://module2.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str1 )
							db.load_model Rubyang::Model::Parser.parse( yang_str2 )
							config = db.configure
							container2 = config.edit 'container2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 imports' do
						let( :yang_str1 ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let( :yang_str2 ){
							<<-EOB
								module module2 {
									namespace "http://module2.rspec/";
									prefix module2;
								}
							EOB
						}
						let( :yang_str3 ){
							<<-EOB
								module module3 {
									namespace "http://module3.rspec/";
									prefix module3;
									import module1 {
										prefix module1;
									}
									import module2 {
										prefix module2;
									}
									container container3;
								}
							EOB
						}
						let!( :container3_element ){ root_xml.add_element( 'container3' ).add_namespace( 'http://module3.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str1 )
							db.load_model Rubyang::Model::Parser.parse( yang_str2 )
							db.load_model Rubyang::Model::Parser.parse( yang_str3 )
							config = db.configure
							container3 = config.edit 'container3'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'include' do
					context '0 include' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 include' do
						let( :yang_str1 ){
							<<-EOB
								submodule submodule1 {
									belongs-to module1 { prefix submodule1; }
								}
							EOB
						}
						let( :yang_str2 ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									include submodule1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str1 )
							db.load_model Rubyang::Model::Parser.parse( yang_str2 )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 includes' do
						let( :yang_str1 ){
							<<-EOB
								submodule submodule1 {
									belongs-to module1 { prefix submodule1; }
								}
							EOB
						}
						let( :yang_str2 ){
							<<-EOB
								submodule submodule2 {
									belongs-to module1 { prefix submodule2; }
								}
							EOB
						}
						let( :yang_str3 ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									include submodule1;
									container container1;
								}
							EOB
						}
						let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str1 )
							db.load_model Rubyang::Model::Parser.parse( yang_str2 )
							db.load_model Rubyang::Model::Parser.parse( yang_str3 )
							config = db.configure
							container1 = config.edit 'container1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'leaf' do
					context '0 leaf' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 leaf' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									leaf leaf1 { type string; }
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit( 'leaf1' )
							leaf1.set( 'leaf1' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 leafs' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									leaf leaf1 { type string; }
									leaf leaf2 { type string; }
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :leaf2_element ){ root_xml.add_element( 'leaf2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit( 'leaf1' )
							leaf1.set( 'leaf1' )
							leaf2 = config.edit( 'leaf2' )
							leaf2.set( 'leaf2' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'leaf-list' do
					context '0 leaf-list' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 leaf-list' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									leaf-list leaf-list1 { type string; }
								}
							EOB
						}
						let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf_list1 = config.edit( 'leaf-list1' )
							leaf_list1.set( 'leaf-list1' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 leaf-lists' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									leaf-list leaf-list1 { type string; }
									leaf-list leaf-list2 { type string; }
								}
							EOB
						}
						let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
						let!( :leaf_list2_element ){ root_xml.add_element( 'leaf-list2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf_list2_text ){ leaf_list2_element.add_text( 'leaf-list2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf_list1 = config.edit( 'leaf-list1' )
							leaf_list1.set( 'leaf-list1' )
							leaf_list2 = config.edit( 'leaf-list2' )
							leaf_list2.set( 'leaf-list2' )
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'list' do
					context '0 list' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 list' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									list list1 {
										key leaf1;
										leaf leaf1 { type string; }
									}
								}
							EOB
						}
						let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							list1 = config.edit( 'list1' )
							list1_element1 = list1.edit 'leaf1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 lists' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									list list1 {
										key leaf1;
										leaf leaf1 { type string; }
									}
									list list2 {
										key leaf2;
										leaf leaf2 { type string; }
									}
								}
							EOB
						}
						let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :list2_element ){ root_xml.add_element( 'list2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf2_element ){ list2_element.add_element( 'leaf2' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							list1 = config.edit( 'list1' )
							list1_element1 = list1.edit 'leaf1'
							list2 = config.edit( 'list2' )
							list2_element2 = list2.edit 'leaf2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'namespace' do
					context '0 namespace' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end

					context '1 namespace' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 namespaces' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end

				# TODO
				describe 'notification' do
					context '0 notification' do
					end

					context '1 notification' do
					end

					context '2 notifications' do
					end
				end

				describe 'organization' do
					context '0 organization' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 organization' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									organization organization1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 organizations' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									organization organization1;
									organization organization2;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end

				describe 'prefix' do
					context '0 prefix' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end

					context '1 prefix' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 prefixs' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end

				# TODO
				describe 'reference' do
					context '0 reference' do
					end

					context '1 reference' do
					end

					context '2 references' do
					end
				end

				describe 'revision' do
					context '0 revision' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 revision' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									revision 2016-07-10;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 revisions' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									revision 2016-07-10;
									revision 2016-07-09;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				# TODO
				describe 'rpc' do
					context '0 rpc' do
					end

					context '1 rpc' do
					end

					context '2 rpcs' do
					end
				end

				describe 'typedef' do
					context '0 typedef' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 typedef' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									typedef typedef1 {
										type string;
									}
									leaf leaf1 { type typedef1; }
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set 'leaf1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 typedefs' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									typedef typedef1 {
										type string;
									}
									typedef typedef2 {
										type string;
									}
									leaf leaf1 { type typedef1; }
									leaf leaf2 { type typedef2; }
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :leaf2_element ){ root_xml.add_element( 'leaf2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set 'leaf1'
							leaf2 = config.edit 'leaf2'
							leaf2.set 'leaf2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'uses' do
					context '0 uses' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 uses' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									grouping grouping1 {
										leaf leaf1 { type string; }
									}
									uses grouping1;
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set 'leaf1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 usess' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									grouping grouping1 {
										leaf leaf1 { type string; }
									}
									grouping grouping2 {
										leaf leaf2 { type string; }
									}
									uses grouping1;
									uses grouping2;
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						let!( :leaf2_element ){ root_xml.add_element( 'leaf2' ).add_namespace( 'http://module1.rspec/' ) }
						let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set 'leaf1'
							leaf2 = config.edit 'leaf2'
							leaf2.set 'leaf2'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end

				describe 'yang-version' do
					context '0 yang-version' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '1 yang-version' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									yang-version 1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context '2 yang-versions' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									yang-version 1;
									yang-version 1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end
			end # describe '7.1.1. The module\'s Substatements'

			# TODO
			describe '7.1.2. The yang-version Statement' do
				describe 'MUST contain the value"1"' do
					context 'valid valud: "1"' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									yang-version 1;
								}
							EOB
						}
						let!( :dummy ){ root_xml }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str )
							config = db.configure
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end

					context 'invalid valud: "2"' do
						let( :yang_str ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec/";
									prefix module1;
									yang-version 2;
								}
							EOB
						}
						subject { ->{
							db.load_model Rubyang::Model::Parser.parse( yang_str )
						} }
						it { is_expected.to raise_exception Exception }
					end
				end # describe 'MUST contain the value"1"'
			end # describe '7.1.2. The yang-version Statement'

			# TODO
			describe '7.1.3. The namespace Statement' do
			end # describe '7.1.3. The namespace Statement'

			# TODO
			describe '7.1.4. The prefix Statement' do
			end # describe '7.1.4. The prefix Statement'

			# TODO
			describe '7.1.5. The import Statement' do
				# TODO
				describe 'the importing module may use any grouping and typedef defined at the top level in the imported module or its submodules' do
					context 'typedef' do
						let( :yang_str1 ){
							<<-EOB
								module module1 {
									namespace "http://module1.rspec";
									prefix module1;
									typedef typedef1 { type string; }
								}
							EOB
						}
						let( :yang_str2 ){
							<<-EOB
								module module2 {
									namespace "http://module2.rspec";
									prefix module2;
									import module1 { prefix module1; }
									typedef typedef2 { type module1:typedef1; }
								}
							EOB
						}
						let( :yang_str3 ){
							<<-EOB
								module module3 {
									namespace "http://module3.rspec/";
									prefix module3;
									import module2 { prefix module2; }
									leaf leaf1 { type module2:typedef2; }
								}
							EOB
						}
						let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module3.rspec/' ) }
						let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
						subject {
							db.load_model Rubyang::Model::Parser.parse( yang_str1 )
							db.load_model Rubyang::Model::Parser.parse( yang_str2 )
							db.load_model Rubyang::Model::Parser.parse( yang_str3 )
							config = db.configure
							leaf1 = config.edit 'leaf1'
							leaf1.set 'leaf1'
							config.to_xml( pretty: true )
						}
						it { is_expected.to eq doc_xml_pretty }
					end
				end # describe 'the importing module may use any grouping and typedef defined at the top level in the imported module or its submodules'

				# TODO
				describe 'the importing module may use any extension, feature, and identity defined in the imported module or its submodules' do
				end # describe 'the importing module may use any extension, feature, and identity defined in the imported module or its submodules' do

				# TODO
				describe 'the importing module may use any node in the imported module\'s schema tree in "must", "path", and "when" statements, or as the target node in "augment" and "deviation" statements' do
				end # describe 'the importing module may use any node in the imported module\'s schema tree in "must", "path", and "when" statements, or as the target node in "augment" and "deviation" statements'

				# TODO
				describe 'Multiple "import" statements may be specified to import from different modules' do
				end # describe 'Multiple "import" statements may be specified to import from different modules'

				# TODO
				describe 'When the optional "revision-date" substatement is present' do
					describe 'any typedef, grouping, extension, feature, and identity referenced by definitions in the local module are taken from the specified revision of the imported module' do
					end # describe 'any typedef, grouping, extension, feature, and identity referenced by definitions in the local module are taken from the specified revision of the imported module'

					describe 'It is an error if the specified revision of the imported module does not exist' do
					end # describe 'It is an error if the specified revision of the imported module does not exist'
				end # describe 'When the optional "revision-date" substatement is present'

				# TODO
				describe 'The import\'s Substatements' do
					# TODO
					describe 'prefix' do
					end # describe 'prefix'

					# TODO
					describe 'revision-date' do
					end # describe 'revision-date'
				end # describe 'The import\'s Substatements'

				# TODO
				describe '7.1.5.1 The import\'s revision-date Statement' do
					# TODO
					context 'The "revision-date" statement MUST match the most recent "revision" statement in the imported module' do
					end # context 'The "revision-date" statement MUST match the most recent "revision" statement in the imported module'
				end # describe '7.1.5.1 The import\'s revision-date Statement'
			end # describe '7.1.5. The import Statement'

			# TODO
			describe '7.1.6. The include Statement' do

				# TODO
				describe 'The argument is an identifier that is the name of the submodule to include' do
				end # describe 'The argument is an identifier that is the name of the submodule to include'

				# TODO
				describe 'Modules are only allowed to include submodules that belong to that module, as defined by the "belongs-to" statement' do
				end # describe 'Modules are only allowed to include submodules that belong to that module, as defined by the "belongs-to" statement'

				# TODO
				describe 'Submodules are only allowed to include other submodules belonging to the same module' do
				end # describe 'Submodules are only allowed to include other submodules belonging to the same module'

				# TODO
				describe 'When a module includes a submodule, it incorporates the contents of the submodule into the node hierarchy of the module' do
				end # describe 'When a module includes a submodule, it incorporates the contents of the submodule into the node hierarchy of the module'

				# TODO
				describe 'When a submodule includes another submodule, the target submodule\'s definitions are made available to the current submodule' do
				end # describe 'When a submodule includes another submodule, the target submodule\'s definitions are made available to the current submodule'

				# TODO
				describe 'When the optional "revision-date" substatement is present, the specified revision of the submodule is included in the module' do
				end # describe 'When the optional "revision-date" substatement is present, the specified revision of the submodule is included in the module'

				# TODO
				describe 'It is an error if the specified revision of the submodule does not exist' do
				end # describe 'It is an error if the specified revision of the submodule does not exist'

				# TODO
				describe 'If no "revision-date" substatement is present, it is undefined which revision of the submodule is included' do
				end # describe 'If no "revision-date" substatement is present, it is undefined which

				# TODO
				describe 'Multiple revisions of the same submodule MUST NOT be included' do
				end # describe 'Multiple revisions of the same submodule MUST NOT be included'

				# TODO
				describe 'The includes\'s Substatements' do
					describe 'revision-date' do
					end # describe 'revision-date'
				end # describe 'The includes\'s Substatements'
			end # describe '7.1.6. The include Statement'

			# TODO
			describe '7.1.7. The organization Statement' do
			end # describe '7.1.7. The organization Statement'

			# TODO
			describe '7.1.8. The contact Statement' do
			end # describe '7.1.7. The contact Statement'

			# TODO
			describe '7.1.9. The revision Statement' do
			end # describe '7.1.7. The revision Statement'

			# TODO
			describe '7.1.10. Usage Example' do
				<<-EOB
					module acme-system {
						namespace "http://acme.example.com/system";
						prefix "acme";
						import ietf-yang-types {
							prefix "yang";
						}
						include acme-types;
						organization "ACME Inc.";
						contact
							"Joe L. User
							 ACME, Inc.
							 42 Anywhere Drive
							 Nowhere, CA 95134
							 USA
							 Phone: +1 800 555 0100
							 EMail: joe@acme.example.com";
						description
							"The module for entities implementing the ACME protocol.";
						revision "2007-06-09" {
							description "Initial revision.";
						}
						// definitions follow...
					}
				EOB
			end # describe '7.1.10. Usage Example'

		end # describe '7.1. The module Statement'

		# TODO
		describe '7.2. The submodule Statement' do
		end # describe '7.2. The submodule Statement'

	end # describe '7. YANG Statements'
end # describe 'RFC6020'
