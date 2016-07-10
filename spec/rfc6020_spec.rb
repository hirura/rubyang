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
			describe '7.2.1. The submodule\'s Substatements' do

				# TODO
				describe 'anyxml' do
					context '0 anyxml' do
					end

					context '1 anyxml' do
					end

					context '2 anyxmls' do
					end
				end

				# TODO
				describe 'augment' do
					context '0 augment' do
					end

					context '1 augment' do
					end

					context '2 augments' do
					end
				end

				# TODO
				describe 'belongs-to' do
					context '0 belongs-to' do
					end

					context '1 belongs-to' do
					end

					context '2 belongs-tos' do
					end
				end

				# TODO
				describe 'choice' do
					context '0 choice' do
					end

					context '1 choice' do
					end

					context '2 choices' do
					end
				end

				# TODO
				describe 'contact' do
					context '0 contact' do
					end

					context '1 contact' do
					end

					context '2 contacts' do
					end
				end

				# TODO
				describe 'container' do
					context '0 container' do
					end

					context '1 container' do
					end

					context '2 containers' do
					end
				end

				# TODO
				describe 'description' do
					context '0 description' do
					end

					context '1 description' do
					end

					context '2 descriptions' do
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

				# TODO
				describe 'grouping' do
					context '0 grouping' do
					end

					context '1 grouping' do
					end

					context '2 groupings' do
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

				# TODO
				describe 'import' do
					context '0 import' do
					end

					context '1 import' do
					end

					context '2 imports' do
					end
				end

				# TODO
				describe 'include' do
					context '0 include' do
					end

					context '1 include' do
					end

					context '2 includes' do
					end
				end

				# TODO
				describe 'leaf' do
					context '0 leaf' do
					end

					context '1 leaf' do
					end

					context '2 leafs' do
					end
				end

				# TODO
				describe 'leaf-list' do
					context '0 leaf-list' do
					end

					context '1 leaf-list' do
					end

					context '2 leaf-lists' do
					end
				end

				# TODO
				describe 'list' do
					context '0 list' do
					end

					context '1 list' do
					end

					context '2 lists' do
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

				# TODO
				describe 'organization' do
					context '0 organization' do
					end

					context '1 organization' do
					end

					context '2 organizations' do
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

				# TODO
				describe 'revision' do
					context '0 revision' do
					end

					context '1 revision' do
					end

					context '2 revisions' do
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

				# TODO
				describe 'typedef' do
					context '0 typedef' do
					end

					context '1 typedef' do
					end

					context '2 typedefs' do
					end
				end

				# TODO
				describe 'uses' do
					context '0 uses' do
					end

					context '1 uses' do
					end

					context '2 usess' do
					end
				end

				# TODO
				describe 'yang-version' do
					context '0 yang-version' do
					end

					context '1 yang-version' do
					end

					context '2 yang-versions' do
					end
				end
			end # describe '7.2.1. The submodule\'s Substatements'

			# TODO
			describe '7.2.2. The belongs-to Statement' do
				# TODO
				describe 'A submodule MUST only be included by the module to which it belongs, or by another submodule that belongs to that module' do
				end # describe 'A submodule MUST only be included by the module to which it belongs, or by another submodule that belongs to that module'

				# TODO
				describe 'All definitions in the local submodule and any included submodules can be accessed by using the prefix' do
				end # describe 'All definitions in the local submodule and any included submodules can be accessed by using the prefix'

				# TODO
				describe 'The belongs-to\'s Substatements' do
					describe 'prefix' do
					end # describe 'prefix'
				end # describe 'The belongs-to\'s Substatements'
			end # describe '7.2.2. The belongs-to Statement'

			# TODO
			describe '7.2.3. Usage Example' do
			end # describe '7.2.3. Usage Example'
		end # describe '7.2. The submodule Statement'

		# TODO
		describe '7.3. The typedef Statement' do

			# TODO
			describe '7.3.1. The typedef\'s Substatements' do
			end # describe '7.3.1. The typedef\'s Substatements'

			describe 'default' do
				'0..1'
			end # describe 'default'

			describe 'description' do
				'0..1'
			end # describe 'description'

			describe 'reference' do
				'0..1'
			end # describe 'reference'

			describe 'status' do
				'0..1'
			end # describe 'status'

			describe 'type' do
				'1'
			end # describe 'type'

			describe 'units' do
				'0..1'
			end # describe 'units'

			# TODO
			describe '7.3.2. The typedef\'s type Statement' do
			end # describe '7.3.2. The typedef\'s type Statement'

			# TODO
			describe '7.3.3. The units Statement' do
			end # describe '7.3.3. The units Statement'

			# TODO
			describe '7.3.4. The typedef\'s default Statement' do
			end # describe '7.3.4. The typedef\'s default Statement'

			# TODO
			describe '7.3.5. Usage Example' do
			end # describe '7.3.5. Usage Example'

			<<-EOB
     typedef listen-ipv4-address {
	 type inet:ipv4-address;
	 default "0.0.0.0";
     }
			EOB
		end # describe '7.3. The typedef Statement'

		# TODO
		describe '7.4. The type Statement' do

			# TODO
			describe '7.4.1. The type\'s Substatements' do

				describe 'bit' do
					'0..n'
				end # describe 'bit'

				describe 'enum' do
					'0..n'
				end # describe 'enum'

				describe 'length' do
					'0..1'
				end # describe 'length'

				describe 'path' do
					'0..1'
				end # describe 'path'

				describe 'pattern' do
					'0..n'
				end # describe 'pattern'

				describe 'range' do
					'0..1'
				end # describe 'range'

				describe 'require' do
					'0..1'
				end # describe 'require'

				describe 'type' do
					'0..n'
				end # describe 'type'
			end # describe '7.4.1. The type\'s Substatements'

		end # describe '7.4. The type Statement'

		# TODO
		describe '7.5. The container Statement' do

			# TODO
			describe '7.5.1. Containers with Presence' do
			end # describe '7.5.1. Containers with Presence'

			# TODO
			describe '7.5.2. The container\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'if' do
					'0..n'
				end # describe 'if'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'presence' do
					'0..1'
				end # describe 'presence'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

				describe 'when' do
					'0..1'
				end # describe 'when'
			end # describe '7.5.2. The container\'s Substatements'

			# TODO
			describe '7.5.3. The must Statement' do
			end # describe '7.5.3. The must Statement'

			# TODO
			describe '7.5.4. The must\'s Substatements' do

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'error' do
					'0..1'
				end # describe 'error'

				describe 'error' do
					'0..1'
				end # describe 'error'

				describe 'reference' do
					'0..1'
				end # describe 'reference'
			end # describe '7.5.4. The must\'s Substatements'

			# TODO
			describe '7.5.4.1. The error-message Statement' do
			end # describe '7.5.4.1. The error-message Statement'
			# TODO
			describe '7.5.4.2. The error-app-tag Statement' do
			end # describe '7.5.4.2. The error-app-tag Statement'
			# TODO
			describe '7.5.4.3. Usage Example of must and error-message' do
			end # describe '7.5.4.3. Usage Example of must and error-message'

			<<-EOB
     container interface {
	 leaf ifType {
	     type enumeration {
		 enum ethernet;
		 enum atm;
	     }
	 }
	 leaf ifMTU {
	     type uint32;
	 }
	 must "ifType != 'ethernet' or " +
	      "(ifType = 'ethernet' and ifMTU = 1500)" {
	     error-message "An ethernet MTU must be 1500";
	 }
	 must "ifType != 'atm' or " +
	      "(ifType = 'atm' and ifMTU <= 17966 and ifMTU >= 64)" {
	     error-message "An atm MTU must be  64 .. 17966";
	 }
     }
			EOB

			# TODO
			describe '7.5.5. The presence Statement' do
			end # describe '7.5.5. The presence Statement'

			# TODO
			describe '7.5.6. The container\'s Child Node Statements' do
			end # describe '7.5.6. The container\'s Child Node Statements'

			# TODO
			describe '7.5.7. XML Mapping Rules' do
			end # describe '7.5.7. XML Mapping Rules'

			# TODO
			describe '7.5.8. NETCONF <edit-config> Operations' do
			end # describe '7.5.8. NETCONF <edit-config> Operations'

			# TODO
			describe '7.5.9. Usage Example' do
			end # describe '7.5.9. Usage Example'

			<<-EOB
     container system {
	 description "Contains various system parameters";
	 container services {
	     description "Configure externally available services";
	     container "ssh" {
		 presence "Enables SSH";
		 description "SSH service specific configuration";
		 // more leafs, containers and stuff here...
	     }
	 }
     }
   A corresponding XML instance example:
     <system>
       <services>
	 <ssh/>
       </services>
     </system>
   To delete a container with an <edit-config>:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh nc:operation="delete"/>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
			EOB
		end # describe '7.5. The container Statement'

		# TODO
		describe '7.6. The leaf Statement' do

			# TODO
			describe '7.6.1. The leaf\'s default value' do
			end # describe '7.6.1. The leaf\'s default value'

			# TODO
			describe '7.6.2. The leaf\'s Substatements' do

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'default' do
					'0..1'
				end # describe 'default'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if'

				describe 'mandatory' do
					'0..1'
				end # describe 'mandatory'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'type' do
					'1'
				end # describe 'type'

				describe 'units' do
					'0..1'
				end # describe 'units'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.6.2. The leaf\'s Substatements'

			# TODO
			describe '7.6.3. The leaf\'s type Statement' do
			end # describe '7.6.3. The leaf\'s type Statement'

			# TODO
			describe '7.6.4. The leaf\'s default Statement' do
			end # describe '7.6.4. The leaf\'s default Statement'

			# TODO
			describe '7.6.5. The leaf\'s mandatory Statement' do
			end # describe '7.6.5. The leaf\'s mandatory Statement'

			# TODO
			describe '7.6.6. XML Mapping Rules' do
			end # describe '7.6.6. XML Mapping Rules'

			# TODO
			describe '7.6.7. NETCONF <edit-config> Operations' do
			end # describe '7.6.7. NETCONF <edit-config> Operations'

			# TODO
			describe '7.6.8. Usage Example' do
			end # describe '7.6.8. Usage Example'

			<<-EOB
     leaf port {
	 type inet:port-number;
	 default 22;
	 description "The port to which the SSH server listens"
     }
   A corresponding XML instance example:
     <port>2022</port>
   To set the value of a leaf with an <edit-config>:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <port>2022</port>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
			EOB
		end # describe '7.6. The leaf Statement'

		# TODO
		describe '7.7. The leaf-list Statement' do

			# TODO
			describe '7.7.1. Ordering' do
			end # describe '7.7.1. Ordering'

			# TODO
			describe '7.7.2. The leaf-list\'s Substatements' do

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if' do
					'0..n'
				end # describe 'if'

				describe 'max' do
					'0..1'
				end # describe 'max'

				describe 'min' do
					'0..1'
				end # describe 'min'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'ordered' do
					'0..1'
				end # describe 'ordered'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'type' do
					'1'
				end # describe 'type'

				describe 'units' do
					'0..1'
				end # describe 'units'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.7.2. The leaf-list\'s Substatements'

			# TODO
			describe '7.7.3. The min-elements Statement' do
			end # describe '7.7.3. The min-elements Statement'

			# TODO
			describe '7.7.4. The max-elements Statement' do
			end # describe '7.7.4. The max-elements Statement'

			# TODO
			describe '7.7.5. The ordered-by Statement' do
			end # describe '7.7.5. The ordered-by Statement'

			# TODO
			describe '7.7.5.1. ordered-by system' do
			end # describe '7.7.5.1. ordered-by system'

			# TODO
			describe '7.7.5.2. ordered-by user' do
			end # describe '7.7.5.2. ordered-by user'

			# TODO
			describe '7.7.6. XML Mapping Rules' do
			end # describe '7.7.6. XML Mapping Rules'

			# TODO
			describe '7.7.7. NETCONF <edit-config> Operations' do
			end # describe '7.7.7. NETCONF <edit-config> Operations'

			# TODO
			describe '7.7.8. Usage Example' do
			end # describe '7.7.8. Usage Example'

			<<-EOB
     leaf-list allow-user  {
	 type string;
	 description "A list of user name patterns to allow";
     }
   A corresponding XML instance example:
     <allow-user>alice</allow-user>
     <allow-user>bob</allow-user>
   To create a new element in this list, using the default <edit-config>
   operation "merge":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <allow-user>eric</allow-user>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   Given the following ordered-by user leaf-list:
     leaf-list cipher  {
	 type string;
	 ordered-by user;
	 description "A list of ciphers";
     }
   The following would be used to insert a new cipher "blowfish-cbc"
   after "3des-cbc":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:yang="urn:ietf:params:xml:ns:yang:1">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <cipher nc:operation="create"
			 yang:insert="after"
			 yang:value="3des-cbc">blowfish-cbc</cipher>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
			EOB
		end # describe '7.7. The leaf-list Statement'

		# TODO
		describe '7.8. The list Statement' do

			# TODO
			describe '7.8.1. The list\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'key' do
					'0..1'
				end # describe 'key'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'max-elements' do
					'0..1'
				end # describe 'max-elements'

				describe 'min-elements' do
					'0..1'
				end # describe 'min-elements'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'ordered-by' do
					'0..1'
				end # describe 'ordered-by'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'unique' do
					'0..n'
				end # describe 'unique'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.8.1. The list\'s Substatements'

			# TODO
			describe '7.8.2. The list\'s key Statement' do
			end # describe '7.8.2. The list\'s key Statement'

			# TODO
			describe '7.8.3. The list\'s unique Statement' do
			end # describe '7.8.3. The list\'s unique Statement'

			# TODO
			describe '7.8.3.1.  Usage Example' do
			end # describe '7.8.3.1.  Usage Example'

			<<-EOB
		With the following list:
			list server {
			key "name";
			unique "ip port";
			leaf name {
				type string;
			}
			leaf ip {
				type inet:ip-address;
			}
			leaf port {
				type inet:port-number;
			}
		}
			The following configuration is not valid:
				<server>
			<name>smtp</name>
			<ip>192.0.2.1</ip>
			<port>25</port>
			</server>
			<server>
			<name>http</name>
			<ip>192.0.2.1</ip>
			<port>25</port>
			</server>
			The following configuration is valid, since the "http" and "ftp" list
			entries do not have a value for all referenced leafs, and are thus
			not taken into account when the "unique" constraint is enforced:
				<server>
			<name>smtp</name>
			<ip>192.0.2.1</ip>
			<port>25</port>
			</server>
			<server>
			<name>http</name>
			<ip>192.0.2.1</ip>
			</server>
			<server>
			<name>ftp</name>
			<ip>192.0.2.1</ip>
			</server>
			EOB

			# TODO
			describe '7.8.4. The list\'s Child Node Statements' do
			end # describe '7.8.4. The list\'s Child Node Statements'

			# TODO
			describe '7.8.5. XML Mapping Rules' do
			end # describe '7.8.5. XML Mapping Rules'
			# TODO
			describe '7.8.6. NETCONF <edit-config> Operations' do
			end # describe '7.8.6. NETCONF <edit-config> Operations'

			# TODO
			describe '7.8.7. Usage Example' do
			end # describe '7.8.7. Usage Example'

			<<-EOB
				Given the following list:
					list user {
					key "name";
					config true;
					description "This is a list of users in the system.";

					leaf name {
						type string;
					}
					leaf type {
						type string;
					}
					leaf full-name {
						type string;
					}
				}
					A corresponding XML instance example:
						<user>
					<name>fred</name>
					<type>admin</type>
					<full-name>Fred Flintstone</full-name>
					</user>
					To create a new user "barney":
						<rpc message-id="101"
					xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
					xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
					<edit-config>
					<target>
					<running/>
					</target>
					<config>
					<system xmlns="http://example.com/schema/config">
	     <user nc:operation="create">
					<name>barney</name>
					<type>admin</type>
					<full-name>Barney Rubble</full-name>
					</user>
					</system>
					</config>
					</edit-config>
					</rpc>
					To change the type of "fred" to "superuser":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <user>
	       <name>fred</name>
	       <type>superuser</type>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   Given the following ordered-by user list:
     list user {
	 description "This is a list of users in the system.";
	 ordered-by user;
	 config true;

	 key "name";

						leaf name {
	     type string;
	 }
	 leaf type {
	     type string;
	 }
	 leaf full-name {
	     type string;
	 }
     }
   The following would be used to insert a new user "barney" after the
   user "fred":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:yang="urn:ietf:params:xml:ns:yang:1">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config"
		xmlns:ex="http://example.com/schema/config">
	     <user nc:operation="create"
					yang:insert="after"
					yang:key="[ex:name='fred']">
					<name>barney</name>
					<type>admin</type>
					<full-name>Barney Rubble</full-name>
					</user>
					</system>
					</config>
					</edit-config>
					</rpc>
					The following would be used to move the user "barney" before the user
					"fred":
						<rpc message-id="101"
					xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
					xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
					xmlns:yang="urn:ietf:params:xml:ns:yang:1">
					<edit-config>
					<target>
					<running/>
					</target>
					<config>
					<system xmlns="http://example.com/schema/config"
		xmlns:ex="http://example.com/schema/config">
	     <user nc:operation="merge"
					yang:insert="before"
					yang:key="[ex:name='fred']">
	       <name>barney</name>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
			EOB
		end # describe '7.8. The list Statement'

		# TODO
		describe '7.9. The choice Statement' do

			# TODO
			describe '7.9.1. The choice\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'case' do
					'0..n'
				end # describe 'case'

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'default' do
					'0..1'
				end # describe 'default'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'mandatory' do
					'0..1'
				end # describe 'mandatory'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.9.1. The choice\'s Substatements'

			# TODO
			describe '7.9.2. The choice\'s case Statement' do
			end # describe '7.9.2. The choice\'s case Statement'

			<<-EOB
   For example, the following is illegal:
     choice interface-type {     // This example is illegal YANG
	 case a {
	     leaf ethernet { ... }
	 }
	 case b {
	     container ethernet { ...}
	 }
     }
   example:
     choice interface-type {
	 container ethernet { ... }
     }
   is equivalent to:
     choice interface-type {
	 case ethernet {
	     container ethernet { ... }
	 }
     }
			EOB

			# TODO
			describe '7.9.2.1.  The case\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.9.2.1.  The case\'s Substatements'

			# TODO
			describe '7.9.3. The choice\'s default Statement' do
			end # describe '7.9.3. The choice\'s default Statement'

			<<-EOB
     container transfer {
	 choice how {
	     default interval;
	     case interval {
		 leaf interval {
		     type uint16;
		     default 30;
		     units minutes;
		 }
	     }
	     case daily {
		 leaf daily {
		     type empty;
		 }
		 leaf time-of-day {
		     type string;
		     units 24-hour-clock;
		     default 1am;
		 }
	     }
	     case manual {
		 leaf manual {
		     type empty;
		 }
	     }
	 }
     }
			EOB

			# TODO
			describe '7.9.4. The choice\'s mandatory Statement' do
			end # describe '7.9.4. The choice\'s mandatory Statement'

			# TODO
			describe '7.9.5. XML Mapping Rules' do
			end # describe '7.9.5. XML Mapping Rules'

			# TODO
			describe '7.9.6. NETCONF <edit-config> Operations' do
			end # describe '7.9.6. NETCONF <edit-config> Operations'

			# TODO
			describe '7.9.7. Usage Example' do
			end # describe '7.9.7. Usage Example'

			<<-EOB
   Given the following choice:
     container protocol {
	 choice name {
	     case a {
		 leaf udp {
		     type empty;
		 }
	     }
	     case b {
		 leaf tcp {
		    type empty;
		 }
	     }
	 }
     }
   A corresponding XML instance example:
     <protocol>
       <tcp/>
     </protocol>
   To change the protocol from tcp to udp:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <protocol>
	       <udp nc:operation="create"/>
					</protocol>
					</system>
					</config>
					</edit-config>
					</rpc>
			EOB
		end # describe '7.9. The choice Statement'

		# TODO
		describe '7.10. The anyxml Statement' do


			# TODO
			describe '7.10.1. The anyxml\'s Substatements' do

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'mandatory' do
					'0..1'
				end # describe 'mandatory'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.10.1. The anyxml\'s Substatements'

			<<-EOB
   Given the following "anyxml" statement:
     anyxml data;
   The following are two valid encodings of the same anyxml value:
     <data xmlns:if="http://example.com/ns/interface">
       <if:interface>
	 <if:ifIndex>1</if:ifIndex>
       </if:interface>
     </data>
     <data>
       <interface xmlns="http://example.com/ns/interface">
	 <ifIndex>1</ifIndex>
       </interface>
     </data>
			EOB

			# TODO
			describe '7.10.2. XML Mapping Rules' do
			end # describe '7.10.2. XML Mapping Rules'

			# TODO
			describe '7.10.3. NETCONF <edit-config> Operations' do
			end # describe '7.10.3. NETCONF <edit-config> Operations'

			# TODO
			describe '7.10.4. Usage Example' do
			end # describe '7.10.4. Usage Example'
		end # describe '7.10. The anyxml Statement'

		# TODO
		describe '7.11. The grouping Statement' do

			# TODO
			describe '7.11.1. The grouping\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

			end # describe '7.11.1. The grouping\'s Substatements'

			# TODO
			describe '7.11.2. Usage Example' do
			end # describe '7.11.2. Usage Example'

			<<-EOB
     import ietf-inet-types {
	 prefix "inet";
     }

     grouping endpoint {
	 description "A reusable endpoint group.";
	 leaf ip {
	     type inet:ip-address;
	 }
	 leaf port {
	     type inet:port-number;
	 }
     }
			EOB
		end # describe '7.11. The grouping Statement'

		# TODO
		describe '7.12. The uses Statement' do

			# TODO
			describe '7.12.1. The uses\'s Substatements' do

				describe 'augment' do
					'0..1'
				end # describe 'augment'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'refine' do
					'0..1'
				end # describe 'refine'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.12.1. The uses\'s Substatements'

			# TODO
			describe '7.12.2. The refine Statement' do
			end # describe '7.12.2. The refine Statement'

			# TODO
			describe '7.12.3. XML Mapping Rules' do
			end # describe '7.12.3. XML Mapping Rules'

			# TODO
			describe '7.12.4. Usage Example' do
			end # describe '7.12.4. Usage Example'

			<<-EOB
   we can do:
     import acme-system {
	 prefix "acme";
     }
     container http-server {
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint;
     }
   A corresponding XML instance example:
     <http-server>
       <name>extern-web</name>
       <ip>192.0.2.1</ip>
       <port>80</port>
     </http-server>
   If port 80 should be the default for the HTTP server, default can be added:
     container http-server {
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint {
	     refine port {
		 default 80;
	     }
	 }
     }
   If we want to define a list of servers, and each server has the ip and port as keys, we can do:
     list server {
	 key "ip port";
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint;
     }
   The following is an error:
     container http-server {
	 uses acme:endpoint;
	 leaf ip {          // illegal - same identifier "ip" used twice
		 type string;
	 }
     }
			EOB
		end # describe '7.12. The uses Statement'

		# TODO
		describe '7.13. The rpc Statement' do

			# TODO
			describe '7.13.1. The rpc\'s Substatements' do

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'input' do
					'0..1'
				end # describe 'input'

				describe 'output' do
					'0..1'
				end # describe 'output'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

			end # describe '7.13.1. The rpc\'s Substatements'

			# TODO
			describe '7.13.2. The input Statement' do
			end # describe '7.13.2. The input Statement'

			# TODO
			describe '7.13.2.1.  The input\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

			end # describe '7.13.2.1.  The input\'s Substatements'

			# TODO
			describe '7.13.3. The output Statement' do
			end # describe '7.13.3. The output Statement'


			# TODO
			describe '7.13.3.1.  The output\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

			end # describe '7.13.3.1.  The output\'s Substatements'

			# TODO
			describe '7.13.4. XML Mapping Rules' do
			end # describe '7.13.4. XML Mapping Rules'

			# TODO
			describe '7.13.5. Usage Example' do
			end # describe '7.13.5. Usage Example'

			<<-EOB
   The following example defines an RPC operation:
     module rock {
	 namespace "http://example.net/rock";
	 prefix "rock";

			 rpc rock-the-house {
	     input {
		 leaf zip-code {
		     type string;
		 }
	     }
	 }
     }
   A corresponding XML instance example of the complete rpc and rpc- reply:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
       <rock-the-house xmlns="http://example.net/rock">
	 <zip-code>27606-0100</zip-code>
       </rock-the-house>
     </rpc>
     <rpc-reply message-id="101"
		xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
       <ok/>
     </rpc-reply>
			EOB
		end # describe '7.13. The rpc Statement'

		# TODO
		describe '7.14. The notification Statement' do

			# TODO
			describe '7.14.1. The notification\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'grouping' do
					'0..n'
				end # describe 'grouping'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'typedef' do
					'0..n'
				end # describe 'typedef'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

			end # describe '7.14.1. The notification\'s Substatements'

			# TODO
			describe '7.14.2. XML Mapping Rules' do
			end # describe '7.14.2. XML Mapping Rules'

			# TODO
			describe '7.14.3. Usage Example' do
			end # describe '7.14.3. Usage Example'

			<<-EOB
   The following example defines a notification:
     module event {

	 namespace "http://example.com/event";
	 prefix "ev";

	 notification event {
	     leaf event-class {
		 type string;
	     }
	     anyxml reporting-entity;
	     leaf severity {
		 type string;
	     }
	 }
     }
   A corresponding XML instance example of the complete notification:
     <notification
       xmlns="urn:ietf:params:xml:ns:netconf:notification:1.0">
       <eventTime>2008-07-08T00:01:00Z</eventTime>
       <event xmlns="http://example.com/event">
	 <event-class>fault</event-class>
	 <reporting-entity>
	   <card>Ethernet0</card>
	 </reporting-entity>
	 <severity>major</severity>
       </event>
     </notification>
			EOB
		end # describe '7.14. The notification Statement'

		# TODO
		describe '7.15. The augment Statement' do

			# TODO
			describe '7.15.1. The augment\'s Substatements' do

				describe 'anyxml' do
					'0..n'
				end # describe 'anyxml'

				describe 'case' do
					'0..n'
				end # describe 'case'

				describe 'choice' do
					'0..n'
				end # describe 'choice'

				describe 'container' do
					'0..n'
				end # describe 'container'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'leaf' do
					'0..n'
				end # describe 'leaf'

				describe 'leaf-list' do
					'0..n'
				end # describe 'leaf-list'

				describe 'list' do
					'0..n'
				end # describe 'list'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'uses' do
					'0..n'
				end # describe 'uses'

				describe 'when' do
					'0..1'
				end # describe 'when'

			end # describe '7.15.1. The augment\'s Substatements'

			# TODO
			describe '7.15.2. XML Mapping Rules' do
			end # describe '7.15.2. XML Mapping Rules'

			# TODO
			describe '7.15.3. Usage Example' do
			end # describe '7.15.3. Usage Example'

			<<-EOB
   In namespace http://example.com/schema/interfaces, we have:
     container interfaces {
	 list ifEntry {
	     key "ifIndex";

	     leaf ifIndex {
		 type uint32;
	     }
	     leaf ifDescr {
		 type string;
	     }
	     leaf ifType {
		 type iana:IfType;
	     }
	     leaf ifMtu {
		 type int32;
	     }
	 }
     }
   Then, in namespace http://example.com/schema/ds0, we have:
     import interface-module {
	 prefix "if";
     }
     augment "/if:interfaces/if:ifEntry" {
	 when "if:ifType='ds0'";
	 leaf ds0ChannelNumber {
	     type ChannelNumber;
	 }
     }
   A corresponding XML instance example:
     <interfaces xmlns="http://example.com/schema/interfaces"
		 xmlns:ds0="http://example.com/schema/ds0">
       <ifEntry>
	 <ifIndex>1</ifIndex>
	 <ifDescr>Flintstone Inc Ethernet A562</ifDescr>
	 <ifType>ethernetCsmacd</ifType>
	 <ifMtu>1500</ifMtu>
       </ifEntry>
       <ifEntry>
	 <ifIndex>2</ifIndex>
	 <ifDescr>Flintstone Inc DS0</ifDescr>
	 <ifType>ds0</ifType>
	 <ds0:ds0ChannelNumber>1</ds0:ds0ChannelNumber>
       </ifEntry>
     </interfaces>
   As another example, suppose we have the choice defined in Section 7.9.7.  The following construct can be used to extend the protocol definition:
     augment /ex:system/ex:protocol/ex:name {
	 case c {
	     leaf smtp {
		 type empty;
	     }
	 }
     }
   A corresponding XML instance example:
     <ex:system>
       <ex:protocol>
	 <ex:tcp/>
       </ex:protocol>
     </ex:system>
   or
     <ex:system>
       <ex:protocol>
	 <other:smtp/>
       </ex:protocol>
     </ex:system>
			EOB
		end # describe '7.15. The augment Statement'

		# TODO
		describe '7.16. The identity Statement' do

			# TODO
			describe '7.16.1. The identity\'s Substatements' do

				describe 'base' do
					'0..1'
				end # describe 'base'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

			end # describe '7.16.1. The identity\'s Substatements'

			# TODO
			describe '7.16.2. The base Statement' do
			end # describe '7.16.2. The base Statement'

			# TODO
			describe '7.16.3. Usage Example' do
			end # describe '7.16.3. Usage Example'

			<<-EOB
     module crypto-base {
	 namespace "http://example.com/crypto-base";
	 prefix "crypto";

			 identity crypto-alg {
	     description
			 "Base identity from which all crypto algorithms
		 are derived.";
	 }
     }
     module des {
	 namespace "http://example.com/des";
	 prefix "des";

	 import "crypto-base" {
	     prefix "crypto";
	 }

	 identity des {
	     base "crypto:crypto-alg";
	     description "DES crypto algorithm";
	 }

	 identity des3 {
	     base "crypto:crypto-alg";
	     description "Triple DES crypto algorithm";
	 }
     }
			EOB
		end # describe '7.16. The identity Statement'

		# TODO
		describe '7.17. The extension Statement' do

			# TODO
			describe '7.17.1. The extension\'s Substatements' do

				describe 'argument' do
					'0..1'
				end # describe 'argument'

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

				describe 'status' do
					'0..1'
				end # describe 'status'

			end # describe '7.17.1. The extension\'s Substatements'

			# TODO
			describe '7.17.2. The argument Statement' do
			end # describe '7.17.2. The argument Statement'

			# TODO
			describe '7.17.2.1.  The argument\'s Substatements' do

				describe 'yin-element' do
					'0..1'
				end # describe 'yin-element'

			end # describe '7.17.2.1.  The argument\'s Substatements'

			# TODO
			describe '7.17.2.2.  The yin-element Statement' do
			end # describe '7.17.2.2.  The yin-element Statement'

			# TODO
			describe '7.17.3. Usage Example' do
			end # describe '7.17.3. Usage Example'

			<<-EOB
   To define an extension:
     module my-extensions {
       ...

       extension c-define {
	 description
	   "Takes as argument a name string.
	   Makes the code generator use the given name in the
	   #define.";
	 argument "name";
       }
     }
   To use the extension:
     module my-interfaces {
       ...
       import my-extensions {
	 prefix "myext";
       }
       ...

       container interfaces {
	 ...
	 myext:c-define "MY_INTERFACES";
       }
     }
			EOB
		end # describe '7.17. The extension Statement'

		# TODO
		describe '7.18. Conformance-Related Statements' do

			# TODO
			describe '7.18.1. The feature Statement' do
			end # describe '7.18.1. The feature Statement'

			<<-EOB
     module syslog {
	 ...
	 feature local-storage {
	     description
		 "This feature means the device supports local
		  storage (memory, flash or disk) that can be used to
		  store syslog messages.";
	 }

	 container syslog {
	     leaf local-storage-limit {
		 if-feature local-storage;
		 type uint64;
		 units "kilobyte";
		 config false;
		 description
		     "The amount of local storage that can be
		      used to hold syslog messages.";
	     }
	 }
     }
			EOB

			# TODO
			describe '7.18.1.1.  The feature\'s Substatements' do

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'if-feature' do
					'0..n'
				end # describe 'if-feature'

				describe 'status' do
					'0..1'
				end # describe 'status'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

			end # describe '7.18.1.1.  The feature\'s Substatements'

			# TODO
			describe '7.18.2. The if-feature Statement' do
			end # describe '7.18.2. The if-feature Statement'

			# TODO
			describe '7.18.3. The deviation Statement' do
			end # describe '7.18.3. The deviation Statement'

			# TODO
			describe '7.18.3.1.  The deviation\'s Substatements' do

				describe 'description' do
					'0..1'
				end # describe 'description'

				describe 'deviate' do
					'1..n'
				end # describe 'deviate'

				describe 'reference' do
					'0..1'
				end # describe 'reference'

			end # describe '7.18.3.1.  The deviation\'s Substatements'

			# TODO
			describe '7.18.3.2.  The deviate Statement' do
			end # describe '7.18.3.2.  The deviate Statement'

			# TODO
			describe 'The deviates\'s Substatements' do

				describe 'config' do
					'0..1'
				end # describe 'config'

				describe 'default' do
					'0..1'
				end # describe 'default'

				describe 'mandatory' do
					'0..1'
				end # describe 'mandatory'

				describe 'max-elements' do
					'0..1'
				end # describe 'max-elements'

				describe 'min-elements' do
					'0..1'
				end # describe 'min-elements'

				describe 'must' do
					'0..n'
				end # describe 'must'

				describe 'type' do
					'0..1'
				end # describe 'type'

				describe 'unique' do
					'0..n'
				end # describe 'unique'

				describe 'units' do
					'0..1'
				end # describe 'units'

			end # describe 'The deviates\'s Substatements'

			# TODO
			describe '7.18.3.3.  Usage Example' do
			end # describe '7.18.3.3.  Usage Example'

			<<-EOB
   In this example, the device is informing client applications that it
   does not support the "daytime" service in the style of RFC 867.
     deviation /base:system/base:daytime {
	 deviate not-supported;
     }
   The following example sets a device-specific default value to a leaf
   that does not have a default value defined:
     deviation /base:system/base:user/base:type {
	 deviate add {
	     default "admin"; // new users are 'admin' by default
	 }
     }
   In this example, the device limits the number of name servers to 3:
     deviation /base:system/base:name-server {
	 deviate replace {
	     max-elements 3;
	 }
     }
   If the original definition is:
     container system {
	 must "daytime or time";
	 ...
     }
   a device might remove this must constraint by doing:
     deviation "/base:system" {
	 deviate delete {
	     must "daytime or time";
	 }
     }
			EOB
		end # describe '7.18. Conformance-Related Statements'

		# TODO
		describe '7.19. Common Statements' do

			# TODO
			describe '7.19.1. The config Statement' do
			end # describe '7.19.1. The config Statement'

			# TODO
			describe '7.19.2. The status Statement' do
			end # describe '7.19.2. The status Statement'

			<<-EOB
   For example, the following is illegal:
     typedef my-type {
       status deprecated;
       type int32;
     }

     leaf my-leaf {
       status current;
       type my-type; // illegal, since my-type is deprecated
     }
			EOB

			# TODO
			describe '7.19.3. The description Statement' do
			end # describe '7.19.3. The description Statement'

			# TODO
			describe '7.19.4. The reference Statement' do
			end # describe '7.19.4. The reference Statement'

			<<-EOB
   For example, a typedef for a "uri" data type could look like:
     typedef uri {
       type string;
       reference
	 "RFC 3986: Uniform Resource Identifier (URI): Generic Syntax";
       ...
     }
			EOB

			# TODO
			describe '7.19.5. The when Statement' do
			end # describe '7.19.5. The when Statement'

		end # describe '7.19. Common Statements'

	end # describe '7. YANG Statements'
