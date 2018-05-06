# coding: utf-8
# vim: et ts=2 sw=2

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
    'http://rubyang/0.1'
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

          context '1 anyxml' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  anyxml anyxml1;
                }
              EOB
            }
            let!( :anyxml1_element ){ root_xml.add_element( 'anyxml1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :anyxml1_child_element ){ anyxml1_element.add_element( 'child' ).add_namespace( 'http://module1.rspec/anyxml1' ) }
            let!( :anyxml1_child_text ){ anyxml1_child_element.add_text( 'anyxml1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              anyxml1 = config.edit( 'anyxml1' )
              anyxml1.set( anyxml1_element.to_s )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 anyxmls' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  anyxml anyxml1;
                  anyxml anyxml2;
                }
              EOB
            }
            let!( :anyxml1_element ){ root_xml.add_element( 'anyxml1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :anyxml1_child_element ){ anyxml1_element.add_element( 'child' ).add_namespace( 'http://module1.rspec/anyxml1' ) }
            let!( :anyxml1_child_text ){ anyxml1_child_element.add_text( 'anyxml1' ) }
            let!( :anyxml2_element ){ root_xml.add_element( 'anyxml2' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :anyxml2_child_element ){ anyxml2_element.add_element( 'child' ).add_namespace( 'http://module1.rspec/anyxml2' ) }
            let!( :anyxml2_child_text ){ anyxml2_child_element.add_text( 'anyxml2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              anyxml1 = config.edit( 'anyxml1' )
              anyxml1.set( anyxml1_element.to_s )
              anyxml2 = config.edit( 'anyxml2' )
              anyxml2.set( anyxml2_element.to_s )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
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

          context '1 extension' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  extension extension1;
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

          context '2 extensions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  extension extension1;
                  extension extension2;
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

          context '1 identity' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  identity identity1;
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

          context '2 identitys' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  identity identity1;
                  identity identity2 {
                    base identity1;
                  }
                  leaf leaf1 {
                    type identityref {
                      base identity1;
                    }
                  }
                }
              EOB
            }
            let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'identity2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf1 = config.edit 'leaf1'
              leaf1.set 'identity2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  reference reference1;
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  reference reference1;
                  reference reference2;
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
        <<-EOB
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
        EOB
      end # describe '7.2.3. Usage Example'
    end # describe '7.2. The submodule Statement'

    # TODO
    describe '7.3. The typedef Statement' do

      describe 'The "typedef" statement\'s argument is an identifier that is the name of the type to be defined, and MUST be followed by a block of substatements that holds detailed typedef information.' do
      end # The "typedef" statement\'s argument is an identifier that is the name of the type to be defined, and MUST be followed by a block of substatements that holds detailed typedef information.

      describe 'The name of the type MUST NOT be one of the YANG built-in types.  If the typedef is defined at the top level of a YANG module or submodule, the name of the type to be defined MUST be unique within the module.' do
      end # The name of the type MUST NOT be one of the YANG built-in types.  If the typedef is defined at the top level of a YANG module or submodule, the name of the type to be defined MUST be unique within the module.

      # TODO
      describe '7.3.1. The typedef\'s Substatements' do
      end # describe '7.3.1. The typedef\'s Substatements'

      describe 'default' do
        '0..1'

        context '0 default' do
        end

        context '1 default' do
        end

        context '2 defaults' do
        end

      end # describe 'default'

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # describe 'description'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # describe 'reference'

      describe 'status' do
        '0..1'

        context '0 status' do
        end

        context '1 status' do
        end

        context '2 statuss' do
        end

      end # describe 'status'

      describe 'type' do
        '1'
      end # describe 'type'

      describe 'units' do
        '0..1'

        context '0 units' do
        end

        context '1 units' do
        end

        context '2 unitss' do
        end

      end # describe 'units'

      # TODO
      describe '7.3.2. The typedef\'s type Statement' do

        describe 'The "type" statement, which MUST be present, defines the base type from which this type is derived.' do
        end # The "type" statement, which MUST be present, defines the base type from which this type is derived.
      end # describe '7.3.2. The typedef\'s type Statement'


      # TODO
      describe '7.3.3. The units Statement' do

        describe 'The "units" statement, which is optional, takes as an argument a string that contains a textual definition of the units associated with the type.' do
        end # The "units" statement, which is optional, takes as an argument a string that contains a textual definition of the units associated with the type.
      end # describe '7.3.3. The units Statement'


      # TODO
      describe '7.3.4. The typedef\'s default Statement' do

        describe 'The value of the "default" statement MUST be valid according to the type specified in the "type" statement.' do
        end # The value of the "default" statement MUST be valid according to the type specified in the "type" statement.

        describe 'If the base type has a default value, and the new derived type does not specify a new default value, the base type\'s default value is also the default value of the new derived type.' do
        end # If the base type has a default value, and the new derived type does not specify a new default value, the base type\'s default value is also the default value of the new derived type.

        describe 'If the type\'s default value is not valid according to the new restrictions specified in a derived type or leaf definition, the derived type or leaf definition MUST specify a new default value compatible with the restrictions.' do
        end # If the type\'s default value is not valid according to the new restrictions specified in a derived type or leaf definition, the derived type or leaf definition MUST specify a new default value compatible with the restrictions.

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

          context '0 bit' do
          end

          context '1 bit' do
          end

          context '2 bits' do
          end

        end # describe 'bit'

        describe 'enum' do
          '0..n'

          context '0 enum' do
          end

          context '1 enum' do
          end

          context '2 enums' do
          end

        end # describe 'enum'

        describe 'length' do
          '0..1'

          context '0 length' do
          end

          context '1 length' do
          end

          context '2 lengths' do
          end

        end # describe 'length'

        describe 'path' do
          '0..1'

          context '0 path' do
          end

          context '1 path' do
          end

          context '2 paths' do
          end

        end # describe 'path'

        describe 'pattern' do
          '0..n'

          context '0 pattern' do
          end

          context '1 pattern' do
          end

          context '2 patterns' do
          end

        end # describe 'pattern'

        describe 'range' do
          '0..1'

          context '0 range' do
          end

          context '1 range' do
          end

          context '2 ranges' do
          end

        end # describe 'range'

        describe 'require' do
          '0..1'

          context '0 require' do
          end

          context '1 require' do
          end

          context '2 requires' do
          end

        end # describe 'require'

        describe 'type' do
          '0..n'

          context '0 type' do
          end

          context '1 type' do
          end

          context '2 types' do
          end

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

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do

          context '0 choice' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 choice' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    choice choice1 {
                      case case1 {
                        leaf leaf1 { type string; }
                      }
                    }
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
              leaf1 = container1.edit( 'leaf1' )
              leaf1.set( 'leaf1' )
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
                  container container1 {
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
              leaf1 = container1.edit( 'leaf1' )
              leaf1.set( 'leaf1' )
              leaf2 = container1.edit( 'leaf2' )
              leaf2.set( 'leaf2' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'choice'

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'container' do
          '0..n'

          context '0 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    container container2 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :container2_element ){ container1_element.add_element( 'container2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              container2 = container1.edit( 'container2' )
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
                  container container1 {
                    container container2 {
                    }
                    container container3 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :container2_element ){ container1_element.add_element( 'container2' ) }
            let!( :container3_element ){ container1_element.add_element( 'container3' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              container2 = container1.edit( 'container2' )
              container3 = container1.edit( 'container3' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'container'

        describe 'description' do
          '0..1'

          context '0 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    description description1;
                  }
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    description description1;
                    description description2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'description'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 grouping' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    grouping grouping1 {
                      leaf leaf1 { type string; }
                    }
                  }
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

          context '2 groupings' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    grouping grouping1 {
                      leaf leaf1 { type string; }
                    }
                    grouping grouping2 {
                      leaf leaf2 { type string; }
                    }
                  }
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

        end # describe 'grouping'

        describe 'if-feature' do
          '0..n'

          context '0 if' do
          end

          context '1 if' do
          end

          context '2 ifs' do
          end

        end # describe 'if-feature'

        describe 'leaf' do
          context '0 leaf' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 leaf' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
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

          context '2 leafs' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    leaf leaf1 { type string; }
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

        end # describe 'leaf'

        describe 'leaf-list' do
          context '0 leaf-list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 leaf-list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    leaf-list leaf-list1 { type string; }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_element ){ container1_element.add_element( 'leaf-list1' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              leaf_list1 = container1.edit 'leaf-list1'
              leaf_list1.set 'leaf-list1'
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
                  container container1 {
                    leaf-list leaf-list1 { type string; }
                    leaf-list leaf-list2 { type string; }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_element ){ container1_element.add_element( 'leaf-list1' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            let!( :leaf_list2_element ){ container1_element.add_element( 'leaf-list2' ) }
            let!( :leaf_list2_text ){ leaf_list2_element.add_text( 'leaf-list2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              leaf_list1 = container1.edit 'leaf-list1'
              leaf_list1.set 'leaf-list1'
              leaf_list2 = container1.edit 'leaf-list2'
              leaf_list2.set 'leaf-list2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'leaf-list'

        describe 'list' do

          context '0 list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    list list1 {
                      key leaf1;
                      leaf leaf1 { type string; }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :list1_element ){ container1_element.add_element( 'list1' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
              list1 = container1.edit( 'list1' )
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
                  container container1 {
                    list list1 {
                      key leaf1;
                      leaf leaf1 { type string; }
                    }
                    list list2 {
                      key leaf2;
                      leaf leaf2 { type string; }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :list1_element ){ container1_element.add_element( 'list1' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :list2_element ){ container1_element.add_element( 'list2' ) }
            let!( :leaf2_element ){ list2_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
              list1 = container1.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              list2 = container1.edit( 'list2' )
              list2_element2 = list2.edit 'leaf2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'list'

        describe 'must' do

          context '0 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1';
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 musts' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1';
                    must '2';
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'must'

        describe 'presence' do
          '0..1'

          context '0 presence' do
          end

          context '1 presence' do
          end

          context '2 presences' do
          end

        end # describe 'presence'

        describe 'reference' do

          context '0 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    reference reference1;
                  }
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    reference reference1;
                    reference reference2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 typedef' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    typedef typedef1 { type string; }
                  }
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

          context '2 typedefs' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    typedef typedef1 { type string; }
                    typedef typedef2 { type string; }
                  }
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

        end # describe 'typedef'

        describe 'uses' do

          context '0 uses' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
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

          context '1 uses' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  grouping grouping1 {
                    leaf leaf1 { type string; }
                  }
                  container container1 {
                    uses grouping1;
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
              container1 = config.edit( 'container1' )
              leaf1 = container1.edit( 'leaf1' )
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
                  container container1 {
                    uses grouping1;
                    uses grouping2;
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
              container1 = config.edit( 'container1' )
              leaf1 = container1.edit( 'leaf1' )
              leaf1.set 'leaf1'
              leaf2 = container1.edit( 'leaf2' )
              leaf2.set 'leaf2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'uses'

        describe 'when' do

          context '0 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              config.edit 'container1'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              config.edit 'container1'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    when "'true' = 'true'";
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'when'

      end # describe '7.5.2. The container\'s Substatements'

      # TODO
      describe '7.5.3. The must Statement' do
        describe 'The "must" statement, which is optional, takes as an argument a string that contains an XPath expression' do
        end # The "must" statement, which is optional, takes as an argument a string that contains an XPath expression

        describe 'When a datastore is validated, all "must" constraints are conceptually evaluated once for each data node in the data tree, and for all leafs with default values in use' do
        end # When a datastore is validated, all "must" constraints are conceptually evaluated once for each data node in the data tree, and for all leafs with default values in use

        describe 'If a data node does not exist in the data tree, and it does not have a default value, its "must" statements are not evaluated.' do
        end # If a data node does not exist in the data tree, and it does not have a default value, its "must" statements are not evaluated.

        describe 'All such constraints MUST evaluate to true for the data to be valid.' do
        end # All such constraints MUST evaluate to true for the data to be valid.

        describe 'The context node is the node in the data tree for which the "must" statement is defined.' do
        end # The context node is the node in the data tree for which the "must" statement is defined.

        describe 'The accessible tree is made up of all nodes in the data tree, and all leafs with default values in use' do
        end # The accessible tree is made up of all nodes in the data tree, and all leafs with default values in use

        describe 'If the context node represents configuration, the tree is the data in the NETCONF datastore where the context node exists.  The XPath root node has all top-level configuration data nodes in all modules as children' do
        end # If the context node represents configuration, the tree is the data in the NETCONF datastore where the context node exists.  The XPath root node has all top-level configuration data nodes in all modules as children

        describe 'If the context node represents state data, the tree is all state data on the device, and the <running/> datastore.  The XPath root node has all top-level data nodes in all modules as children' do
        end # If the context node represents state data, the tree is all state data on the device, and the <running/> datastore.  The XPath root node has all top-level data nodes in all modules as children

        describe 'If the context node represents notification content, the tree is the notification XML instance document.  The XPath root node has the element representing the notification being defined as the only child' do
        end # If the context node represents notification content, the tree is the notification XML instance document.  The XPath root node has the element representing the notification being defined as the only child

        describe 'If the context node represents RPC input parameters, the tree is the RPC XML instance document.  The XPath root node has the element representing the RPC operation being defined as the only child' do
        end # If the context node represents RPC input parameters, the tree is the RPC XML instance document.  The XPath root node has the element representing the RPC operation being defined as the only child

        describe 'If the context node represents RPC output parameters, the tree is the RPC reply instance document.  The XPath root node has the elements representing the RPC output parameters as children' do
        end # If the context node represents RPC output parameters, the tree is the RPC reply instance document.  The XPath root node has the elements representing the RPC output parameters as children

        describe 'The result of the XPath expression is converted to a boolean value using the standard XPath rules' do
        end # The result of the XPath expression is converted to a boolean value using the standard XPath rules
      end # describe '7.5.3. The must Statement'

      # TODO
      describe '7.5.4. The must\'s Substatements' do

        describe 'description' do

          context '0 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
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
                  container container1 {
                    must '1' {
                      description description1;
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
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
                  container container1 {
                    must '1' {
                      description description1;
                      description description2;
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

        end # describe 'description'

        describe 'error-app-tag' do

          context '0 error-app-tag' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 error-app-tag' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                      error-app-tag error-app-tag1;
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 error-app-tags' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                      error-app-tag error-app-tag1;
                      error-app-tag error-app-tag2;
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

        end # describe 'error-app-tag'

        describe 'error-message' do
          '0..1'

          context '0 error-message' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 error-message' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                      error-message error-message1;
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 error-messages' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                      error-message error-message1;
                      error-message error-message2;
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

        end # describe 'error-message'

        describe 'reference' do
          '0..1'

          context '0 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  container container1 {
                    must '1' {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit 'container1'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'reference'
      end # describe '7.5.4. The must\'s Substatements'


      # TODO
      describe '7.5.4.1. The error-message Statement' do

        describe 'The "error-message" statement, which is optional, takes a string as an argument.  If the constraint evaluates to false, the string is passed as <error-message> in the <rpc-error>' do
        end # The "error-message" statement, which is optional, takes a string as an argument.  If the constraint evaluates to false, the string is passed as <error-message> in the <rpc-error>
      end # describe '7.5.4.1. The error-message Statement'

      # TODO
      describe '7.5.4.2. The error-app-tag Statement' do

        describe 'The "error-app-tag" statement, which is optional, takes a string as an argument.  If the constraint evaluates to false, the string is passed as <error-app-tag> in the <rpc-error>' do
        end # The "error-app-tag" statement, which is optional, takes a string as an argument.  If the constraint evaluates to false, the string is passed as <error-app-tag> in the <rpc-error>

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

        describe 'If a container has the "presence" statement, the container\'s existence in the data tree carries some meaning.  Otherwise, the container is used to give some structure to the data, and it carries no meaning by itself' do
        end # If a container has the "presence" statement, the container\'s existence in the data tree carries some meaning.  Otherwise, the container is used to give some structure to the data, and it carries no meaning by itself

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

        describe 'If no such ancestor exists in the schema tree, the default value MUST be used.' do
        end # describe 'If no such ancestor exists in the schema tree, the default value MUST be used.'

        describe 'Otherwise, if this ancestor is a case node, the default value MUST be used if any node from the case exists in the data tree, or if the case node is the choice’s default case, and no nodes from any other case exist in the data tree' do
        end # describe 'Otherwise, if this ancestor is a case node, the default value MUST be used if any node from the case exists in the data tree, or if the case node is the choice’s default case, and no nodes from any other case exist in the data tree'

        describe 'Otherwise, the default value MUST be used if the ancestor node exists in the data tree' do
        end # describe 'Otherwise, the default value MUST be used if the ancestor node exists in the data tree'

        describe 'If a leaf has a "default" statement, the leaf’s default value is the value of the "default" statement.  Otherwise, if the leaf’s type has a default value, and the leaf is not mandatory, then the leaf’s default value is the type’s default value' do
        end # describe 'If a leaf has a "default" statement, the leaf’s default value is the value of the "default" statement.  Otherwise, if the leaf’s type has a default value, and the leaf is not mandatory, then the leaf’s default value is the type’s default value'

      end # describe '7.6.1. The leaf\'s default value'

      # TODO
      describe '7.6.2. The leaf\'s Substatements' do

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'default' do
          '0..1'

          context '0 default' do
          end

          context '1 default' do
          end

          context '2 defaults' do
          end

        end # describe 'default'

        describe 'description' do
          '0..1'

          context '0 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                  }
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    description description1;
                  }
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    description description1;
                    description description2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'mandatory' do
          '0..1'

          context '0 mandatory' do
          end

          context '1 mandatory' do
          end

          context '2 mandatorys' do
          end

        end # describe 'mandatory'

        describe 'must' do
          '0..n'

          context '0 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    must 1;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 musts' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    must 1;
                    must 2;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'must'

        describe 'reference' do
          '0..1'

          context '0 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                  }
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    reference reference1;
                  }
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    reference reference1;
                    reference reference2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'type' do

          context '0 type' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

          context '1 type' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                  }
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

          context '2 types' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    type string;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'type'

        describe 'units' do
          '0..1'

          context '0 units' do
          end

          context '1 units' do
          end

          context '2 unitss' do
          end

        end # describe 'units'

        describe 'when' do

          context '0 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                  }
                }
              EOB
            }
            let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf1 = config.edit 'leaf1'
              leaf1.set( 'leaf1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf1 = config.edit 'leaf1'
              leaf1.set( 'leaf1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf leaf1 {
                    type string;
                    when "'true' = 'true'";
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'when'

      end # describe '7.6.2. The leaf\'s Substatements'

      # TODO
      describe '7.6.3. The leaf\'s type Statement' do

        describe 'The "type" statement, which MUST be present, takes as an argument the name of an existing built-in or derived type' do
        end # describe 'The "type" statement, which MUST be present, takes as an argument the name of an existing built-in or derived type'

      end # describe '7.6.3. The leaf\'s type Statement'

      # TODO
      describe '7.6.4. The leaf\'s default Statement' do

        describe 'The value of the "default" statement MUST be valid according to the type specified in the leaf’s "type" statement' do
        end # describe 'The value of the "default" statement MUST be valid according to the type specified in the leaf’s "type" statement'

        describe 'The "default" statement MUST NOT be present on nodes where "mandatory" is true' do
        end # describe 'The "default" statement MUST NOT be present on nodes where "mandatory" is true'

      end # describe '7.6.4. The leaf\'s default Statement'

      # TODO
      describe '7.6.5. The leaf\'s mandatory Statement' do

        describe 'The "mandatory" statement, which is optional, takes as an argument the string "true" or "false"' do
        end # describe 'The "mandatory" statement, which is optional, takes as an argument the string "true" or "false"'

        describe 'If not specified, the default is "false"' do
        end # describe 'If not specified, the default is "false"'

        describe 'If "mandatory" is "true", the behavior of the constraint depends on the type of the leaf’s closest ancestor node in the schema tree that is not a non-presence container' do
        end # describe 'If "mandatory" is "true", the behavior of the constraint depends on the type of the leaf’s closest ancestor node in the schema tree that is not a non-presence container'

        describe 'If no such ancestor exists in the schema tree, the leaf MUST exist' do
        end # describe 'If no such ancestor exists in the schema tree, the leaf MUST exist'

        describe 'Otherwise, if this ancestor is a case node, the leaf MUST exist if any node from the case exists in the data tree' do
        end # describe 'Otherwise, if this ancestor is a case node, the leaf MUST exist if any node from the case exists in the data tree'

        describe 'Otherwise, the leaf MUST exist if the ancestor node exists in the data tree' do
        end # describe 'Otherwise, the leaf MUST exist if the ancestor node exists in the data tree'

        describe '' do
        end # describe ''

      end # describe '7.6.5. The leaf\'s mandatory Statement'

      # TODO
      describe '7.6.6. XML Mapping Rules' do
      end # describe '7.6.6. XML Mapping Rules'

      # TODO
      describe '7.6.7. NETCONF <edit-config> Operations' do
      end # describe '7.6.7. NETCONF <edit-config> Operations'

      # TODO
      describe '7.6.8. Usage Example' do

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
      end # describe '7.6.8. Usage Example'

    end # describe '7.6. The leaf Statement'

    # TODO
    describe '7.7. The leaf-list Statement' do

      describe 'The values in a leaf-list MUST be unique' do
      end # describe 'The values in a leaf-list MUST be unique'

      describe 'If the type referenced by the leaf-list has a default value, it has no effect in the leaf-list' do
      end # describe 'If the type referenced by the leaf-list has a default value, it has no effect in the leaf-list'

      # TODO
      describe '7.7.1. Ordering' do
      end # describe '7.7.1. Ordering'

      # TODO
      describe '7.7.2. The leaf-list\'s Substatements' do

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'description' do

          context '0 description' do
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    description description1;
                  }
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    description description1;
                    description description2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if' do
          end

          context '1 if' do
          end

          context '2 ifs' do
          end

        end # describe 'if-feature'

        describe 'max-elements' do

          context '0 max-elements' do
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
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1' )
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 max-elements' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 1;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 max-elementss' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 1;
                    max-elements 1;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'max-elements'

        describe 'min-elements' do

          context '0 min-elements' do
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
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1' )
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 min-elements' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 0;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 min-elementss' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 0;
                    min-elements 0;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'min-elements'

        describe 'must' do

          context '0 must' do
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
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1' )
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    must 1;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 musts' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    must 1;
                    must 2;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'must'

        describe 'ordered' do
          '0..1'

          context '0 ordered' do
          end

          context '1 ordered' do
          end

          context '2 ordereds' do
          end

        end # describe 'ordered'

        describe 'reference' do

          context '0 reference' do
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    reference reference1;
                  }
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    reference reference1;
                    reference reference2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'type' do

          context '0 type' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

          context '1 type' do
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

          context '2 types' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    type string;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end
        end # describe 'type'

        describe 'units' do
          '0..1'

          context '0 units' do
          end

          context '1 units' do
          end

          context '2 unitss' do
          end

        end # describe 'units'

        describe 'when' do

          context '0 when' do
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
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit 'leaf-list1'
              leaf_list1.set( 'leaf-list1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit 'leaf-list1'
              leaf_list1.set( 'leaf-list1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    when "'true' = 'true'";
                    when "'true' = 'true'";
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'when'

      end # describe '7.7.2. The leaf-list\'s Substatements'

      # TODO
      describe '7.7.3. The min-elements Statement' do

        describe 'The "min-elements" statement, which is optional, takes as an argument a non-negative integer that puts a constraint on valid list entries' do
        end # describe 'The "min-elements" statement, which is optional, takes as an argument a non-negative integer that puts a constraint on valid list entries'

        describe 'A valid leaf-list or list MUST have at least min-elements entries' do

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 0;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 1;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 2;
                  }
                }
              EOB
            }
            let!( :leaf_list1_element_1 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text_1 ){ leaf_list1_element_1.add_text( 'leaf-list1_1' ) }
            let!( :leaf_list1_element_2 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text_2 ){ leaf_list1_element_2.add_text( 'leaf-list1_2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1_1' )
              leaf_list1.set( 'leaf-list1_2' )
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'invalid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    min-elements 2;
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1' )
              raise unless config.valid?
            } }
            it { is_expected.to raise_exception Exception }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 0;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 1;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 2;
                  }
                }
              EOB
            }
            let!( :list1_element_1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element_1 ){ list1_element_1.add_element( 'leaf1' ) }
            let!( :leaf1_text_1 ){ leaf1_element_1.add_text( 'leaf1_1' ) }
            let!( :list1_element_2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element_2 ){ list1_element_2.add_element( 'leaf1' ) }
            let!( :leaf1_text_2 ){ leaf1_element_2.add_text( 'leaf1_2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1_1'
              list1_element2 = list1.edit 'leaf1_2'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'invalid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              raise unless config.valid?
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'A valid leaf-list or list MUST have at least min-elements entries'

        describe 'If no "min-elements" statement is present, it defaults to zero' do
        end # describe 'If no "min-elements" statement is present, it defaults to zero'

        describe 'The behavior of the constraint depends on the type of the leaf-list\'s or list\'s closest ancestor node in the schema tree that is not a non- presence container' do

          describe 'If this ancestor is a case node, the constraint is enforced if any other node from the case exists' do
          end # describe 'If this ancestor is a case node, the constraint is enforced if any other node from the case exists'

          describe 'Otherwise, it is enforced if the ancestor node exists' do
          end # describe 'Otherwise, it is enforced if the ancestor node exists'

        end # describe 'The behavior of the constraint depends on the type of the leaf-list\'s or list\'s closest ancestor node in the schema tree that is not a non- presence container'

      end # describe '7.7.3. The min-elements Statement'

      # TODO
      describe '7.7.4. The max-elements Statement' do

        describe 'The "max-elements" statement, which is optional, takes as an argument a positive integer or the string "unbounded", which puts a constraint on valid list entries' do
        end # describe 'The "max-elements" statement, which is optional, takes as an argument a positive integer or the string "unbounded", which puts a constraint on valid list entries'

        describe 'A valid leaf-list or list always has at most max-elements entries' do

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 1;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 2;
                  }
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 2;
                  }
                }
              EOB
            }
            let!( :leaf_list1_element_1 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text_1 ){ leaf_list1_element_1.add_text( 'leaf-list1_1' ) }
            let!( :leaf_list1_element_2 ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text_2 ){ leaf_list1_element_2.add_text( 'leaf-list1_2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1_1' )
              leaf_list1.set( 'leaf-list1_2' )
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'invalid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  leaf-list leaf-list1 {
                    type string;
                    max-elements 0;
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' )
              leaf_list1.set( 'leaf-list1' )
              raise unless config.valid?
            } }
            it { is_expected.to raise_exception Exception }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 1;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 2;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'valid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 2;
                  }
                }
              EOB
            }
            let!( :list1_element_1 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element_1 ){ list1_element_1.add_element( 'leaf1' ) }
            let!( :leaf1_text_1 ){ leaf1_element_1.add_text( 'leaf1_1' ) }
            let!( :list1_element_2 ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element_2 ){ list1_element_2.add_element( 'leaf1' ) }
            let!( :leaf1_text_2 ){ leaf1_element_2.add_text( 'leaf1_2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1_1'
              list1_element2 = list1.edit 'leaf1_2'
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context 'invalid' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 0;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              raise unless config.valid?
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'A valid leaf-list or list always has at most max-elements entries'

        describe 'If no "max-elements" statement is present, it defaults to "unbounded"' do
        end # describe 'If no "max-elements" statement is present, it defaults to "unbounded"'

      end # describe '7.7.4. The max-elements Statement'

      # TODO
      describe '7.7.5. The ordered-by Statement' do

        describe 'The argument is one of the strings "system" or "user"' do
        end # describe 'The argument is one of the strings "system" or "user"'

        describe 'If not present, order defaults to "system"' do
        end # describe 'If not present, order defaults to "system"'

        describe 'This statement is ignored if the list represents state data, RPC output parameters, or notification content' do
        end # describe 'This statement is ignored if the list represents state data, RPC output parameters, or notification content'

        # TODO
        describe '7.7.5.1. ordered-by system' do

          describe 'The entries in the list are sorted according to an unspecified order' do
          end # describe 'The entries in the list are sorted according to an unspecified order'

        end # describe '7.7.5.1. ordered-by system'

        # TODO
        describe '7.7.5.2. ordered-by user' do

          describe 'The entries in the list are sorted according to an order defined by the user' do
          end # describe 'The entries in the list are sorted according to an order defined by the user'

        end # describe '7.7.5.2. ordered-by user'

      end # describe '7.7.5. The ordered-by Statement'

      # TODO
      describe '7.7.6. XML Mapping Rules' do
      end # describe '7.7.6. XML Mapping Rules'

      # TODO
      describe '7.7.7. NETCONF <edit-config> Operations' do
      end # describe '7.7.7. NETCONF <edit-config> Operations'

      # TODO
      describe '7.7.8. Usage Example' do

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

      end # describe '7.7.8. Usage Example'

    end # describe '7.7. The leaf-list Statement'

    # TODO
    describe '7.8. The list Statement' do

      # TODO
      describe '7.8.1. The list\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
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

          context '1 choice' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    choice choice1 {
                      case case1 {
                        leaf leaf2 { type string; }
                      }
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf2_element ){ list1_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf2 = list1_element1.edit 'leaf2'
              leaf2.set 'leaf2'
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
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    choice choice1 {
                      case case1 {
                        leaf leaf2 { type string; }
                      }
                    }
                    choice choice2 {
                      case case1 {
                        leaf leaf3 { type string; }
                      }
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf2_element ){ list1_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            let!( :leaf3_element ){ list1_element.add_element( 'leaf3' ) }
            let!( :leaf3_text ){ leaf3_element.add_text( 'leaf3' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf2 = list1_element1.edit 'leaf2'
              leaf2.set 'leaf2'
              leaf3 = list1_element1.edit 'leaf3'
              leaf3.set 'leaf3'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'choice'

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'container' do

          context '0 container' do
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

          context '1 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    container container1 {
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :container1_element ){ list1_element.add_element( 'container1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              container1 = list1_element1.edit 'container1'
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
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    container container1 {
                    }
                    container container2 {
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :container1_element ){ list1_element.add_element( 'container1' ) }
            let!( :container2_element ){ list1_element.add_element( 'container2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              container1 = list1_element1.edit 'container1'
              container2 = list1_element1.edit 'container2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'container'

        describe 'description' do

          context '0 description' do
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    description description1;
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    description description1;
                    description description2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'description'

        describe 'grouping' do

          context '0 grouping' do
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

          context '1 grouping' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    grouping grouping1 {
                      leaf leaf2 { type string; }
                    }
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

          context '2 groupings' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    grouping grouping1 {
                      leaf leaf2 { type string; }
                    }
                    grouping grouping2 {
                      leaf leaf3 { type string; }
                    }
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

        end # describe 'grouping'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'key' do
          '0..1'

          # TODO
          context '0 key' do
          end

          context '1 key' do
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

          context '2 keys' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    key leaf2;
                    leaf leaf1 { type string; }
                    leaf leaf2 { type string; }
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'key'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
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

          context '1 leaf-list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    leaf-list leaf-list1 { type string; }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf_list1_element ){ list1_element.add_element( 'leaf-list1' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf_list1 = list1_element1.edit 'leaf-list1'
              leaf_list1.set 'leaf-list1'
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
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    leaf-list leaf-list1 { type string; }
                    leaf-list leaf-list2 { type string; }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf_list1_element ){ list1_element.add_element( 'leaf-list1' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            let!( :leaf_list2_element ){ list1_element.add_element( 'leaf-list2' ) }
            let!( :leaf_list2_text ){ leaf_list2_element.add_text( 'leaf-list2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf_list1 = list1_element1.edit 'leaf-list1'
              leaf_list1.set 'leaf-list1'
              leaf_list2 = list1_element1.edit 'leaf-list2'
              leaf_list2.set 'leaf-list2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
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

          context '1 list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    list list2 {
                      key leaf2;
                      leaf leaf2 { type string; }
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :list2_element ){ list1_element.add_element( 'list2' ) }
            let!( :leaf2_element ){ list2_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              list2 = list1_element1.edit 'list2'
              list2_element1 = list2.edit 'leaf2'
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
                    list list2 {
                      key leaf2;
                      leaf leaf2 { type string; }
                    }
                    list list3 {
                      key leaf3;
                      leaf leaf3 { type string; }
                    }
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :list2_element ){ list1_element.add_element( 'list2' ) }
            let!( :leaf2_element ){ list2_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            let!( :list3_element ){ list1_element.add_element( 'list3' ) }
            let!( :leaf3_element ){ list3_element.add_element( 'leaf3' ) }
            let!( :leaf3_text ){ leaf3_element.add_text( 'leaf3' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              list2 = list1_element1.edit 'list2'
              list2_element1 = list2.edit 'leaf2'
              list3 = list1_element1.edit 'list3'
              list3_element1 = list3.edit 'leaf3'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'list'

        describe 'max-elements' do

          context '0 max-elements' do
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 max-elements' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 1;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 max-elementss' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    max-elements 1;
                    max-elements 2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'max-elements'

        describe 'min-elements' do

          context '0 min-elements' do
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 min-elements' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 1;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 min-elementss' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    min-elements 1;
                    min-elements 2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'min-elements'

        describe 'must' do

          context '0 must' do
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '1 must' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    must 1;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

          context '2 musts' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    must 1;
                    must 2;
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
              raise unless config.valid?
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'must'

        describe 'ordered-by' do
          '0..1'

          context '0 ordered-by' do
          end

          context '1 ordered-by' do
          end

          context '2 ordered-bys' do
          end

        end # describe 'ordered-by'

        describe 'reference' do

          context '0 reference' do
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    reference reference1;
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    reference reference1;
                    reference reference2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
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

          context '1 typedef' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    typedef typedef1 {
                      type string;
                    }
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

          context '2 typedefs' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    typedef typedef1 {
                      type string;
                    }
                    typedef typedef2 {
                      type string;
                    }
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

        end # describe 'typedef'

        describe 'unique' do
          '0..n'

          context '0 unique' do
          end

          context '1 unique' do
          end

          context '2 uniques' do
          end

        end # describe 'unique'

        describe 'uses' do
          '0..n'

          context '0 uses' do
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

          context '1 uses' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    grouping grouping1 {
                      leaf leaf2 { type string; }
                    }
                    uses grouping1;
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf2_element ){ list1_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf2 = list1_element1.edit 'leaf2'
              leaf2.set 'leaf2'
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
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    grouping grouping1 {
                      leaf leaf2 { type string; }
                    }
                    grouping grouping2 {
                      leaf leaf3 { type string; }
                    }
                    uses grouping1;
                    uses grouping2;
                  }
                }
              EOB
            }
            let!( :list1_element ){ root_xml.add_element( 'list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_element ){ list1_element.add_element( 'leaf1' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf2_element ){ list1_element.add_element( 'leaf2' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            let!( :leaf3_element ){ list1_element.add_element( 'leaf3' ) }
            let!( :leaf3_text ){ leaf3_element.add_text( 'leaf3' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              list1 = config.edit( 'list1' )
              list1_element1 = list1.edit 'leaf1'
              leaf2 = list1_element1.edit 'leaf2'
              leaf2.set 'leaf2'
              leaf3 = list1_element1.edit 'leaf3'
              leaf3.set 'leaf3'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'uses'

        describe 'when' do

          context '0 when' do
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

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    when 1;
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

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  list list1 {
                    key leaf1;
                    leaf leaf1 { type string; }
                    when 1;
                    when 2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'when'

      end # describe '7.8.1. The list\'s Substatements'

      # TODO
      describe '7.8.2. The list\'s key Statement' do

        describe 'The "key" statement, which MUST be present if the list represents configuration' do
        end # describe 'The "key" statement, which MUST be present if the list represents configuration'

        describe 'and MAY be present otherwise, takes as an argument a string that specifies a space-separated list of leaf identifiers of this list' do
        end # describe 'and MAY be present otherwise, takes as an argument a string that specifies a space-separated list of leaf identifiers of this list'

        describe 'A leaf identifier MUST NOT appear more than once in the key' do
        end # describe 'A leaf identifier MUST NOT appear more than once in the key'

        describe 'Each such leaf identifier MUST refer to a child leaf of the list' do
        end # describe 'Each such leaf identifier MUST refer to a child leaf of the list'

        describe 'The leafs can be defined directly in substatements to the list, or in groupings used in the list' do
        end # describe 'The leafs can be defined directly in substatements to the list, or in groupings used in the list'

        describe 'The combined values of all the leafs specified in the key are used to uniquely identify a list entry' do
        end # describe 'The combined values of all the leafs specified in the key are used to uniquely identify a list entry'

        describe 'All key leafs MUST be given values when a list entry is created' do
        end # describe 'All key leafs MUST be given values when a list entry is created'

        describe 'any default values in the key leafs or their types are ignored' do
        end # describe 'any default values in the key leafs or their types are ignored'

        describe 'any mandatory statement in the key leafs are ignored' do
        end # describe 'any mandatory statement in the key leafs are ignored'

        describe 'A leaf that is part of the key can be of any built-in or derived type' do
        end # describe 'A leaf that is part of the key can be of any built-in or derived type'

        describe 'except it MUST NOT be the built-in type "empty"' do
        end # describe 'except it MUST NOT be the built-in type "empty"'

        describe 'All key leafs in a list MUST have the same value for their "config" as the list itself' do
        end # describe 'All key leafs in a list MUST have the same value for their "config" as the list itself'

      end # describe '7.8.2. The list\'s key Statement'

      # TODO
      describe '7.8.3. The list\'s unique Statement' do

        describe 'The "unique" statement is used to put constraints on valid list entries.  It takes as an argument a string that contains a space- separated list of schema node identifiers, which MUST be given in the descendant form' do
        end # describe 'The "unique" statement is used to put constraints on valid list entries.  It takes as an argument a string that contains a space- separated list of schema node identifiers, which MUST be given in the descendant form'

        describe 'Each such schema node identifier MUST refer to a leaf' do
        end # describe 'Each such schema node identifier MUST refer to a leaf'

        describe 'If one of the referenced leafs represents configuration data, then all of the referenced leafs MUST represent configuration data' do
        end # describe 'If one of the referenced leafs represents configuration data, then all of the referenced leafs MUST represent configuration data'

        describe 'The "unique" constraint specifies that the combined values of all the leaf instances specified in the argument string, including leafs with default values, MUST be unique within all list entry instances in which all referenced leafs exist' do
        end # describe 'The "unique" constraint specifies that the combined values of all the leaf instances specified in the argument string, including leafs with default values, MUST be unique within all list entry instances in which all referenced leafs exist'

      end # describe '7.8.3. The list\'s unique Statement'

      # TODO
      describe '7.8.3.1.  Usage Example' do

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

      end # describe '7.8.3.1.  Usage Example'

      # TODO
      describe '7.8.4. The list\'s Child Node Statements' do
      end # describe '7.8.4. The list\'s Child Node Statements'

      # TODO
      describe '7.8.5. XML Mapping Rules' do

        describe 'A list is encoded as a series of XML elements, one for each entry in the list' do
        end # describe 'A list is encoded as a series of XML elements, one for each entry in the list'

        describe 'Each element’s local name is the list\'s identifier, and its namespace is the module\'s XML namespace' do
        end # describe 'Each element\'s local name is the list’s identifier, and its namespace is the module\'s XML namespace'

        describe 'The list’s key nodes are encoded as subelements to the list\'s identifier element, in the same order as they are defined within the "key" statement' do
        end # describe 'The list’s key nodes are encoded as subelements to the list\'s identifier element, in the same order as they are defined within the "key" statement'

        describe 'The rest of the list\'s child nodes are encoded as subelements to the list element, after the keys' do
        end # describe 'The rest of the list\'s child nodes are encoded as subelements to the list element, after the keys'

        describe 'If the list defines RPC input or output parameters, the subelements are encoded in the same order as they are defined within the "list" statement' do
        end # describe 'If the list defines RPC input or output parameters, the subelements are encoded in the same order as they are defined within the "list" statement'

        describe 'Otherwise, the subelements are encoded in any order' do
        end # describe 'Otherwise, the subelements are encoded in any order'

        describe 'The XML elements representing list entries MUST appear in the order specified by the user if the list is "ordered-by user"' do
        end # describe 'The XML elements representing list entries MUST appear in the order specified by the user if the list is "ordered-by user"'

        describe 'otherwise the order is implementation-dependent' do
        end # describe 'otherwise the order is implementation-dependent'

        describe 'The XML elements representing list entries MAY be interleaved with other sibling elements, unless the list defines RPC input or output parameters' do
        end # describe 'The XML elements representing list entries MAY be interleaved with other sibling elements, unless the list defines RPC input or output parameters'

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

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'case' do

          context '0 case' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
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

          context '1 case' do
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

          context '2 cases' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                    }
                    case case2 {
                      leaf leaf2 { type string; }
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

        end # describe 'case'

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'container' do
          '0..n'

          context '0 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
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

          context '1 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    container container1 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    leaf leaf1 { type string; }
                    container container1 {
                    }
                    container container2 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'container'

        describe 'default' do
          '0..1'

          context '0 default' do
          end

          context '1 default' do
          end

          context '2 defaults' do
          end

        end # describe 'default'

        describe 'description' do

          context '0 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    description description1;
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    description description1;
                    description description2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    container container1 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    container container1 {
                    }
                    leaf leaf1 { type string; }
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

          context '2 leafs' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    container container1 {
                    }
                    leaf leaf1 { type string; }
                    leaf leaf2 { type string; }
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

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    container container1 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    container container1 {
                    }
                    leaf-list leaf-list1 { type string; }
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' ).set( 'leaf-list1' )
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
                  choice choice1 {
                    container container1 {
                    }
                    leaf-list leaf-list1 { type string; }
                    leaf-list leaf-list2 { type string; }
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' ).set( 'leaf-list1' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'leaf-list'

        describe 'list' do

          context '0 list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    container container1 {
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    list list1 {
                      key leaf1;
                      leaf leaf1 { type string; }
                    }
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
                  choice choice1 {
                    list list1 {
                      key leaf1;
                      leaf leaf1 { type string; }
                    }
                    list list2 {
                      key leaf2;
                      leaf leaf2 { type string; }
                    }
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

        end # describe 'list'

        describe 'mandatory' do
          '0..1'

          context '0 mandatory' do
          end

          context '1 mandatory' do
          end

          context '2 mandatorys' do
          end

        end # describe 'mandatory'

        describe 'reference' do
          '0..1'

          context '0 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    reference reference1;
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    reference reference1;
                    reference reference2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'when' do

          context '0 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
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

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    when 1;
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

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    leaf leaf1 { type string; }
                    when 1;
                    when 2;
                  }
                }
              EOB
            }
            subject { ->{
              db.load_model Rubyang::Model::Parser.parse( yang_str )
            } }
            it { is_expected.to raise_exception Exception }
          end

        end # describe 'when'

      end # describe '7.9.1. The choice\'s Substatements'

      # TODO
      describe '7.9.2. The choice\'s case Statement' do

        describe 'The identifier is used to identify the case node in the schema tree' do
        end # describe 'The identifier is used to identify the case node in the schema tree'

        describe 'A case node does not exist in the data tree' do
        end # describe 'A case node does not exist in the data tree'

        describe 'The identifiers of all these child nodes MUST be unique within all cases in a choice' do

          describe 'For example, the following is illegal:' do
            <<-EOB
     choice interface-type {     // This example is illegal YANG
   case a {
       leaf ethernet { ... }
   }
   case b {
       container ethernet { ...}
   }
     }
            EOB
          end # describe 'For example, the following is illegal:'

        end # describe 'The identifiers of all these child nodes MUST be unique within all cases in a choice'

        describe 'As a shorthand, the "case" statement can be omitted if the branch contains a single "anyxml", "container", "leaf", "list", or "leaf-list" statement' do
        end # describe 'As a shorthand, the "case" statement can be omitted if the branch contains a single "anyxml", "container", "leaf", "list", or "leaf-list" statement'

        describe 'In this case, the identifier of the case node is the same as the identifier in the branch statement' do

        describe 'The following examples are equivalent:' do
          <<-EOB
          choice interface-type {
                   container ethernet { ... }
                  }
          EOB
          <<-EOB
          choice interface-type {
                   case ethernet {
                          container ethernet { ... }
                             }
                            }
          EOB

        end # describe 'The following examples are equivalent:'

        end # describe 'In this case, the identifier of the case node is the same as the identifier in the branch statement'

      end # describe '7.9.2. The choice\'s case Statement'

      # TODO
      describe '7.9.2.1.  The case\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
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

          context '1 choice' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      choice choice2 {
                        leaf leaf1 { type string; }
                      }
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
                      choice choice2 {
                        leaf leaf1 { type string; }
                      }
                      choice choice3 {
                        leaf leaf2 { type string; }
                      }
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

        end # describe 'choice'

        describe 'container' do

          context '0 container' do
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

          context '1 container' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      container container1 {
                      }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    case case1 {
                      container container1 {
                      }
                      container container2 {
                      }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :container2_element ){ root_xml.add_element( 'container2' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
              container2 = config.edit( 'container2' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'container'

        describe 'description' do

          context '0 description' do
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

          context '1 description' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      description description1;
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

          context '2 descriptions' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      description description1;
                      description description2;
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

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      container container1 {
                      }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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

          context '2 leafs' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
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

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      container container1 {
                      }
                    }
                  }
                }
              EOB
            }
            let!( :container1_element ){ root_xml.add_element( 'container1' ).add_namespace( 'http://module1.rspec/' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              container1 = config.edit( 'container1' )
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
                  choice choice1 {
                    case case1 {
                      leaf-list leaf-list1 { type string; }
                    }
                  }
                }
              EOB
            }
            let!( :leaf_list1_element ){ root_xml.add_element( 'leaf-list1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf_list1_text ){ leaf_list1_element.add_text( 'leaf-list1' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf_list1 = config.edit( 'leaf-list1' ).set( 'leaf-list1' )
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
                  choice choice1 {
                    case case1 {
                      leaf-list leaf-list1 { type string; }
                      leaf-list leaf-list2 { type string; }
                    }
                  }
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
              leaf_list1 = config.edit( 'leaf-list1' ).set( 'leaf-list1' )
              leaf_list2 = config.edit( 'leaf-list2' ).set( 'leaf-list2' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'leaf-list'

        describe 'list' do

          context '0 list' do
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

          context '1 list' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      list list1 {
                        key leaf1;
                        leaf leaf1 { type string; }
                      }
                    }
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
                  choice choice1 {
                    case case1 {
                      list list1 {
                        key leaf1;
                        leaf leaf1 { type string; }
                      }
                      list list2 {
                        key leaf2;
                        leaf leaf2 { type string; }
                      }
                    }
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
              list2_element1 = list2.edit 'leaf2'
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'list'

        describe 'reference' do

          context '0 reference' do
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

          context '1 reference' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      reference reference1;
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

          context '2 references' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      reference reference1;
                      reference reference2;
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

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'uses' do
          '0..n'

          context '0 uses' do
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

          context '1 uses' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  grouping grouping1 {
                    leaf leaf2 { type string; }
                  }
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      uses grouping1;
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

          context '2 usess' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  grouping grouping1 {
                    leaf leaf2 { type string; }
                  }
                  grouping grouping2 {
                    leaf leaf3 { type string; }
                  }
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      uses grouping1;
                      uses grouping2;
                    }
                  }
                }
              EOB
            }
            let!( :leaf1_element ){ root_xml.add_element( 'leaf1' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf1_text ){ leaf1_element.add_text( 'leaf1' ) }
            let!( :leaf2_element ){ root_xml.add_element( 'leaf2' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf2_text ){ leaf2_element.add_text( 'leaf2' ) }
            let!( :leaf3_element ){ root_xml.add_element( 'leaf3' ).add_namespace( 'http://module1.rspec/' ) }
            let!( :leaf3_text ){ leaf3_element.add_text( 'leaf3' ) }
            subject {
              db.load_model Rubyang::Model::Parser.parse( yang_str )
              config = db.configure
              leaf1 = config.edit( 'leaf1' ).set( 'leaf1' )
              leaf2 = config.edit( 'leaf2' ).set( 'leaf2' )
              leaf3 = config.edit( 'leaf3' ).set( 'leaf3' )
              config.to_xml( pretty: true )
            }
            it { is_expected.to eq doc_xml_pretty }
          end

        end # describe 'uses'

        describe 'when' do

          context '0 when' do
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

          context '1 when' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      when 1;
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

          context '2 whens' do
            let( :yang_str ){
              <<-EOB
                module module1 {
                  namespace "http://module1.rspec/";
                  prefix module1;
                  choice choice1 {
                    case case1 {
                      leaf leaf1 { type string; }
                      when 1;
                      when 2;
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

        end # describe 'when'

      end # describe '7.9.2.1.  The case\'s Substatements'

      # TODO
      describe '7.9.3. The choice\'s default Statement' do

        describe 'The "default" statement indicates if a case should be considered as the default if no child nodes from any of the choice’s cases exist' do
        end # describe 'The "default" statement indicates if a case should be considered as the default if no child nodes from any of the choice’s cases exist'

        describe 'The argument is the identifier of the "case" statement' do
        end # describe 'The argument is the identifier of the "case" statement'

        describe 'If the "default" statement is missing, there is no default case' do
        end # describe 'If the "default" statement is missing, there is no default case'

        describe ' The "default" statement MUST NOT be present on choices where "mandatory" is true' do
        end # describe ' The "default" statement MUST NOT be present on choices where "mandatory" is true'

        describe 'The default values for nodes under the default case are used if none of the nodes under any of the cases are present' do
        end # describe 'The default values for nodes under the default case are used if none of the nodes under any of the cases are present'

        describe 'There MUST NOT be any mandatory nodes (Section 3.1) directly under the default case' do
        end # describe 'There MUST NOT be any mandatory nodes (Section 3.1) directly under the default case'

        describe 'Default values for child nodes under a case are only used if one of the nodes under that case is present, or if that case is the default case' do
        end # describe 'Default values for child nodes under a case are only used if one of the nodes under that case is present, or if that case is the default case'

        describe 'If none of the nodes under a case are present and the case is not the default case, the default values of the cases’ child nodes are ignored' do
        end # describe 'If none of the nodes under a case are present and the case is not the default case, the default values of the cases’ child nodes are ignored'

        describe ' In this example, the choice defaults to "interval", and the default value will be used if none of "daily", "time-of-day", or "manual" are present.  If "daily" is present, the default value for "time-of-day" will be used' do

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

        end # describe ' In this example, the choice defaults to "interval", and the default value will be used if none of "daily", "time-of-day", or "manual" are present.  If "daily" is present, the default value for "time-of-day" will be used'

      end # describe '7.9.3. The choice\'s default Statement'

      # TODO
      describe '7.9.4. The choice\'s mandatory Statement' do

        describe 'If "mandatory" is "true", at least one node from exactly one of the choice’s case branches MUST exist' do
        end # describe 'If "mandatory" is "true", at least one node from exactly one of the choice’s case branches MUST exist'

        describe 'If not specified, the default is "false"' do
        end # describe 'If not specified, the default is "false"'

        describe 'The behavior of the constraint depends on the type of the choice’s closest ancestor node in the schema tree which is not a non-presence container:' do

          describe 'If this ancestor is a case node, the constraint is enforced if any other node from the case exists' do
          end # describe 'If this ancestor is a case node, the constraint is enforced if any other node from the case exists'

          describe 'Otherwise, it is enforced if the ancestor node exists' do
          end # describe 'Otherwise, it is enforced if the ancestor node exists'

        end # describe 'The behavior of the constraint depends on the type of the choice’s closest ancestor node in the schema tree which is not a non-presence container:'

      end # describe '7.9.4. The choice\'s mandatory Statement'

      # TODO
      describe '7.9.5. XML Mapping Rules' do
      end # describe '7.9.5. XML Mapping Rules'

      # TODO
      describe '7.9.6. NETCONF <edit-config> Operations' do
      end # describe '7.9.6. NETCONF <edit-config> Operations'

      # TODO
      describe '7.9.7. Usage Example' do

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

      end # describe '7.9.7. Usage Example'

    end # describe '7.9. The choice Statement'

    # TODO
    describe '7.10. The anyxml Statement' do

      describe 'The "anyxml" statement is used to represent an unknown chunk of XML' do
      end # describe 'The "anyxml" statement is used to represent an unknown chunk of XML'

      describe 'An anyxml node cannot be augmented' do
      end # describe 'An anyxml node cannot be augmented'

      describe 'An anyxml node exists in zero or one instances in the data tree' do
      end # describe 'An anyxml node exists in zero or one instances in the data tree'

      # TODO
      describe '7.10.1. The anyxml\'s Substatements' do

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'mandatory' do
          '0..1'

          context '0 mandatory' do
          end

          context '1 mandatory' do
          end

          context '2 mandatorys' do
          end

        end # describe 'mandatory'

        describe 'must' do
          '0..n'

          context '0 must' do
          end

          context '1 must' do
          end

          context '2 musts' do
          end

        end # describe 'must'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'when' do
          '0..1'

          context '0 when' do
          end

          context '1 when' do
          end

          context '2 whens' do
          end

        end # describe 'when'

      end # describe '7.10.1. The anyxml\'s Substatements'

      # TODO
      describe '7.10.2. XML Mapping Rules' do
      end # describe '7.10.2. XML Mapping Rules'

      # TODO
      describe '7.10.3. NETCONF <edit-config> Operations' do
      end # describe '7.10.3. NETCONF <edit-config> Operations'

      # TODO
      describe '7.10.4. Usage Example' do

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

      end # describe '7.10.4. Usage Example'

    end # describe '7.10. The anyxml Statement'

    # TODO
    describe '7.11. The grouping Statement' do

      describe 'The "grouping" statement is not a data definition statement and, as such, does not define any nodes in the schema tree' do
      end # describe 'The "grouping" statement is not a data definition statement and, as such, does not define any nodes in the schema tree'

      describe 'Once a grouping is defined, it can be referenced in a "uses" statement' do
      end # describe 'Once a grouping is defined, it can be referenced in a "uses" statement'

      describe 'A grouping MUST NOT reference itself, neither directly nor indirectly through a chain of other groupings' do
      end # describe 'A grouping MUST NOT reference itself, neither directly nor indirectly through a chain of other groupings'

      describe 'If the grouping is defined at the top level of a YANG module or submodule, the grouping’s identifier MUST be unique within the module' do
      end # describe 'If the grouping is defined at the top level of a YANG module or submodule, the grouping’s identifier MUST be unique within the module'

      describe 'Identifiers appearing inside the grouping are resolved relative to the scope in which the grouping is defined, not where it is used' do
      end # describe 'Identifiers appearing inside the grouping are resolved relative to the scope in which the grouping is defined, not where it is used'

      describe 'Prefix mappings, type names, grouping names, and extension usage are evaluated in the hierarchy where the "grouping" statement appears' do
      end # describe 'Prefix mappings, type names, grouping names, and extension usage are evaluated in the hierarchy where the "grouping" statement appears'

      describe 'For extensions, this means that extensions are applied to the grouping node, not the uses node' do
      end # describe 'For extensions, this means that extensions are applied to the grouping node, not the uses node'

      # TODO
      describe '7.11.1. The grouping\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
          end

          context '1 choice' do
          end

          context '2 choices' do
          end

        end # describe 'choice'

        describe 'container' do
          '0..n'

          context '0 container' do
          end

          context '1 container' do
          end

          context '2 containers' do
          end

        end # describe 'container'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
          end

          context '1 grouping' do
          end

          context '2 groupings' do
          end

        end # describe 'grouping'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
          end

          context '1 leaf-list' do
          end

          context '2 leaf-lists' do
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
          end

          context '1 list' do
          end

          context '2 lists' do
          end

        end # describe 'list'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
          end

          context '1 typedef' do
          end

          context '2 typedefs' do
          end

        end # describe 'typedef'

        describe 'uses' do
          '0..n'

          context '0 uses' do
          end

          context '1 uses' do
          end

          context '2 usess' do
          end

        end # describe 'uses'

      end # describe '7.11.1. The grouping\'s Substatements'

      # TODO
      describe '7.11.2. Usage Example' do

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

      end # describe '7.11.2. Usage Example'

    end # describe '7.11. The grouping Statement'

    # TODO
    describe '7.12. The uses Statement' do

      describe 'It takes one argument, which is the name of the grouping' do
      end # describe 'It takes one argument, which is the name of the grouping'

      describe 'The identifiers defined in the grouping are not bound to a namespace until the contents of the grouping are added to the schema tree via a "uses" statement that does not appear inside a "grouping" statement, at which point they are bound to the namespace of the current module' do
      end # describe 'The identifiers defined in the grouping are not bound to a namespace until the contents of the grouping are added to the schema tree via a "uses" statement that does not appear inside a "grouping" statement, at which point they are bound to the namespace of the current module'

      # TODO
      describe '7.12.1. The uses\'s Substatements' do

        describe 'augment' do
          '0..1'

          context '0 augment' do
          end

          context '1 augment' do
          end

          context '2 augments' do
          end

        end # describe 'augment'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'refine' do
          '0..1'

          context '0 refine' do
          end

          context '1 refine' do
          end

          context '2 refines' do
          end

        end # describe 'refine'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'when' do
          '0..1'

          context '0 when' do
          end

          context '1 when' do
          end

          context '2 whens' do
          end

        end # describe 'when'

      end # describe '7.12.1. The uses\'s Substatements'

      # TODO
      describe '7.12.2. The refine Statement' do

        describe 'If a node in the grouping is not present as a target node of a "refine" statement, it is not refined, and thus used exactly as it was defined in the grouping' do
        end # describe 'If a node in the grouping is not present as a target node of a "refine" statement, it is not refined, and thus used exactly as it was defined in the grouping'

        describe 'The argument string is a descendant schema node identifier' do
        end # describe 'The argument string is a descendant schema node identifier'

        describe 'A leaf or choice node may get a default value, or a new default value if it already had one' do
        end # describe 'A leaf or choice node may get a default value, or a new default value if it already had one'

        describe 'Any node may get a specialized "description" string' do
        end # describe 'Any node may get a specialized "description" string'

        describe 'Any node may get a specialized "reference" string' do
        end # describe 'Any node may get a specialized "reference" string'

        describe 'Any node may get a different "config" statement' do
        end # describe 'Any node may get a different "config" statement'

        describe 'A leaf, anyxml, or choice node may get a different "mandatory" statement' do
        end # describe 'A leaf, anyxml, or choice node may get a different "mandatory" statement'

        describe 'A container node may get a "presence" statement' do
        end # describe 'A container node may get a "presence" statement'

        describe 'A leaf, leaf-list, list, container, or anyxml node may get additional "must" expressions' do
        end # describe 'A leaf, leaf-list, list, container, or anyxml node may get additional "must" expressions'

        describe 'A leaf-list or list node may get a different "min-elements" or "max-elements" statement.' do
        end # describe 'A leaf-list or list node may get a different "min-elements" or "max-elements" statement.'

      end # describe '7.12.2. The refine Statement'

      # TODO
      describe '7.12.3. XML Mapping Rules' do
      end # describe '7.12.3. XML Mapping Rules'

      # TODO
      describe '7.12.4. Usage Example' do

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

      end # describe '7.12.4. Usage Example'

    end # describe '7.12. The uses Statement'

    # TODO
    describe '7.13. The rpc Statement' do

      # TODO
      describe '7.13.1. The rpc\'s Substatements' do

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
          end

          context '1 grouping' do
          end

          context '2 groupings' do
          end

        end # describe 'grouping'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'input' do
          '0..1'

          context '0 input' do
          end

          context '1 input' do
          end

          context '2 inputs' do
          end

        end # describe 'input'

        describe 'output' do
          '0..1'

          context '0 output' do
          end

          context '1 output' do
          end

          context '2 outputs' do
          end

        end # describe 'output'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
          end

          context '1 typedef' do
          end

          context '2 typedefs' do
          end

        end # describe 'typedef'

      end # describe '7.13.1. The rpc\'s Substatements'

      # TODO
      describe '7.13.2. The input Statement' do
      end # describe '7.13.2. The input Statement'

      # TODO
      describe '7.13.2.1.  The input\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
          end

          context '1 choice' do
          end

          context '2 choices' do
          end

        end # describe 'choice'

        describe 'container' do
          '0..n'

          context '0 container' do
          end

          context '1 container' do
          end

          context '2 containers' do
          end

        end # describe 'container'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
          end

          context '1 grouping' do
          end

          context '2 groupings' do
          end

        end # describe 'grouping'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
          end

          context '1 leaf-list' do
          end

          context '2 leaf-lists' do
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
          end

          context '1 list' do
          end

          context '2 lists' do
          end

        end # describe 'list'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
          end

          context '1 typedef' do
          end

          context '2 typedefs' do
          end

        end # describe 'typedef'

        describe 'uses' do
          '0..n'

          context '0 uses' do
          end

          context '1 uses' do
          end

          context '2 usess' do
          end

        end # describe 'uses'

      end # describe '7.13.2.1.  The input\'s Substatements'

      # TODO
      describe '7.13.3. The output Statement' do
      end # describe '7.13.3. The output Statement'


      # TODO
      describe '7.13.3.1.  The output\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
          end

          context '1 choice' do
          end

          context '2 choices' do
          end

        end # describe 'choice'

        describe 'container' do
          '0..n'

          context '0 container' do
          end

          context '1 container' do
          end

          context '2 containers' do
          end

        end # describe 'container'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
          end

          context '1 grouping' do
          end

          context '2 groupings' do
          end

        end # describe 'grouping'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
          end

          context '1 leaf-list' do
          end

          context '2 leaf-lists' do
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
          end

          context '1 list' do
          end

          context '2 lists' do
          end

        end # describe 'list'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
          end

          context '1 typedef' do
          end

          context '2 typedefs' do
          end

        end # describe 'typedef'

        describe 'uses' do
          '0..n'

          context '0 uses' do
          end

          context '1 uses' do
          end

          context '2 usess' do
          end

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

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'choice' do
          '0..n'

          context '0 choice' do
          end

          context '1 choice' do
          end

          context '2 choices' do
          end

        end # describe 'choice'

        describe 'container' do
          '0..n'

          context '0 container' do
          end

          context '1 container' do
          end

          context '2 containers' do
          end

        end # describe 'container'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'grouping' do
          '0..n'

          context '0 grouping' do
          end

          context '1 grouping' do
          end

          context '2 groupings' do
          end

        end # describe 'grouping'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
          end

          context '1 leaf-list' do
          end

          context '2 leaf-lists' do
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
          end

          context '1 list' do
          end

          context '2 lists' do
          end

        end # describe 'list'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'typedef' do
          '0..n'

          context '0 typedef' do
          end

          context '1 typedef' do
          end

          context '2 typedefs' do
          end

        end # describe 'typedef'

        describe 'uses' do
          '0..n'

          context '0 uses' do
          end

          context '1 uses' do
          end

          context '2 usess' do
          end

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

      describe 'The "augment" statement allows a module or submodule to add to the schema tree defined in an external module' do
      end # describe 'The "augment" statement allows a module or submodule to add to the schema tree defined in an external module'

      describe 'or the current module and its submodules' do
      end # describe 'or the current module and its submodules'

      describe 'and to add to the nodes from a grouping in a "uses" statement' do
      end # describe 'and to add to the nodes from a grouping in a "uses" statement'

      describe 'The target node MUST be either a container, list, choice, case, input, output, or notification node' do
      end # describe 'The target node MUST be either a container, list, choice, case, input, output, or notification node'

      describe 'The argument string is a schema node identifier' do
      end # describe 'The argument string is a schema node identifier'

      describe 'If the "augment" statement is on the top level in a module or submodule, the absolute form of a schema node identifier MUST be used' do
      end # describe 'If the "augment" statement is on the top level in a module or submodule, the absolute form of a schema node identifier MUST be used'

      describe 'If the "augment" statement is a substatement to the "uses" statement, the descendant form MUST be used' do
      end # describe 'If the "augment" statement is a substatement to the "uses" statement, the descendant form MUST be used'

      describe 'If the target node is a container, list, case, input, output, or notification node, the "container", "leaf", "list", "leaf-list", "uses", and "choice" statements can be used within the "augment" statement' do
      end # describe 'If the target node is a container, list, case, input, output, or notification node, the "container", "leaf", "list", "leaf-list", "uses", and "choice" statements can be used within the "augment" statement'

      describe ' If the target node is a choice node, the "case" statement, or a case shorthand statement (see Section 7.9.2) can be used within the "augment" statement' do
      end # describe ' If the target node is a choice node, the "case" statement, or a case shorthand statement (see Section 7.9.2) can be used within the "augment" statement'

      describe 'If the target node is in another module, then nodes added by the augmentation MUST NOT be mandatory nodes' do
      end # describe 'If the target node is in another module, then nodes added by the augmentation MUST NOT be mandatory nodes'

      describe 'The "augment" statement MUST NOT add multiple nodes with the same name from the same module to the target node' do
      end # describe 'The "augment" statement MUST NOT add multiple nodes with the same name from the same module to the target node'

      # TODO
      describe '7.15.1. The augment\'s Substatements' do

        describe 'anyxml' do
          '0..n'

          context '0 anyxml' do
          end

          context '1 anyxml' do
          end

          context '2 anyxmls' do
          end

        end # describe 'anyxml'

        describe 'case' do
          '0..n'

          context '0 case' do
          end

          context '1 case' do
          end

          context '2 cases' do
          end

        end # describe 'case'

        describe 'choice' do
          '0..n'

          context '0 choice' do
          end

          context '1 choice' do
          end

          context '2 choices' do
          end

        end # describe 'choice'

        describe 'container' do
          '0..n'

          context '0 container' do
          end

          context '1 container' do
          end

          context '2 containers' do
          end

        end # describe 'container'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'leaf' do
          '0..n'

          context '0 leaf' do
          end

          context '1 leaf' do
          end

          context '2 leafs' do
          end

        end # describe 'leaf'

        describe 'leaf-list' do
          '0..n'

          context '0 leaf-list' do
          end

          context '1 leaf-list' do
          end

          context '2 leaf-lists' do
          end

        end # describe 'leaf-list'

        describe 'list' do
          '0..n'

          context '0 list' do
          end

          context '1 list' do
          end

          context '2 lists' do
          end

        end # describe 'list'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'uses' do
          '0..n'

          context '0 uses' do
          end

          context '1 uses' do
          end

          context '2 usess' do
          end

        end # describe 'uses'

        describe 'when' do
          '0..1'

          context '0 when' do
          end

          context '1 when' do
          end

          context '2 whens' do
          end

        end # describe 'when'

      end # describe '7.15.1. The augment\'s Substatements'

      # TODO
      describe '7.15.2. XML Mapping Rules' do

      describe 'All data nodes defined in the "augment" statement are defined as XML elements in the XML namespace of the module where the "augment" is specified' do
      end # describe 'All data nodes defined in the "augment" statement are defined as XML elements in the XML namespace of the module where the "augment" is specified'

      end # describe '7.15.2. XML Mapping Rules'

      # TODO
      describe '7.15.3. Usage Example' do

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

      end # describe '7.15.3. Usage Example'

    end # describe '7.15. The augment Statement'

    # TODO
    describe '7.16. The identity Statement' do

      # TODO
      describe '7.16.1. The identity\'s Substatements' do

        describe 'base' do
          '0..1'

          context '0 base' do
          end

          context '1 base' do
          end

          context '2 bases' do
          end

        end # describe 'base'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

      end # describe '7.16.1. The identity\'s Substatements'

      # TODO
      describe '7.16.2. The base Statement' do

        describe 'If no "base" statement is present, the identity is defined from scratch' do
        end # describe 'If no "base" statement is present, the identity is defined from scratch'

        describe 'If a prefix is present on the base name, it refers to an identity defined in the module that was imported with that prefix, or the local module if the prefix matches the local module’s prefix' do
        end # describe 'If a prefix is present on the base name, it refers to an identity defined in the module that was imported with that prefix, or the local module if the prefix matches the local module’s prefix'

        describe 'Otherwise, an identity with the matching name MUST be defined in the current module or an included submodule' do
        end # describe 'Otherwise, an identity with the matching name MUST be defined in the current module or an included submodule'

        describe 'Since submodules cannot include the parent module, any identities in the module that need to be exposed to submodules MUST be defined in a submodule' do
        end # describe 'Since submodules cannot include the parent module, any identities in the module that need to be exposed to submodules MUST be defined in a submodule'

        describe 'Submodules can then include this submodule to find the definition of the identity' do
        end # describe 'Submodules can then include this submodule to find the definition of the identity'

        describe 'An identity MUST NOT reference itself, neither directly nor indirectly through a chain of other identities' do
        end # describe 'An identity MUST NOT reference itself, neither directly nor indirectly through a chain of other identities'

      end # describe '7.16.2. The base Statement'

      # TODO
      describe '7.16.3. Usage Example' do

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

      end # describe '7.16.3. Usage Example'

    end # describe '7.16. The identity Statement'

    # TODO
    describe '7.17. The extension Statement' do

        describe 'This new statement definition can be imported and used by other modules' do
        end # describe 'This new statement definition can be imported and used by other modules'

        describe 'The statement’s argument is an identifier that is the new keyword for the extension and must be followed by a block of substatements that holds detailed extension information' do
        end # describe 'The statement’s argument is an identifier that is the new keyword for the extension and must be followed by a block of substatements that holds detailed extension information'

        describe 'The extension can be used like a normal YANG statement, with the statement name followed by an argument if one is defined by the extension, and an optional block of substatements' do
        end # describe 'The extension can be used like a normal YANG statement, with the statement name followed by an argument if one is defined by the extension, and an optional block of substatements'

        describe 'The statement’s name is created by combining the prefix of the module in which the extension was defined, a colon (":"), and the extension’s keyword, with no interleaving whitespace' do
        end # describe 'The statement’s name is created by combining the prefix of the module in which the extension was defined, a colon (":"), and the extension’s keyword, with no interleaving whitespace'

        describe 'The substatements of an extension are defined by the extension, using some mechanism outside the scope of this specification' do
        end # describe 'The substatements of an extension are defined by the extension, using some mechanism outside the scope of this specification'

        describe 'Syntactically, the substatements MUST be YANG statements, or also defined using "extension" statements' do
        end # describe 'Syntactically, the substatements MUST be YANG statements, or also defined using "extension" statements'

      # TODO
      describe '7.17.1. The extension\'s Substatements' do

        describe 'argument' do
          '0..1'

          context '0 argument' do
          end

          context '1 argument' do
          end

          context '2 arguments' do
          end

        end # describe 'argument'

        describe 'description' do
          '0..1'

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

      end # describe '7.17.1. The extension\'s Substatements'

      # TODO
      describe '7.17.2. The argument Statement' do

        describe 'If no argument statement is present, the keyword expects no argument when it is used' do
        end # describe 'If no argument statement is present, the keyword expects no argument when it is used'

        describe 'The argument\'s name is used in the YIN mapping, where it is used as an XML attribute or element name, depending on the argument’s "yin- element" statement' do
        end # describe 'The argument\'s name is used in the YIN mapping, where it is used as an XML attribute or element name, depending on the argument’s "yin- element" statement'

        # TODO
        describe '7.17.2.1.  The argument\'s Substatements' do

          describe 'yin-element' do
            '0..1'

            context '0 yin-element' do
            end

            context '1 yin-element' do
            end

            context '2 yin-elements' do
            end

          end # describe 'yin-element'

        end # describe '7.17.2.1.  The argument\'s Substatements'

        # TODO
        describe '7.17.2.2.  The yin-element Statement' do

          describe 'The "yin-element" statement, which is optional, takes as an argument the string "true" or "false"' do
          end # describe 'The "yin-element" statement, which is optional, takes as an argument the string "true" or "false"'

          describe 'If no "yin-element" statement is present, it defaults to "false"' do
          end # describe 'If no "yin-element" statement is present, it defaults to "false"'

          describe '' do
          end # describe ''

          describe '' do
          end # describe ''

        end # describe '7.17.2.2.  The yin-element Statement'

      end # describe '7.17.2. The argument Statement'

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

      describe '' do
      end # describe ''

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

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'if-feature' do
          '0..n'

          context '0 if-feature' do
          end

          context '1 if-feature' do
          end

          context '2 if-features' do
          end

        end # describe 'if-feature'

        describe 'status' do
          '0..1'

          context '0 status' do
          end

          context '1 status' do
          end

          context '2 statuss' do
          end

        end # describe 'status'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

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

          context '0 description' do
          end

          context '1 description' do
          end

          context '2 descriptions' do
          end

        end # describe 'description'

        describe 'deviate' do
          '1..n'
        end # describe 'deviate'

        describe 'reference' do
          '0..1'

          context '0 reference' do
          end

          context '1 reference' do
          end

          context '2 references' do
          end

        end # describe 'reference'

      end # describe '7.18.3.1.  The deviation\'s Substatements'

      # TODO
      describe '7.18.3.2.  The deviate Statement' do
      end # describe '7.18.3.2.  The deviate Statement'

      # TODO
      describe 'The deviates\'s Substatements' do

        describe 'config' do
          '0..1'

          context '0 config' do
          end

          context '1 config' do
          end

          context '2 configs' do
          end

        end # describe 'config'

        describe 'default' do
          '0..1'

          context '0 default' do
          end

          context '1 default' do
          end

          context '2 defaults' do
          end

        end # describe 'default'

        describe 'mandatory' do
          '0..1'

          context '0 mandatory' do
          end

          context '1 mandatory' do
          end

          context '2 mandatorys' do
          end

        end # describe 'mandatory'

        describe 'max-elements' do
          '0..1'

          context '0 max-elements' do
          end

          context '1 max-elements' do
          end

          context '2 max-elementss' do
          end

        end # describe 'max-elements'

        describe 'min-elements' do
          '0..1'

          context '0 min-elements' do
          end

          context '1 min-elements' do
          end

          context '2 min-elementss' do
          end

        end # describe 'min-elements'

        describe 'must' do
          '0..n'

          context '0 must' do
          end

          context '1 must' do
          end

          context '2 musts' do
          end

        end # describe 'must'

        describe 'type' do
          '0..1'

          context '0 type' do
          end

          context '1 type' do
          end

          context '2 types' do
          end

        end # describe 'type'

        describe 'unique' do
          '0..n'

          context '0 unique' do
          end

          context '1 unique' do
          end

          context '2 uniques' do
          end

        end # describe 'unique'

        describe 'units' do
          '0..1'

          context '0 units' do
          end

          context '1 units' do
          end

          context '2 unitss' do
          end

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

        describe 'The "config" statement takes as an argument the string "true" or "false"' do
        end # describe 'The "config" statement takes as an argument the string "true" or "false"'

        describe 'If "config" is "true", the definition represents configuration' do

        describe 'Data nodes representing configuration will be part of the reply to a <get-config> request, and can be sent in a <copy-config> or <edit-config> request' do
        end # describe 'Data nodes representing configuration will be part of the reply to a <get-config> request, and can be sent in a <copy-config> or <edit-config> request'

        end # describe 'If "config" is "true", the definition represents configuration'

        describe 'If "config" is "false", the definition represents state data' do

        describe 'Data nodes representing state data will be part of the reply to a <get>, but not to a <get-config> request, and cannot be sent in a <copy-config> or <edit-config> request' do
        end # describe 'Data nodes representing state data will be part of the reply to a <get>, but not to a <get-config> request, and cannot be sent in a <copy-config> or <edit-config> request'

        end # describe 'If "config" is "false", the definition represents state data'

        describe 'If "config" is not specified, the default is the same as the parent schema node’s "config" value' do
        end # describe 'If "config" is not specified, the default is the same as the parent schema node’s "config" value'

        describe 'If the parent node is a "case" node, the value is the same as the "case" node\'s parent "choice" node' do
        end # describe 'If the parent node is a "case" node, the value is the same as the "case" node\'s parent "choice" node'

        describe 'If the top node does not specify a "config" statement, the default is "true"' do
        end # describe 'If the top node does not specify a "config" statement, the default is "true"'

        describe 'If a node has "config" set to "false", no node underneath it can have "config" set to "true"' do
        end # describe 'If a node has "config" set to "false", no node underneath it can have "config" set to "true"'

      end # describe '7.19.1. The config Statement'

      # TODO
      describe '7.19.2. The status Statement' do

        describe 'The "status" statement takes as an argument one of the strings "current", "deprecated", or "obsolete"' do
        end # describe 'The "status" statement takes as an argument one of the strings "current", "deprecated", or "obsolete"'

        describe '"current" means that the definition is current and valid' do
        end # describe '"current" means that the definition is current and valid'

        describe '"deprecated" indicates an obsolete definition, but it permits new/ continued implementation in order to foster interoperability with older/existing implementations' do
        end # describe '"deprecated" indicates an obsolete definition, but it permits new/ continued implementation in order to foster interoperability with older/existing implementations'

        describe '"obsolete" means the definition is obsolete and SHOULD NOT be implemented and/or can be removed from implementations' do
        end # describe '"obsolete" means the definition is obsolete and SHOULD NOT be implemented and/or can be removed from implementations'

        describe 'If no status is specified, the default is "current"' do
        end # describe 'If no status is specified, the default is "current"'

        describe 'If a definition is "current", it MUST NOT reference a "deprecated" or "obsolete" definition within the same module' do
        end # describe 'If a definition is "current", it MUST NOT reference a "deprecated" or "obsolete" definition within the same module'

        describe 'If a definition is "deprecated", it MUST NOT reference an "obsolete" definition within the same module' do
        end # describe 'If a definition is "deprecated", it MUST NOT reference an "obsolete" definition within the same module'

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

        describe 'The "description" statement takes as an argument a string that contains a human-readable textual description of this definition' do
        end # describe 'The "description" statement takes as an argument a string that contains a human-readable textual description of this definition'

      end # describe '7.19.3. The description Statement'

      # TODO
      describe '7.19.4. The reference Statement' do

        describe 'The "reference" statement takes as an argument a string that is used to specify a textual cross-reference to an external document, either another module that defines related management information, or a document that provides additional information relevant to this definition' do
        end # describe 'The "reference" statement takes as an argument a string that is used to specify a textual cross-reference to an external document, either another module that defines related management information, or a document that provides additional information relevant to this definition'

      <<-EOB
   For example, a typedef for a "uri" data type could look like:
     typedef uri {
       type string;
       reference
   "RFC 3986: Uniform Resource Identifier (URI): Generic Syntax";
       ...
     }
      EOB

      end # describe '7.19.4. The reference Statement'

      # TODO
      describe '7.19.5. The when Statement' do

        describe 'If the "when" statement is a child of an "augment" statement, then the context node is the augment’s target node in the data tree, if the target node is a data node.  Otherwise, the context node is the closest ancestor node to the target node that is also a data node' do
        end # describe 'If the "when" statement is a child of an "augment" statement, then the context node is the augment’s target node in the data tree, if the target node is a data node.  Otherwise, the context node is the closest ancestor node to the target node that is also a data node'

        describe 'If the "when" statement is a child of a "uses", "choice", or "case" statement, then the context node is the closest ancestor node to the "uses", "choice", or "case" node that is also a data node' do
        end # describe 'If the "when" statement is a child of a "uses", "choice", or "case" statement, then the context node is the closest ancestor node to the "uses", "choice", or "case" node that is also a data node'

        describe 'If the "when" statement is a child of any other data definition statement, the context node is the data definition’s node in the data tree' do
        end # describe 'If the "when" statement is a child of any other data definition statement, the context node is the data definition’s node in the data tree'

        describe 'The accessible tree is made up of all nodes in the data tree, and all leafs with default values in use' do
        end # describe 'The accessible tree is made up of all nodes in the data tree, and all leafs with default values in use'

        describe 'If the context node represents configuration, the tree is the data in the NETCONF datastore where the context node exists.  The XPath root node has all top-level configuration data nodes in all modules as children' do
        end # describe 'If the context node represents configuration, the tree is the data in the NETCONF datastore where the context node exists.  The XPath root node has all top-level configuration data nodes in all modules as children'

        describe 'If the context node represents state data, the tree is all state data on the device, and the <running/> datastore.  The XPath root node has all top-level data nodes in all modules as children' do
        end # describe 'If the context node represents state data, the tree is all state data on the device, and the <running/> datastore.  The XPath root node has all top-level data nodes in all modules as children'

        describe 'If the context node represents notification content, the tree is the notification XML instance document.  The XPath root node has the element representing the notification being defined as the only child' do
        end # describe 'If the context node represents notification content, the tree is the notification XML instance document.  The XPath root node has the element representing the notification being defined as the only child'

        describe 'If the context node represents RPC input parameters, the tree is the RPC XML instance document.  The XPath root node has the element representing the RPC operation being defined as the only child' do
        end # describe 'If the context node represents RPC input parameters, the tree is the RPC XML instance document.  The XPath root node has the element representing the RPC operation being defined as the only child'

        describe 'If the context node represents RPC output parameters, the tree is the RPC reply instance document.  The XPath root node has the elements representing the RPC output parameters as children' do
        end # describe 'If the context node represents RPC output parameters, the tree is the RPC reply instance document.  The XPath root node has the elements representing the RPC output parameters as children'

        describe 'The result of the XPath expression is converted to a boolean value using the standard XPath rules' do
        end # describe 'The result of the XPath expression is converted to a boolean value using the standard XPath rules'

      end # describe '7.19.5. The when Statement'

    end # describe '7.19. Common Statements'

  end # describe '7. YANG Statements'

  # TODO
  describe '8. Constraints' do

    # TODO
    describe '8.1. Constraints on Data' do

      describe 'If the constraint is defined on configuration data, it MUST be true in a valid configuration data tree' do
      end # describe 'If the constraint is defined on configuration data, it MUST be true in a valid configuration data tree'

      describe 'If the constraint is defined on state data, it MUST be true in a reply to a <get> operation without a filter' do
      end # describe 'If the constraint is defined on state data, it MUST be true in a reply to a <get> operation without a filter'

      describe 'If the constraint is defined on notification content, it MUST be true in any notification instance' do
      end # describe 'If the constraint is defined on notification content, it MUST be true in any notification instance'

      describe 'If the constraint is defined on RPC input parameters, it MUST be true in an invocation of the RPC operation' do
      end # describe 'If the constraint is defined on RPC input parameters, it MUST be true in an invocation of the RPC operation'

      describe 'If the constraint is defined on RPC output parameters, it MUST be true in the RPC reply' do
      end # describe 'If the constraint is defined on RPC output parameters, it MUST be true in the RPC reply'

    end # describe '8.1. Constraints on Data'

    # TODO
    describe '8.2. Hierarchy of Constraints' do

      describe '"must", "mandatory", "min-elements", and "max-elements" constraints are not enforced if the parent node has a "when" or "if-feature" property that is not satisfied on the current device' do
      end # describe '"must", "mandatory", "min-elements", and "max-elements" constraints are not enforced if the parent node has a "when" or "if-feature" property that is not satisfied on the current device'

      describe ' In this example, the "mandatory" constraint on the "longitude" leaf are not enforced on devices that lack the "has-gps" feature:' do

        <<-EOB
        container location {
                   if-feature has-gps;
                        leaf longitude {
                                   mandatory true;
                       ... }
                              }
        EOB

      end # describe ' In this example, the "mandatory" constraint on the "longitude" leaf are not enforced on devices that lack the "has-gps" feature:'

    end # describe '8.2. Hierarchy of Constraints'

    # TODO
    describe '8.3. Constraint Enforcement Model' do

      describe 'For configuration data, there are three windows when constraints MUST be enforced:' do

        describe 'during parsing of RPC payloads' do
        end # describe 'during parsing of RPC payloads'

        describe 'during processing of NETCONF operations' do
        end # describe 'during processing of NETCONF operations'

        describe 'during validation' do
        end # describe 'during validation'

      end # describe 'For configuration data, there are three windows when constraints MUST be enforced:'

    end # describe '8.3. Constraint Enforcement Model'

    # TODO
    describe '8.3.1. Payload Parsing' do

      describe 'When content arrives in RPC payloads, it MUST be well-formed XML, following the hierarchy and content rules defined by the set of models the device implements' do

      describe 'If a leaf data value does not match the type constraints for the leaf, including those defined in the type’s "range", "length", and "pattern" properties, the server MUST reply with an "invalid-value" error-tag in the rpc-error, and with the error- app-tag and error-message associated with the constraint, if any exist' do
      end # describe 'If a leaf data value does not match the type constraints for the leaf, including those defined in the type’s "range", "length", and "pattern" properties, the server MUST reply with an "invalid-value" error-tag in the rpc-error, and with the error- app-tag and error-message associated with the constraint, if any exist'

      describe 'If all keys of a list entry are not present, the server MUST reply with a "missing-element" error-tag in the rpc-error' do
      end # describe 'If all keys of a list entry are not present, the server MUST reply with a "missing-element" error-tag in the rpc-error'

      describe 'If data for more than one case branch of a choice is present, the server MUST reply with a "bad-element" in the rpc-error' do
      end # describe 'If data for more than one case branch of a choice is present, the server MUST reply with a "bad-element" in the rpc-error'

      describe 'If data for a node tagged with "if-feature" is present, and the feature is not supported by the device, the server MUST reply with an "unknown-element" error-tag in the rpc-error' do
      end # describe 'If data for a node tagged with "if-feature" is present, and the feature is not supported by the device, the server MUST reply with an "unknown-element" error-tag in the rpc-error'

      describe 'If data for a node tagged with "when" is present, and the "when" condition evaluates to "false", the server MUST reply with an "unknown-element" error-tag in the rpc-error' do
      end # describe 'If data for a node tagged with "when" is present, and the "when" condition evaluates to "false", the server MUST reply with an "unknown-element" error-tag in the rpc-error'

      describe 'For insert handling, if the value for the attributes "before" and "after" are not valid for the type of the appropriate key leafs, the server MUST reply with a "bad-attribute" error-tag in the rpc- error' do
      end # describe 'For insert handling, if the value for the attributes "before" and "after" are not valid for the type of the appropriate key leafs, the server MUST reply with a "bad-attribute" error-tag in the rpc- error'

      describe 'If the attributes "before" and "after" appears in any element that is not a list whose "ordered-by" property is "user", the server MUST reply with an "unknown-attribute" error-tag in the rpc-error' do
      end # describe 'If the attributes "before" and "after" appears in any element that is not a list whose "ordered-by" property is "user", the server MUST reply with an "unknown-attribute" error-tag in the rpc-error'

      end # describe 'When content arrives in RPC payloads, it MUST be well-formed XML, following the hierarchy and content rules defined by the set of models the device implements'

    end # describe '8.3.1. Payload Parsing'

    # TODO
    describe '8.3.2. NETCONF <edit-config> Processing' do

      describe 'During this processing, the following errors MUST be detected:' do

        describe 'Delete requests for non-existent data' do
        end # describe 'Delete requests for non-existent data'

        describe 'Create requests for existent data' do
        end # describe 'Create requests for existent data'

        describe 'Insert requests with "before" or "after" parameters that do not exist' do
        end # describe 'Insert requests with "before" or "after" parameters that do not exist'

      end # describe 'During this processing, the following errors MUST be detected:'

      describe 'During <edit-config> processing:' do

        describe 'If the NETCONF operation creates data nodes under a "choice", any existing nodes from other "case" branches are deleted by the server' do
        end # describe 'If the NETCONF operation creates data nodes under a "choice", any existing nodes from other "case" branches are deleted by the server'

        describe 'If the NETCONF operation modifies a data node such that any node’s "when" expression becomes false, then the node with the "when" expression is deleted by the server' do
        end # describe 'If the NETCONF operation modifies a data node such that any node’s "when" expression becomes false, then the node with the "when" expression is deleted by the server'

      end # describe 'During <edit-config> processing:'

    end # describe '8.3.2. NETCONF <edit-config> Processing'

    # TODO
    describe '8.3.3. Validation' do

      describe 'If the datastore is <running/> or <startup/>, these constraints MUST be enforced at the end of the <edit-config> or <copy-config> operation' do
      end # describe 'If the datastore is <running/> or <startup/>, these constraints MUST be enforced at the end of the <edit-config> or <copy-config> operation'

      describe 'If the datastore is <candidate/>, the constraint enforcement is delayed until a <commit> or <validate> operation' do
      end # describe 'If the datastore is <candidate/>, the constraint enforcement is delayed until a <commit> or <validate> operation'

      describe 'Any "must" constraints MUST evaluate to "true"' do
      end # describe 'Any "must" constraints MUST evaluate to "true"'

      describe 'Any referential integrity constraints defined via the "path" statement MUST be satisfied' do
      end # describe 'Any referential integrity constraints defined via the "path" statement MUST be satisfied'

      describe 'Any "unique" constraints on lists MUST be satisfied' do
      end # describe 'Any "unique" constraints on lists MUST be satisfied'

      describe 'The "min-elements" and "max-elements" constraints are enforced for lists and leaf-lists' do
      end # describe 'The "min-elements" and "max-elements" constraints are enforced for lists and leaf-lists'

    end # describe '8.3.3. Validation'

  end # describe '8. Constraints'

  # TODO
  describe '9. Built-In Types' do

    # TODO
    describe '9.1. Canonical Representation' do
    end # describe '9.1. Canonical Representation'

    # TODO
    describe '9.2. The Integer Built-In Types' do

      <<-EOB
   int8  represents integer values between -128 and 127, inclusively.
   int16  represents integer values between -32768 and 32767, inclusively.
   int32  represents integer values between -2147483648 and 2147483647, inclusively.
   int64  represents integer values between -9223372036854775808 and 9223372036854775807, inclusively.
   uint8  represents integer values between 0 and 255, inclusively.
   uint16  represents integer values between 0 and 65535, inclusively.
   uint32  represents integer values between 0 and 4294967295, inclusively.
   uint64  represents integer values between 0 and 18446744073709551615, inclusively.
      EOB

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

    end # describe '9.2. The Integer Built-In Types'

    # TODO
    describe '9.2.1.  Lexical Representation' do

      <<-EOB
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
      EOB
    end # describe '9.2.1.  Lexical Representation'

    # TODO
    describe '9.2.1. Lexical Representation' do
    end # describe '9.2.1. Lexical Representation'

    # TODO
    describe '9.2.2. Canonical Form' do
    end # describe '9.2.2. Canonical Form'

    # TODO
    describe '9.2.3. Restrictions' do
    end # describe '9.2.3. Restrictions'

    # TODO
    describe '9.2.4. The range Statement' do
    end # describe '9.2.4. The range Statement'

    # TODO
    describe '9.2.4.1.  The range\'s Substatements' do

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # description 'description'

      describe 'error-app-tag' do
        '0..1'

        context '0 error-app-tag' do
        end

        context '1 error-app-tag' do
        end

        context '2 error-app-tags' do
        end

      end # description 'error-app-tag'

      describe 'error-message' do
        '0..1'

        context '0 error-message' do
        end

        context '1 error-message' do
        end

        context '2 error-messages' do
        end

      end # description 'error-message'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # description 'reference'

    end # describe '9.2.4.1.  The range\'s Substatements'

    # TODO
    describe '9.2.5. Usage Example' do

      <<-EOB
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
      EOB
    end # describe '9.2.5. Usage Example'

    # TODO
    describe '9.3. The decimal64 Built-In Type' do
    end # describe '9.3. The decimal64 Built-In Type'

    # TODO
    describe '9.3.1. Lexical Representation' do
    end # describe '9.3.1. Lexical Representation'

    # TODO
    describe '9.3.2. Canonical Form' do
    end # describe '9.3.2. Canonical Form'

    # TODO
    describe '9.3.3. Restrictions' do
    end # describe '9.3.3. Restrictions'

    # TODO
    describe '9.3.4. The fraction-digits Statement' do

      <<-EOB
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
      EOB
    end # describe '9.3.4. The fraction-digits Statement'

    # TODO
    describe '9.3.5. Usage Example' do

      <<-EOB
     typedef my-decimal {
   type decimal64 {
       fraction-digits 2;
       range "1 .. 3.14 | 10 | 20..max";
   }
     }
      EOB

    end # describe '9.3.5. Usage Example'

    # TODO
    describe '9.4. The string Built-In Type' do
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
    end # describe '9.4. The string Built-In Type'

    # TODO
    describe '9.4.1. Lexical Representation' do
    end # describe '9.4.1. Lexical Representation'

    # TODO
    describe '9.4.2. Canonical Form' do
    end # describe '9.4.2. Canonical Form'

    # TODO
    describe '9.4.3. Restrictions' do
    end # describe '9.4.3. Restrictions'

    # TODO
    describe '9.4.4. The length Statement' do
    end # describe '9.4.4. The length Statement'

    # TODO
    describe '9.4.4.1.  The length\'s Substatements' do

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # describe 'description'

      describe 'error-app-tag' do
        '0..1'

        context '0 error-app-tag' do
        end

        context '1 error-app-tag' do
        end

        context '2 error-app-tags' do
        end

      end # describe 'error-app-tag'

      describe 'error-message' do
        '0..1'

        context '0 error-message' do
        end

        context '1 error-message' do
        end

        context '2 error-messages' do
        end

      end # describe 'error-message'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # describe 'reference'

    end # describe '9.4.4.1.  The length\'s Substatements'

    # TODO
    describe '9.4.5. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.4.5. Usage Example'

    # TODO
    describe '9.4.6. The pattern Statement' do
    end # describe '9.4.6. The pattern Statement'

    # TODO
    describe '9.4.6.1.  The pattern\'s Substatements' do

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # describe 'description'

      describe 'error-app-tag' do
        '0..1'

        context '0 error-app-tag' do
        end

        context '1 error-app-tag' do
        end

        context '2 error-app-tags' do
        end

      end # describe 'error-app-tag'

      describe 'error-message' do
        '0..1'

        context '0 error-message' do
        end

        context '1 error-message' do
        end

        context '2 error-messages' do
        end

      end # describe 'error-message'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # describe 'reference'

    end # describe '9.4.6.1.  The pattern\'s Substatements'

    # TODO
    describe '9.4.7. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.4.7. Usage Example'

    # TODO
    describe '9.5. The boolean Built-In Type' do
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
    end # describe '9.5. The boolean Built-In Type'

    # TODO
    describe '9.5.1. Lexical Representation' do
    end # describe '9.5.1. Lexical Representation'

    # TODO
    describe '9.5.2. Canonical Form' do
    end # describe '9.5.2. Canonical Form'

    # TODO
    describe '9.5.3. Restrictions' do
    end # describe '9.5.3. Restrictions'

    # TODO
    describe '9.6. The enumeration Built-In Type' do
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
    end # describe '9.6. The enumeration Built-In Type'

    # TODO
    describe '9.6.1. Lexical Representation' do
    end # describe '9.6.1. Lexical Representation'

    # TODO
    describe '9.6.2. Canonical Form' do
    end # describe '9.6.2. Canonical Form'

    # TODO
    describe '9.6.3. Restrictions' do
    end # describe '9.6.3. Restrictions'

    # TODO
    describe '9.6.4. The enum Statement' do
    end # describe '9.6.4. The enum Statement'

    # TODO
    describe '9.6.4.1.  The enum\'s Substatements' do

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # describe 'description'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # describe 'reference'

      describe 'status' do
        '0..1'

        context '0 status' do
        end

        context '1 status' do
        end

        context '2 statuss' do
        end

      end # describe 'status'

      describe 'value' do
        '0..1'

        context '0 value' do
        end

        context '1 value' do
        end

        context '2 values' do
        end

      end # describe 'value'

    end # describe '9.6.4.1.  The enum\'s Substatements'

    # TODO
    describe '9.6.4.2. The value Statement' do
    end # describe '9.6.4.2. The value Statement'

    # TODO
    describe '9.6.5. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.6.5. Usage Example'

    # TODO
    describe '9.7. The bits Built-In Type' do
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
    end # describe '9.7. The bits Built-In Type'

    # TODO
    describe '9.7.1. Restrictions' do
    end # describe '9.7.1. Restrictions'

    # TODO
    describe '9.7.2. Lexical Representation' do
    end # describe '9.7.2. Lexical Representation'

    # TODO
    describe '9.7.3. Canonical Form' do
    end # describe '9.7.3. Canonical Form'

    # TODO
    describe '9.7.4. The bit Statement' do
    end # describe '9.7.4. The bit Statement'

    # TODO
    describe '9.7.4.1. The bit\'s Substatements' do

      describe 'description' do
        '0..1'

        context '0 description' do
        end

        context '1 description' do
        end

        context '2 descriptions' do
        end

      end # describe 'description'

      describe 'reference' do
        '0..1'

        context '0 reference' do
        end

        context '1 reference' do
        end

        context '2 references' do
        end

      end # describe 'reference'

      describe 'status' do
        '0..1'

        context '0 status' do
        end

        context '1 status' do
        end

        context '2 statuss' do
        end

      end # describe 'status'

      describe 'position' do
        '0..1'

        context '0 position' do
        end

        context '1 position' do
        end

        context '2 positions' do
        end

      end # describe 'position'

    end # describe '9.7.4.1. The bit\'s Substatements'

    # TODO
    describe '9.7.4.2.  The position Statement' do
    end # describe '9.7.4.2.  The position Statement'

    # TODO
    describe '9.7.5. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.7.5. Usage Example'

    # TODO
    describe '9.8. The binary Built-In Type' do
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
    end # describe '9.8. The binary Built-In Type'

    # TODO
    describe '9.8.1. Restrictions' do
    end # describe '9.8.1. Restrictions'

    # TODO
    describe '9.8.2. Lexical Representation' do
    end # describe '9.8.2. Lexical Representation'

    # TODO
    describe '9.8.3. Canonical Form' do
    end # describe '9.8.3. Canonical Form'

    # TODO
    describe '9.9. The leafref Built-In Type' do
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
    end # describe '9.9. The leafref Built-In Type'

    # TODO
    describe '9.9.1. Restrictions' do
    end # describe '9.9.1. Restrictions'

    # TODO
    describe '9.9.2. The path Statement' do
    end # describe '9.9.2. The path Statement'

    # TODO
    describe '9.9.3. Lexical Representation' do
    end # describe '9.9.3. Lexical Representation'

    # TODO
    describe '9.9.4. Canonical Form' do
    end # describe '9.9.4. Canonical Form'

    # TODO
    describe '9.9.5. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.9.5. Usage Example'

    # TODO
    describe '9.10. The identityref Built-In Type' do
    end # describe '9.10. The identityref Built-In Type'

    # TODO
    describe '9.10.1. Restrictions' do
    end # describe '9.10.1. Restrictions'

    # TODO
    describe '9.10.2. The identityref\'s base Statement' do
    end # describe '9.10.2. The identityref\'s base Statement'

    # TODO
    describe '9.10.3. Lexical Representation' do
    end # describe '9.10.3. Lexical Representation'

    # TODO
    describe '9.10.4. Canonical Form' do
    end # describe '9.10.4. Canonical Form'

    # TODO
    describe '9.10.5. Usage Example' do

      <<-EOB
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
      EOB

    end # describe '9.10.5. Usage Example'

    # TODO
    describe '9.11. The empty Built-In Type' do
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
    end # describe '9.11. The empty Built-In Type'

    # TODO
    describe '9.11.1. Restrictions' do
    end # describe '9.11.1. Restrictions'

    # TODO
    describe '9.11.2. Lexical Representation' do
    end # describe '9.11.2. Lexical Representation'

    # TODO
    describe '9.11.3. Canonical Form' do
    end # describe '9.11.3. Canonical Form'

    # TODO
    describe '9.11.4. Usage Example' do

      <<-EOB
   The following leaf
     leaf enable-qos {
   type empty;
     }
   will be encoded as
     <enable-qos/>
   if it exists.
      EOB

    end # describe '9.11.4. Usage Example'

    # TODO
    describe '9.12. The union Built-In Type' do

      <<-EOB
   Example:
     type union {
   type int32;
   type enumeration {
       enum "unbounded";
   }
     }
      EOB

    end # describe '9.12. The union Built-In Type'

    # TODO
    describe '9.12.1. Restrictions' do
    end # describe '9.12.1. Restrictions'

    # TODO
    describe '9.12.2. Lexical Representation' do
    end # describe '9.12.2. Lexical Representation'

    # TODO
    describe '9.12.3. Canonical Form' do
    end # describe '9.12.3. Canonical Form'

    # TODO
    describe '9.13. The instance-identifier Built-In Type' do
    end # describe '9.13. The instance-identifier Built-In Type'

    # TODO
    describe '9.13.1. Restrictions' do
    end # describe '9.13.1. Restrictions'

    # TODO
    describe '9.13.2. The require-instance Statement' do
    end # describe '9.13.2. The require-instance Statement'

    # TODO
    describe '9.13.3. Lexical Representation' do
    end # describe '9.13.3. Lexical Representation'

    # TODO
    describe '9.13.4. Canonical Form' do
    end # describe '9.13.4. Canonical Form'

    # TODO
    describe '9.13.5. Usage Example' do

      <<-EOB
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
      EOB
    end # describe '9.13.5. Usage Example'
  end # describe '9. Built-In Types'
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
