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

				# TODO
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

				# TODO
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
			end
		end
	end
end