end # describe 'RFC6020'

<<-EOB
1. Introduction
2. Keywords
3. Terminology
3.1. Mandatory Nodes
4. YANG Overview
4.1. Functional Overview
4.2. Language Overview
4.2.1. Modules and Submodules
4.2.2. Data Modeling Basics
4.2.3. State Data
4.2.4. Built-In Types
4.2.5. Derived Types (typedef)
4.2.6. Reusable Node Groups (grouping)
4.2.7. Choices
4.2.8. Extending Data Models (augment)
4.2.9. RPC Definitions
4.2.10. Notification Definitions
5. Language Concepts
5.1. Modules and Submodules
5.1.1. Import and Include by Revision
5.1.2. Module Hierarchies
5.2. File Layout
5.3. XML Namespaces
5.3.1. YANG XML Namespace
5.4. Resolving Grouping, Type, and Identity Names
5.5. Nested Typedefs and Groupings
5.6. Conformance
5.6.1. Basic Behavior
5.6.2. Optional Features
5.6.3. Deviations
5.6.4. Announcing Conformance Information in the <hello> Message
5.7. Data Store Modification
6. YANG Syntax
6.1. Lexical Tokenization
6.1.1. Comments
6.1.2. Tokens
6.1.3. Quoting
6.2. Identifiers
6.2.1. Identifiers and Their Namespaces
6.3. Statements
6.3.1. Language Extensions
6.4. XPath Evaluations
6.4.1. XPath Context
6.5. Schema Node Identifier
7. YANG Statements
7.1. The module Statement
7.1.1. The module's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | augment      | 7.15    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | contact      | 7.1.8   | 0..1        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | deviation    | 7.18.3  | 0..n        |
		 | extension    | 7.17    | 0..n        |
		 | feature      | 7.18.1  | 0..n        |
		 | grouping     | 7.11    | 0..n        |
		 | identity     | 7.16    | 0..n        |
		 | import       | 7.1.5   | 0..n        |
		 | include      | 7.1.6   | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | namespace    | 7.1.3   | 1           |
		 | notification | 7.14    | 0..n        |
		 | organization | 7.1.7   | 0..1        |
		 | prefix       | 7.1.4   | 1           |
		 | reference    | 7.19.4  | 0..1        |
		 | revision     | 7.1.9   | 0..n        |
		 | rpc          | 7.13    | 0..n        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 | yang-version | 7.1.2   | 0..1        |
		 +--------------+---------+-------------+
