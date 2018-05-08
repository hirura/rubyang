# coding: utf-8
# vim: et ts=2 sw=2

RSpec.describe Rubyang::Database::ModuleDependencyTree do
  describe '#new' do
    it "does not take any args" do
      expect { described_class.new }.not_to raise_error
    end

    it "raises error when there are arguments" do
      expect { described_class.new 'dummy' }.to raise_error ArgumentError
    end
  end

  describe '#register' do
    let( :module_dependency_tree ){ described_class.new }
    let( :yang_str1 ){
      <<-EOB
        module module1 {
          namespace "http://module1";
          prefix module1;
        }
      EOB
    }
    context "with valid argument" do
      it "does not raise error" do
        module_dependency_tree.register Rubyang::Model::Parser.parse( yang_str1 )
      end
    end
  end

  describe '#list_loadable' do
    let( :yang_str_list ){
      [
        yang_str1,
        yang_str2,
        yang_str3,
        yang_str4,
        yang_str5,
      ]
    }
    let( :yang_str1 ){
      <<-EOB
        module m1 {
          namespace "http://m1";
          prefix m1;
          import m2 { prefix "m2"; }
          import m3 { prefix "m3"; }
        }
      EOB
    }
    let( :yang_str2 ){
      <<-EOB
        module m2 {
          namespace "http://m2";
          prefix m2;
          import m3 { prefix "m3"; }
        }
      EOB
    }
    let( :yang_str3 ){
      <<-EOB
        module m3 {
          namespace "http://m3";
          prefix m3;
          import m4 { prefix "m4"; }
          include sm5;
        }
      EOB
    }
    let( :yang_str4 ){
      <<-EOB
        module m4 {
          namespace "http://m4";
          prefix m4;
          import m6 { prefix "m6"; }
        }
      EOB
    }
    let( :yang_str5 ){
      <<-EOB
        submodule sm5 {
          belongs-to m4 { prefix m4; }
          import m4 { prefix "m4"; }
        }
      EOB
    }
    it "sorts list in loadable order" do
      yang_str_list.permutation.each.with_index{ |_yang_str_list, idx|
        module_dependency_tree = described_class.new
        _yang_str_list.each{ |yang_str|
          module_dependency_tree.register Rubyang::Model::Parser.parse( yang_str )
        }
        expect(module_dependency_tree.list_loadable.map{|y| y.arg}).to eq ["m4", "sm5", "m3", "m2", "m1"]
      }
    end
  end
end