7.1.2. The yang-version Statement
7.1.3. The namespace Statement
7.1.4. The prefix Statement
7.1.5. The import Statement
			The import's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | prefix        | 7.1.4   | 1           |
		 | revision-date | 7.1.5.1 | 0..1        |
		 +---------------+---------+-------------+
7.1.5.1. The import's revision-date Statement
7.1.6. The include Statement
		       The includes's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | revision-date | 7.1.5.1 | 0..1        |
		 +---------------+---------+-------------+
7.1.7. The organization Statement
7.1.8. The contact Statement
7.1.9. The revision Statement
7.1.9.1. The revision's Substatement
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 +--------------+---------+-------------+
7.1.10. Usage Example
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
7.2. The submodule Statement
7.2.1. The submodule's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | augment      | 7.15    | 0..n        |
		 | belongs-to   | 7.2.2   | 1           |
		 | choice       | 7.9     | 0..n        |
		 | contact      | 7.1.8   | 0..1        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | deviation    | 7.18.3  | 0..n        |
		 | extension    | 7.17    | 0..n        |
		 | feature      | 7.18.1  | 0..n        |
		 | grouping     | 7.11    | 0..n        |
		 | identity     | 7.16    | 0..n        |
		 | import       | 7.1.5   | 0..n        |
		 | include      | 7.1.6   | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | notification | 7.14    | 0..n        |
		 | organization | 7.1.7   | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | revision     | 7.1.9   | 0..n        |
		 | rpc          | 7.13    | 0..n        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 | yang-version | 7.1.2   | 0..1        |
		 +--------------+---------+-------------+
7.2.2. The belongs-to Statement
		      The belongs-to's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | prefix       | 7.1.4   | 1           |
		 +--------------+---------+-------------+
7.2.3. Usage Example
     submodule acme-types {

	 belongs-to "acme-system" {
	     prefix "acme";
	 }

	 import ietf-yang-types {
	     prefix "yang";
	 }

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
	     "This submodule defines common ACME types.";

	 revision "2007-06-09" {
	     description "Initial revision.";
	 }

	 // definitions follows...
     }
7.3. The typedef Statement
7.3.1. The typedef's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | default      | 7.3.4   | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | type         | 7.3.2   | 1           |
		 | units        | 7.3.3   | 0..1        |
		 +--------------+---------+-------------+
7.3.2. The typedef's type Statement
7.3.3. The units Statement
7.3.4. The typedef's default Statement
7.3.5. Usage Example
     typedef listen-ipv4-address {
	 type inet:ipv4-address;
	 default "0.0.0.0";
     }
7.4. The type Statement
7.4.1. The type's Substatements
	       +------------------+---------+-------------+
	       | substatement     | section | cardinality |
	       +------------------+---------+-------------+
	       | bit              | 9.7.4   | 0..n        |
	       | enum             | 9.6.4   | 0..n        |
	       | length           | 9.4.4   | 0..1        |
	       | path             | 9.9.2   | 0..1        |
	       | pattern          | 9.4.6   | 0..n        |
	       | range            | 9.2.4   | 0..1        |
	       | require-instance | 9.13.2  | 0..1        |
	       | type             | 7.4     | 0..n        |
	       +------------------+---------+-------------+
7.5. The container Statement
7.5.1. Containers with Presence
7.5.2. The container's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | config       | 7.19.1  | 0..1        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | grouping     | 7.11    | 0..n        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | must         | 7.5.3   | 0..n        |
		 | presence     | 7.5.5   | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.5.3. The must Statement
7.5.4. The must's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | description   | 7.19.3  | 0..1        |
		 | error-app-tag | 7.5.4.2 | 0..1        |
		 | error-message | 7.5.4.1 | 0..1        |
		 | reference     | 7.19.4  | 0..1        |
		 +---------------+---------+-------------+
7.5.4.1. The error-message Statement
7.5.4.2. The error-app-tag Statement
7.5.4.3. Usage Example of must and error-message
     container interface {
	 leaf ifType {
	     type enumeration {
		 enum ethernet;
		 enum atm;
	     }
	 }
	 leaf ifMTU {
	     type uint32;
	 }
	 must "ifType != 'ethernet' or " +
	      "(ifType = 'ethernet' and ifMTU = 1500)" {
	     error-message "An ethernet MTU must be 1500";
	 }
	 must "ifType != 'atm' or " +
	      "(ifType = 'atm' and ifMTU <= 17966 and ifMTU >= 64)" {
	     error-message "An atm MTU must be  64 .. 17966";
	 }
     }
7.5.5. The presence Statement
7.5.6. The container's Child Node Statements
7.5.7. XML Mapping Rules
7.5.8. NETCONF <edit-config> Operations
7.5.9. Usage Example
     container system {
	 description "Contains various system parameters";
	 container services {
	     description "Configure externally available services";
	     container "ssh" {
		 presence "Enables SSH";
		 description "SSH service specific configuration";
		 // more leafs, containers and stuff here...
	     }
	 }
     }
   A corresponding XML instance example:
     <system>
       <services>
	 <ssh/>
       </services>
     </system>
   To delete a container with an <edit-config>:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh nc:operation="delete"/>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
7.6. The leaf Statement
7.6.1. The leaf's default value
7.6.2. The leaf's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | config       | 7.19.1  | 0..1        |
		 | default      | 7.6.4   | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | mandatory    | 7.6.5   | 0..1        |
		 | must         | 7.5.3   | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | type         | 7.6.3   | 1           |
		 | units        | 7.3.3   | 0..1        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.6.3. The leaf's type Statement
7.6.4. The leaf's default Statement
7.6.5. The leaf's mandatory Statement
7.6.6. XML Mapping Rules
7.6.7. NETCONF <edit-config> Operations
7.6.8. Usage Example
     leaf port {
	 type inet:port-number;
	 default 22;
	 description "The port to which the SSH server listens"
     }
   A corresponding XML instance example:
     <port>2022</port>
   To set the value of a leaf with an <edit-config>:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <port>2022</port>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
7.7. The leaf-list Statement
7.7.1. Ordering
7.7.2. The leaf-list's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | config       | 7.19.1  | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | max-elements | 7.7.4   | 0..1        |
		 | min-elements | 7.7.3   | 0..1        |
		 | must         | 7.5.3   | 0..n        |
		 | ordered-by   | 7.7.5   | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | type         | 7.4     | 1           |
		 | units        | 7.3.3   | 0..1        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.7.3. The min-elements Statement
7.7.4. The max-elements Statement
7.7.5. The ordered-by Statement
7.7.5.1. ordered-by system
7.7.5.2. ordered-by user
7.7.6. XML Mapping Rules
7.7.7. NETCONF <edit-config> Operations
7.7.8. Usage Example
     leaf-list allow-user  {
	 type string;
	 description "A list of user name patterns to allow";
     }
   A corresponding XML instance example:
     <allow-user>alice</allow-user>
     <allow-user>bob</allow-user>
   To create a new element in this list, using the default <edit-config>
   operation "merge":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <allow-user>eric</allow-user>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   Given the following ordered-by user leaf-list:
     leaf-list cipher  {
	 type string;
	 ordered-by user;
	 description "A list of ciphers";
     }
   The following would be used to insert a new cipher "blowfish-cbc"
   after "3des-cbc":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:yang="urn:ietf:params:xml:ns:yang:1">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <services>
	       <ssh>
		 <cipher nc:operation="create"
			 yang:insert="after"
			 yang:value="3des-cbc">blowfish-cbc</cipher>
	       </ssh>
	     </services>
	   </system>
	 </config>
       </edit-config>
     </rpc>
7.8. The list Statement
7.8.1. The list's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | config       | 7.19.1  | 0..1        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | grouping     | 7.11    | 0..n        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | key          | 7.8.2   | 0..1        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | max-elements | 7.7.4   | 0..1        |
		 | min-elements | 7.7.3   | 0..1        |
		 | must         | 7.5.3   | 0..n        |
		 | ordered-by   | 7.7.5   | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | typedef      | 7.3     | 0..n        |
		 | unique       | 7.8.3   | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.8.2. The list's key Statement
7.8.3. The list's unique Statement
7.8.3.1.  Usage Example
   With the following list:
     list server {
	 key "name";
	 unique "ip port";
	 leaf name {
	     type string;
	 }
	 leaf ip {
	     type inet:ip-address;
	 }
	 leaf port {
	     type inet:port-number;
	 }
     }
   The following configuration is not valid:
     <server>
       <name>smtp</name>
       <ip>192.0.2.1</ip>
       <port>25</port>
     </server>
     <server>
       <name>http</name>
       <ip>192.0.2.1</ip>
       <port>25</port>
     </server>
   The following configuration is valid, since the "http" and "ftp" list
   entries do not have a value for all referenced leafs, and are thus
   not taken into account when the "unique" constraint is enforced:
     <server>
       <name>smtp</name>
       <ip>192.0.2.1</ip>
       <port>25</port>
     </server>
     <server>
       <name>http</name>
       <ip>192.0.2.1</ip>
     </server>
     <server>
       <name>ftp</name>
       <ip>192.0.2.1</ip>
     </server>
7.8.4. The list's Child Node Statements
7.8.5. XML Mapping Rules
7.8.6. NETCONF <edit-config> Operations
7.8.7. Usage Example
   Given the following list:
     list user {
	 key "name";
	 config true;
	 description "This is a list of users in the system.";

	 leaf name {
	     type string;
	 }
	 leaf type {
	     type string;
	 }
	 leaf full-name {
	     type string;
	 }
     }
   A corresponding XML instance example:
     <user>
       <name>fred</name>
       <type>admin</type>
       <full-name>Fred Flintstone</full-name>
     </user>
   To create a new user "barney":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <user nc:operation="create">
	       <name>barney</name>
	       <type>admin</type>
	       <full-name>Barney Rubble</full-name>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   To change the type of "fred" to "superuser":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <user>
	       <name>fred</name>
	       <type>superuser</type>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   Given the following ordered-by user list:
     list user {
	 description "This is a list of users in the system.";
	 ordered-by user;
	 config true;

	 key "name";

	 leaf name {
	     type string;
	 }
	 leaf type {
	     type string;
	 }
	 leaf full-name {
	     type string;
	 }
     }
   The following would be used to insert a new user "barney" after the
   user "fred":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:yang="urn:ietf:params:xml:ns:yang:1">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config"
		xmlns:ex="http://example.com/schema/config">
	     <user nc:operation="create"
		   yang:insert="after"
		   yang:key="[ex:name='fred']">
	       <name>barney</name>
	       <type>admin</type>
	       <full-name>Barney Rubble</full-name>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
   The following would be used to move the user "barney" before the user
   "fred":
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:yang="urn:ietf:params:xml:ns:yang:1">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config"
		xmlns:ex="http://example.com/schema/config">
	     <user nc:operation="merge"
		   yang:insert="before"
		   yang:key="[ex:name='fred']">
	       <name>barney</name>
	     </user>
	   </system>
	 </config>
       </edit-config>
     </rpc>
7.9. The choice Statement
7.9.1. The choice's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | case         | 7.9.2   | 0..n        |
		 | config       | 7.19.1  | 0..1        |
		 | container    | 7.5     | 0..n        |
		 | default      | 7.9.3   | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | mandatory    | 7.9.4   | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.9.2. The choice's case Statement
   For example, the following is illegal:
     choice interface-type {     // This example is illegal YANG
	 case a {
	     leaf ethernet { ... }
	 }
	 case b {
	     container ethernet { ...}
	 }
     }
   example:
     choice interface-type {
	 container ethernet { ... }
     }
   is equivalent to:
     choice interface-type {
	 case ethernet {
	     container ethernet { ... }
	 }
     }
7.9.2.1.  The case's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | uses         | 7.12    | 0..n        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.9.3. The choice's default Statement
     container transfer {
	 choice how {
	     default interval;
	     case interval {
		 leaf interval {
		     type uint16;
		     default 30;
		     units minutes;
		 }
	     }
	     case daily {
		 leaf daily {
		     type empty;
		 }
		 leaf time-of-day {
		     type string;
		     units 24-hour-clock;
		     default 1am;
		 }
	     }
	     case manual {
		 leaf manual {
		     type empty;
		 }
	     }
	 }
     }
7.9.4. The choice's mandatory Statement
7.9.5. XML Mapping Rules
7.9.6. NETCONF <edit-config> Operations
7.9.7. Usage Example
   Given the following choice:
     container protocol {
	 choice name {
	     case a {
		 leaf udp {
		     type empty;
		 }
	     }
	     case b {
		 leaf tcp {
		    type empty;
		 }
	     }
	 }
     }
   A corresponding XML instance example:
     <protocol>
       <tcp/>
     </protocol>
   To change the protocol from tcp to udp:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
	  xmlns:nc="urn:ietf:params:xml:ns:netconf:base:1.0">
       <edit-config>
	 <target>
	   <running/>
	 </target>
	 <config>
	   <system xmlns="http://example.com/schema/config">
	     <protocol>
	       <udp nc:operation="create"/>
	     </protocol>
	   </system>
	 </config>
       </edit-config>
     </rpc>
7.10. The anyxml Statement
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | config       | 7.19.1  | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | mandatory    | 7.6.5   | 0..1        |
		 | must         | 7.5.3   | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.10.1. The anyxml's Substatements
   Given the following "anyxml" statement:
     anyxml data;
   The following are two valid encodings of the same anyxml value:
     <data xmlns:if="http://example.com/ns/interface">
       <if:interface>
	 <if:ifIndex>1</if:ifIndex>
       </if:interface>
     </data>
     <data>
       <interface xmlns="http://example.com/ns/interface">
	 <ifIndex>1</ifIndex>
       </interface>
     </data>
7.10.2. XML Mapping Rules
7.10.3. NETCONF <edit-config> Operations
7.10.4. Usage Example
7.11. The grouping Statement
7.11.1. The grouping's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | grouping     | 7.11    | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 +--------------+---------+-------------+
7.11.2. Usage Example
     import ietf-inet-types {
	 prefix "inet";
     }

     grouping endpoint {
	 description "A reusable endpoint group.";
	 leaf ip {
	     type inet:ip-address;
	 }
	 leaf port {
	     type inet:port-number;
	 }
     }
7.12. The uses Statement
7.12.1. The uses's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | augment      | 7.15    | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | refine       | 7.12.2  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.12.2. The refine Statement
7.12.3. XML Mapping Rules
7.12.4. Usage Example
   we can do:
     import acme-system {
	 prefix "acme";
     }
     container http-server {
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint;
     }
   A corresponding XML instance example:
     <http-server>
       <name>extern-web</name>
       <ip>192.0.2.1</ip>
       <port>80</port>
     </http-server>
   If port 80 should be the default for the HTTP server, default can be added:
     container http-server {
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint {
	     refine port {
		 default 80;
	     }
	 }
     }
   If we want to define a list of servers, and each server has the ip and port as keys, we can do:
     list server {
	 key "ip port";
	 leaf name {
	     type string;
	 }
	 uses acme:endpoint;
     }
   The following is an error:
     container http-server {
	 uses acme:endpoint;
	 leaf ip {          // illegal - same identifier "ip" used twice
	     type string;
	 }
     }
7.13. The rpc Statement
7.13.1. The rpc's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | description  | 7.19.3  | 0..1        |
		 | grouping     | 7.11    | 0..n        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | input        | 7.13.2  | 0..1        |
		 | output       | 7.13.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | typedef      | 7.3     | 0..n        |
		 +--------------+---------+-------------+
7.13.2. The input Statement
7.13.2.1.  The input's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | grouping     | 7.11    | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 +--------------+---------+-------------+
7.13.3. The output Statement
7.13.3.1.  The output's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | grouping     | 7.11    | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 +--------------+---------+-------------+
7.13.4. XML Mapping Rules
7.13.5. Usage Example
   The following example defines an RPC operation:
     module rock {
	 namespace "http://example.net/rock";
	 prefix "rock";

	 rpc rock-the-house {
	     input {
		 leaf zip-code {
		     type string;
		 }
	     }
	 }
     }
   A corresponding XML instance example of the complete rpc and rpc- reply:
     <rpc message-id="101"
	  xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
       <rock-the-house xmlns="http://example.net/rock">
	 <zip-code>27606-0100</zip-code>
       </rock-the-house>
     </rpc>
     <rpc-reply message-id="101"
		xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
       <ok/>
     </rpc-reply>
7.14. The notification Statement
7.14.1. The notification's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | grouping     | 7.11    | 0..n        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | typedef      | 7.3     | 0..n        |
		 | uses         | 7.12    | 0..n        |
		 +--------------+---------+-------------+
7.14.2. XML Mapping Rules
7.14.3. Usage Example
   The following example defines a notification:
     module event {

	 namespace "http://example.com/event";
	 prefix "ev";

	 notification event {
	     leaf event-class {
		 type string;
	     }
	     anyxml reporting-entity;
	     leaf severity {
		 type string;
	     }
	 }
     }
   A corresponding XML instance example of the complete notification:
     <notification
       xmlns="urn:ietf:params:xml:ns:netconf:notification:1.0">
       <eventTime>2008-07-08T00:01:00Z</eventTime>
       <event xmlns="http://example.com/event">
	 <event-class>fault</event-class>
	 <reporting-entity>
	   <card>Ethernet0</card>
	 </reporting-entity>
	 <severity>major</severity>
       </event>
     </notification>
7.15. The augment Statement
7.15.1. The augment's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | anyxml       | 7.10    | 0..n        |
		 | case         | 7.9.2   | 0..n        |
		 | choice       | 7.9     | 0..n        |
		 | container    | 7.5     | 0..n        |
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | leaf         | 7.6     | 0..n        |
		 | leaf-list    | 7.7     | 0..n        |
		 | list         | 7.8     | 0..n        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | uses         | 7.12    | 0..n        |
		 | when         | 7.19.5  | 0..1        |
		 +--------------+---------+-------------+
7.15.2. XML Mapping Rules
7.15.3. Usage Example
   In namespace http://example.com/schema/interfaces, we have:
     container interfaces {
	 list ifEntry {
	     key "ifIndex";

	     leaf ifIndex {
		 type uint32;
	     }
	     leaf ifDescr {
		 type string;
	     }
	     leaf ifType {
		 type iana:IfType;
	     }
	     leaf ifMtu {
		 type int32;
	     }
	 }
     }
   Then, in namespace http://example.com/schema/ds0, we have:
     import interface-module {
	 prefix "if";
     }
     augment "/if:interfaces/if:ifEntry" {
	 when "if:ifType='ds0'";
	 leaf ds0ChannelNumber {
	     type ChannelNumber;
	 }
     }
   A corresponding XML instance example:
     <interfaces xmlns="http://example.com/schema/interfaces"
		 xmlns:ds0="http://example.com/schema/ds0">
       <ifEntry>
	 <ifIndex>1</ifIndex>
	 <ifDescr>Flintstone Inc Ethernet A562</ifDescr>
	 <ifType>ethernetCsmacd</ifType>
	 <ifMtu>1500</ifMtu>
       </ifEntry>
       <ifEntry>
	 <ifIndex>2</ifIndex>
	 <ifDescr>Flintstone Inc DS0</ifDescr>
	 <ifType>ds0</ifType>
	 <ds0:ds0ChannelNumber>1</ds0:ds0ChannelNumber>
       </ifEntry>
     </interfaces>
   As another example, suppose we have the choice defined in Section 7.9.7.  The following construct can be used to extend the protocol definition:
     augment /ex:system/ex:protocol/ex:name {
	 case c {
	     leaf smtp {
		 type empty;
	     }
	 }
     }
   A corresponding XML instance example:
     <ex:system>
       <ex:protocol>
	 <ex:tcp/>
       </ex:protocol>
     </ex:system>
   or
     <ex:system>
       <ex:protocol>
	 <other:smtp/>
       </ex:protocol>
     </ex:system>
7.16. The identity Statement
7.16.1. The identity's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | base         | 7.16.2  | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 +--------------+---------+-------------+
7.16.2. The base Statement
7.16.3. Usage Example
     module crypto-base {
	 namespace "http://example.com/crypto-base";
	 prefix "crypto";

	 identity crypto-alg {
	     description
		"Base identity from which all crypto algorithms
		 are derived.";
	 }
     }
     module des {
	 namespace "http://example.com/des";
	 prefix "des";

	 import "crypto-base" {
	     prefix "crypto";
	 }

	 identity des {
	     base "crypto:crypto-alg";
	     description "DES crypto algorithm";
	 }

	 identity des3 {
	     base "crypto:crypto-alg";
	     description "Triple DES crypto algorithm";
	 }
     }
7.17. The extension Statement
7.17.1. The extension's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | argument     | 7.17.2  | 0..1        |
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 +--------------+---------+-------------+
7.17.2. The argument Statement
7.17.2.1.  The argument's Substatements
		 +--------------+----------+-------------+
		 | substatement | section  | cardinality |
		 +--------------+----------+-------------+
		 | yin-element  | 7.17.2.2 | 0..1        |
		 +--------------+----------+-------------+
7.17.2.2.  The yin-element Statement
7.17.3. Usage Example
   To define an extension:
     module my-extensions {
       ...

       extension c-define {
	 description
	   "Takes as argument a name string.
	   Makes the code generator use the given name in the
	   #define.";
	 argument "name";
       }
     }
   To use the extension:
     module my-interfaces {
       ...
       import my-extensions {
	 prefix "myext";
       }
       ...

       container interfaces {
	 ...
	 myext:c-define "MY_INTERFACES";
       }
     }
7.18. Conformance-Related Statements
7.18.1. The feature Statement
     module syslog {
	 ...
	 feature local-storage {
	     description
		 "This feature means the device supports local
		  storage (memory, flash or disk) that can be used to
		  store syslog messages.";
	 }

	 container syslog {
	     leaf local-storage-limit {
		 if-feature local-storage;
		 type uint64;
		 units "kilobyte";
		 config false;
		 description
		     "The amount of local storage that can be
		      used to hold syslog messages.";
	     }
	 }
     }
7.18.1.1.  The feature's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | description  | 7.19.3  | 0..1        |
		 | if-feature   | 7.18.2  | 0..n        |
		 | status       | 7.19.2  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 +--------------+---------+-------------+
7.18.2. The if-feature Statement
7.18.3. The deviation Statement
7.18.3.1.  The deviation's Substatements
		 +--------------+----------+-------------+
		 | substatement | section  | cardinality |
		 +--------------+----------+-------------+
		 | description  | 7.19.3   | 0..1        |
		 | deviate      | 7.18.3.2 | 1..n        |
		 | reference    | 7.19.4   | 0..1        |
		 +--------------+----------+-------------+
7.18.3.2.  The deviate Statement
		       The deviates's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | config       | 7.19.1  | 0..1        |
		 | default      | 7.6.4   | 0..1        |
		 | mandatory    | 7.6.5   | 0..1        |
		 | max-elements | 7.7.4   | 0..1        |
		 | min-elements | 7.7.3   | 0..1        |
		 | must         | 7.5.3   | 0..n        |
		 | type         | 7.4     | 0..1        |
		 | unique       | 7.8.3   | 0..n        |
		 | units        | 7.3.3   | 0..1        |
		 +--------------+---------+-------------+
7.18.3.3.  Usage Example
   In this example, the device is informing client applications that it
   does not support the "daytime" service in the style of RFC 867.
     deviation /base:system/base:daytime {
	 deviate not-supported;
     }
   The following example sets a device-specific default value to a leaf
   that does not have a default value defined:
     deviation /base:system/base:user/base:type {
	 deviate add {
	     default "admin"; // new users are 'admin' by default
	 }
     }
   In this example, the device limits the number of name servers to 3:
     deviation /base:system/base:name-server {
	 deviate replace {
	     max-elements 3;
	 }
     }
   If the original definition is:
     container system {
	 must "daytime or time";
	 ...
     }
   a device might remove this must constraint by doing:
     deviation "/base:system" {
	 deviate delete {
	     must "daytime or time";
	 }
     }
7.19. Common Statements
7.19.1. The config Statement
7.19.2. The status Statement
   For example, the following is illegal:
     typedef my-type {
       status deprecated;
       type int32;
     }

     leaf my-leaf {
       status current;
       type my-type; // illegal, since my-type is deprecated
     }
7.19.3. The description Statement
7.19.4. The reference Statement
   For example, a typedef for a "uri" data type could look like:
     typedef uri {
       type string;
       reference
	 "RFC 3986: Uniform Resource Identifier (URI): Generic Syntax";
       ...
     }
7.19.5. The when Statement
8. Constraints
8.1. Constraints on Data
8.2. Hierarchy of Constraints
8.3. Constraint Enforcement Model
8.3.1. Payload Parsing
8.3.2. NETCONF <edit-config> Processing
8.3.3. Validation
9. Built-In Types
9.1. Canonical Representation
9.2. The Integer Built-In Types
   int8  represents integer values between -128 and 127, inclusively.
   int16  represents integer values between -32768 and 32767, inclusively.
   int32  represents integer values between -2147483648 and 2147483647, inclusively.
   int64  represents integer values between -9223372036854775808 and 9223372036854775807, inclusively.
   uint8  represents integer values between 0 and 255, inclusively.
   uint16  represents integer values between 0 and 65535, inclusively.
   uint32  represents integer values between 0 and 4294967295, inclusively.
   uint64  represents integer values between 0 and 18446744073709551615, inclusively.
9.2.1.  Lexical Representation
   Examples:
     // legal values
     +4711                       // legal positive value
     4711                        // legal positive value
     -123                        // legal negative value
     0xf00f                      // legal positive hexadecimal value
     -0xf                        // legal negative hexadecimal value
     052                         // legal positive octal value
     // illegal values
     - 1                         // illegal intermediate space
9.2.1. Lexical Representation
9.2.2. Canonical Form
9.2.3. Restrictions
9.2.4. The range Statement
9.2.4.1.  The range's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | description   | 7.19.3  | 0..1        |
		 | error-app-tag | 7.5.4.2 | 0..1        |
		 | error-message | 7.5.4.1 | 0..1        |
		 | reference     | 7.19.4  | 0..1        |
		 +---------------+---------+-------------+
9.2.5. Usage Example
     typedef my-base-int32-type {
	 type int32 {
	     range "1..4 | 10..20";
	 }
     }
     typedef my-type1 {
	 type my-base-int32-type {
	     // legal range restriction
	     range "11..max"; // 11..20
	 }
     }
     typedef my-type2 {
	 type my-base-int32-type {
	     // illegal range restriction
	     range "11..100";
	 }
     }
9.3. The decimal64 Built-In Type
9.3.1. Lexical Representation
9.3.2. Canonical Form
9.3.3. Restrictions
9.3.4. The fraction-digits Statement
     +----------------+-----------------------+----------------------+
     | fraction-digit | min                   | max                  |
     +----------------+-----------------------+----------------------+
     | 1              | -922337203685477580.8 | 922337203685477580.7 |
     | 2              | -92233720368547758.08 | 92233720368547758.07 |
     | 3              | -9223372036854775.808 | 9223372036854775.807 |
     | 4              | -922337203685477.5808 | 922337203685477.5807 |
     | 5              | -92233720368547.75808 | 92233720368547.75807 |
     | 6              | -9223372036854.775808 | 9223372036854.775807 |
     | 7              | -922337203685.4775808 | 922337203685.4775807 |
     | 8              | -92233720368.54775808 | 92233720368.54775807 |
     | 9              | -9223372036.854775808 | 9223372036.854775807 |
     | 10             | -922337203.6854775808 | 922337203.6854775807 |
     | 11             | -92233720.36854775808 | 92233720.36854775807 |
     | 12             | -9223372.036854775808 | 9223372.036854775807 |
     | 13             | -922337.2036854775808 | 922337.2036854775807 |
     | 14             | -92233.72036854775808 | 92233.72036854775807 |
     | 15             | -9223.372036854775808 | 9223.372036854775807 |
     | 16             | -922.3372036854775808 | 922.3372036854775807 |
     | 17             | -92.23372036854775808 | 92.23372036854775807 |
     | 18             | -9.223372036854775808 | 9.223372036854775807 |
     +----------------+-----------------------+----------------------+
9.3.5. Usage Example
     typedef my-decimal {
	 type decimal64 {
	     fraction-digits 2;
	     range "1 .. 3.14 | 10 | 20..max";
	 }
     }
9.4. The string Built-In Type
9.4.1. Lexical Representation
9.4.2. Canonical Form
9.4.3. Restrictions
9.4.4. The length Statement
9.4.4.1.  The length's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | description   | 7.19.3  | 0..1        |
		 | error-app-tag | 7.5.4.2 | 0..1        |
		 | error-message | 7.5.4.1 | 0..1        |
		 | reference     | 7.19.4  | 0..1        |
		 +---------------+---------+-------------+
9.4.5. Usage Example
     typedef my-base-str-type {
	 type string {
	     length "1..255";
	 }
     }

     type my-base-str-type {
	 // legal length refinement
	 length "11 | 42..max"; // 11 | 42..255
     }

     type my-base-str-type {
	 // illegal length refinement
	 length "1..999";
     }
9.4.6. The pattern Statement
9.4.6.1.  The pattern's Substatements
		 +---------------+---------+-------------+
		 | substatement  | section | cardinality |
		 +---------------+---------+-------------+
		 | description   | 7.19.3  | 0..1        |
		 | error-app-tag | 7.5.4.2 | 0..1        |
		 | error-message | 7.5.4.1 | 0..1        |
		 | reference     | 7.19.4  | 0..1        |
		 +---------------+---------+-------------+
9.4.7. Usage Example
   With the following type:
     type string {
	 length "0..4";
	 pattern "[0-9a-fA-F]*";
     }
   the following strings match:
     AB          // legal
     9A00        // legal
   and the following strings do not match:
     00ABAB      // illegal, too long
     xx00        // illegal, bad characters
9.5. The boolean Built-In Type
9.5.1. Lexical Representation
9.5.2. Canonical Form
9.5.3. Restrictions
9.6. The enumeration Built-In Type
9.6.1. Lexical Representation
9.6.2. Canonical Form
9.6.3. Restrictions
9.6.4. The enum Statement
9.6.4.1.  The enum's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | value        | 9.6.4.2 | 0..1        |
		 +--------------+---------+-------------+
9.6.4.2.  The value Statement
9.6.5. Usage Example
     leaf myenum {
	 type enumeration {
	     enum zero;
	     enum one;
	     enum seven {
		 value 7;
	     }
	 }
     }
   The lexical representation of the leaf "myenum" with value "seven" is:
     <myenum>seven</myenum>
9.7. The bits Built-In Type
9.7.1. Restrictions
9.7.2. Lexical Representation
9.7.3. Canonical Form
9.7.4. The bit Statement
9.7.4.1.  The bit's Substatements
		 +--------------+---------+-------------+
		 | substatement | section | cardinality |
		 +--------------+---------+-------------+
		 | description  | 7.19.3  | 0..1        |
		 | reference    | 7.19.4  | 0..1        |
		 | status       | 7.19.2  | 0..1        |
		 | position     | 9.7.4.2 | 0..1        |
		 +--------------+---------+-------------+
9.7.4.2.  The position Statement
9.7.5. Usage Example
   Given the following leaf:
     leaf mybits {
	 type bits {
	     bit disable-nagle {
		 position 0;
	     }
	     bit auto-sense-speed {
		 position 1;
	     }
	     bit 10-Mb-only {
		 position 2;
	     }
	 }
	 default "auto-sense-speed";
     }
   The lexical representation of this leaf with bit values disable-nagle and 10-Mb-only set would be:
     <mybits>disable-nagle 10-Mb-only</mybits>
9.8. The binary Built-In Type
9.8.1. Restrictions
9.8.2. Lexical Representation
9.8.3. Canonical Form
9.9. The leafref Built-In Type
9.9.1. Restrictions
9.9.2. The path Statement
9.9.3. Lexical Representation
9.9.4. Canonical Form
9.9.5. Usage Example
   With the following list:
     list interface {
	 key "name";
	 leaf name {
	     type string;
	 }
	 leaf admin-status {
	     type admin-status;
	 }
	 list address {
	     key "ip";
	     leaf ip {
		 type yang:ip-address;
	     }
	 }
     }
   The following leafref refers to an existing interface:
     leaf mgmt-interface {
	 type leafref {
	     path "../interface/name";
	 }
     }
   An example of a corresponding XML snippet:
     <interface>
       <name>eth0</name>
     </interface>
     <interface>
       <name>lo</name>
     </interface>
     <mgmt-interface>eth0</mgmt-interface>
   The following leafrefs refer to an existing address of an interface:
     container default-address {
	 leaf ifname {
	     type leafref {
		 path "../../interface/name";
	     }
	 }
	 leaf address {
	     type leafref {
		 path "../../interface[name = current()/../ifname]"
		    + "/address/ip";
	     }
	 }
     }
   An example of a corresponding XML snippet:
     <interface>
       <name>eth0</name>
       <admin-status>up</admin-status>
       <address>
	 <ip>192.0.2.1</ip>
       </address>
       <address>
	 <ip>192.0.2.2</ip>
       </address>
     </interface>
     <interface>
       <name>lo</name>
       <admin-status>up</admin-status>
       <address>
	 <ip>127.0.0.1</ip>
       </address>
     </interface>

     <default-address>
       <ifname>eth0</ifname>
       <address>192.0.2.2</address>
     </default-address>
   The following list uses a leafref for one of its keys.  This is similar to a foreign key in a relational database.
     list packet-filter {
	 key "if-name filter-id";
	 leaf if-name {
	     type leafref {
		 path "/interface/name";
	     }
	 }
	 leaf filter-id {
	     type uint32;
	 }
	 ...
     }
   An example of a corresponding XML snippet:
     <interface>
       <name>eth0</name>
       <admin-status>up</admin-status>
       <address>
	 <ip>192.0.2.1</ip>
       </address>
       <address>
	 <ip>192.0.2.2</ip>
       </address>
     </interface>

     <packet-filter>
       <if-name>eth0</if-name>
       <filter-id>1</filter-id>
       ...
     </packet-filter>
     <packet-filter>
       <if-name>eth0</if-name>
       <filter-id>2</filter-id>
       ...
     </packet-filter>
   The following notification defines two leafrefs to refer to an existing admin-status:
     notification link-failure {
	 leaf if-name {
	     type leafref {
		 path "/interface/name";
	     }
	 }
	 leaf admin-status {
	     type leafref {
		 path
		   "/interface[name = current()/../if-name]"
		 + "/admin-status";
	     }
	 }
     }
   An example of a corresponding XML notification:
     <notification
       xmlns="urn:ietf:params:xml:ns:netconf:notification:1.0">
       <eventTime>2008-04-01T00:01:00Z</eventTime>
       <link-failure xmlns="http://acme.example.com/system">
	 <if-name>eth0</if-name>
	 <admin-status>up</admin-status>
       </link-failure>
     </notification>
9.10. The identityref Built-In Type
9.10.1. Restrictions
9.10.2. The identityref's base Statement
9.10.3. Lexical Representation
9.10.4. Canonical Form
9.10.5. Usage Example
   With the identity definitions in Section 7.16.3 and the following module:
     module my-crypto {

	 namespace "http://example.com/my-crypto";
	 prefix mc;

	 import "crypto-base" {
	     prefix "crypto";
	 }

	 identity aes {
	     base "crypto:crypto-alg";
	 }

	 leaf crypto {
	     type identityref {
		 base "crypto:crypto-alg";
	     }
	 }
     }
   the leaf "crypto" will be encoded as follows, if the value is the "des3" identity defined in the "des" module:
     <crypto xmlns:des="http://example.com/des">des:des3</crypto>
   Any prefixes used in the encoding are local to each instance
   encoding.  This means that the same identityref may be encoded
   differently by different implementations.  For example, the following
   example encodes the same leaf as above:
     <crypto xmlns:x="http://example.com/des">x:des3</crypto>
   If the "crypto" leaf's value instead is "aes" defined in the "my-crypto" module, it can be encoded as:
     <crypto xmlns:mc="http://example.com/my-crypto">mc:aes</crypto>
   or, using the default namespace:
     <crypto>aes</crypto>
9.11. The empty Built-In Type
9.11.1. Restrictions
9.11.2. Lexical Representation
9.11.3. Canonical Form
9.11.4. Usage Example
   The following leaf
     leaf enable-qos {
	 type empty;
     }
   will be encoded as
     <enable-qos/>
   if it exists.
9.12. The union Built-In Type
   Example:
     type union {
	 type int32;
	 type enumeration {
	     enum "unbounded";
	 }
     }
9.12.1. Restrictions
9.12.2. Lexical Representation
9.12.3. Canonical Form
9.13. The instance-identifier Built-In Type
9.13.1. Restrictions
9.13.2. The require-instance Statement
9.13.3. Lexical Representation
9.13.4. Canonical Form
9.13.5. Usage Example
   The following are examples of instance identifiers:
     /* instance-identifier for a container */
     /ex:system/ex:services/ex:ssh

     /* instance-identifier for a leaf */
     /ex:system/ex:services/ex:ssh/ex:port

     /* instance-identifier for a list entry */
     /ex:system/ex:user[ex:name='fred']

     /* instance-identifier for a leaf in a list entry */
     /ex:system/ex:user[ex:name='fred']/ex:type

     /* instance-identifier for a list entry with two keys */
     /ex:system/ex:server[ex:ip='192.0.2.1'][ex:port='80']

     /* instance-identifier for a leaf-list entry */
     /ex:system/ex:services/ex:ssh/ex:cipher[.='blowfish-cbc']

     /* instance-identifier for a list entry without keys */
     /ex:stats/ex:port[3]
10. Updating a Module
11. YIN
11.1. Formal YIN Definition
11.1.1. Usage Example
   The following YANG module:

     module acme-foo {
	 namespace "http://acme.example.com/foo";
	 prefix "acfoo";

	 import my-extensions {
	     prefix "myext";
	 }

	 list interface {
	     key "name";
	     leaf name {
		 type string;
	     }

	     leaf mtu {
		 type uint32;
		 description "The MTU of the interface.";
		 myext:c-define "MY_MTU";
	     }
	 }
     }
   where the extension "c-define" is defined in Section 7.17.3, is translated into the following YIN:
     <module name="acme-foo"
	     xmlns="urn:ietf:params:xml:ns:yang:yin:1"
	     xmlns:acfoo="http://acme.example.com/foo"
	     xmlns:myext="http://example.com/my-extensions">

       <namespace uri="http://acme.example.com/foo"/>
       <prefix value="acfoo"/>

       <import module="my-extensions">
	 <prefix value="myext"/>
       </import>

       <list name="interface">
	 <key value="name"/>
	 <leaf name="name">
	   <type name="string"/>
	 </leaf>
	 <leaf name="mtu">
	   <type name="uint32"/>
	   <description>
	     <text>The MTU of the interface.</text>
	   </description>
	   <myext:c-define name="MY_MTU"/>
	 </leaf>
       </list>
     </module>
12. YANG ABNF Grammar
13. Error Responses for YANG Related Errors
13.1. Error Message for Data That Violates a unique Statement
13.2. Error Message for Data That Violates a max-elements Statement
13.3. Error Message for Data That Violates a min-elements Statement
13.4. Error Message for Data That Violates a must Statement
13.5. Error Message for Data That Violates a require-instance Statement
13.6. Error Message for Data That Does Not Match a leafref Type
13.7. Error Message for Data That Violates a mandatory choice Statement
13.8. Error Message for the "insert" Operation
14. IANA Considerations
14.1. Media type application/yang
14.2. Media type application/yin+xml
15. Security Considerations
16. Contributors
17. Acknowledgements
18. References
18.1. Normative References
18.2. Informative References
EOB
