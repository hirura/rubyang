# coding: utf-8
# vim: et ts=2 sw=2

require 'yaml'

RSpec.describe Rubyang::Model do
  let( :stmt_tree_yaml )        { stmt_tree.to_yaml }

  let( :module1_stmt )          { Rubyang::Model::Module.new( 'module1', module1_substmts ) }
  let( :submodule1_stmt )       { Rubyang::Model::Submodule.new( 'submodule1', submodule1_substmts ) }
  let( :namespace_stmt )        { Rubyang::Model::Namespace.new( 'http://module1.rspec/' ) }
  let( :prefix_stmt )           { Rubyang::Model::Prefix.new( 'module1' ) }
  let( :yang_version_stmt )     { Rubyang::Model::YangVersion.new( '1' ) }
  let( :belongs_to_stmt )       { Rubyang::Model::BelongsTo.new( 'module1', belongs_to_substmts ) }
  let( :import1_stmt )          { Rubyang::Model::Import.new( 'module2', import1_substmts ) }
  let( :import2_stmt )          { Rubyang::Model::Import.new( 'module3', import2_substmts ) }
  let( :revision_date1_stmt )   { Rubyang::Model::RevisionDate.new( '1234-12-23' ) }
  let( :revision_date2_stmt )   { Rubyang::Model::RevisionDate.new( '1234-12-24' ) }
  let( :include1_stmt )         { Rubyang::Model::Include.new( 'submodule1', include1_substmts ) }
  let( :include2_stmt )         { Rubyang::Model::Include.new( 'submodule2', include2_substmts ) }
  let( :prefix1_stmt )          { Rubyang::Model::Prefix.new( 'prefix1' ) }
  let( :prefix2_stmt )          { Rubyang::Model::Prefix.new( 'prefix2' ) }
  let( :organization1_stmt )    { Rubyang::Model::Organization.new( 'organization1' ) }
  let( :contact1_stmt )         { Rubyang::Model::Contact.new( 'contact1' ) }
  let( :description1_stmt )     { Rubyang::Model::Description.new( 'description1' ) }
  let( :reference1_stmt )       { Rubyang::Model::Reference.new( 'reference1' ) }
  let( :units1_stmt )           { Rubyang::Model::Units.new( 'units1' ) }
  let( :default1_stmt )         { Rubyang::Model::Default.new( 'default1' ) }
  let( :default2_stmt )         { Rubyang::Model::Default.new( 'default2' ) }
  let( :revision1_stmt )        { Rubyang::Model::Revision.new( '1234-12-23', revision1_substmts ) }
  let( :revision2_stmt )        { Rubyang::Model::Revision.new( '1234-12-24', revision2_substmts ) }
  let( :extension1_stmt )       { Rubyang::Model::Extension.new( 'extension1', extension1_substmts ) }
  let( :extension2_stmt )       { Rubyang::Model::Extension.new( 'extension2', extension2_substmts ) }
  let( :argument1_stmt )        { Rubyang::Model::Argument.new( 'argument1', argument1_substmts ) }
  let( :argument2_stmt )        { Rubyang::Model::Argument.new( 'argument2', argument2_substmts ) }
  let( :yin_element_true_stmt ) { Rubyang::Model::YinElement.new( 'true' ) }
  let( :yin_element_false_stmt ){ Rubyang::Model::YinElement.new( 'false' ) }
  let( :status_current_stmt )   { Rubyang::Model::Status.new( 'current' ) }
  let( :status_obsolete_stmt )  { Rubyang::Model::Status.new( 'obsolete' ) }
  let( :status_deprecated_stmt ){ Rubyang::Model::Status.new( 'deprecated' ) }
  let( :feature1_stmt )         { Rubyang::Model::Feature.new( 'feature1', feature1_substmts ) }
  let( :feature2_stmt )         { Rubyang::Model::Feature.new( 'feature2', feature2_substmts ) }
  let( :if_feature1_stmt )      { Rubyang::Model::IfFeature.new( 'if-feature1' ) }
  let( :if_feature2_stmt )      { Rubyang::Model::IfFeature.new( 'if-feature2' ) }
  let( :identity1_stmt )        { Rubyang::Model::Identity.new( 'identity1', identity1_substmts ) }
  let( :identity2_stmt )        { Rubyang::Model::Identity.new( 'identity2', identity2_substmts ) }
  let( :base1_stmt )            { Rubyang::Model::Base.new( 'base1', base1_substmts ) }
  let( :base2_stmt )            { Rubyang::Model::Base.new( 'base2', base2_substmts ) }
  let( :typedef1_stmt )         { Rubyang::Model::Typedef.new( 'typedef1', typedef1_substmts ) }
  let( :typedef2_stmt )         { Rubyang::Model::Typedef.new( 'typedef2', typedef2_substmts ) }
  let( :grouping1_stmt )        { Rubyang::Model::Grouping.new( 'grouping1', grouping1_substmts ) }
  let( :grouping2_stmt )        { Rubyang::Model::Grouping.new( 'grouping2', grouping2_substmts ) }
  let( :grouping3_stmt )        { Rubyang::Model::Grouping.new( 'grouping3', grouping3_substmts ) }
  let( :container1_stmt )       { Rubyang::Model::Container.new( 'container1', container1_substmts ) }
  let( :container2_stmt )       { Rubyang::Model::Container.new( 'container2', container2_substmts ) }
  let( :leaf1_stmt )            { Rubyang::Model::Leaf.new( 'leaf1', leaf1_substmts ) }
  let( :leaf2_stmt )            { Rubyang::Model::Leaf.new( 'leaf2', leaf2_substmts ) }
  let( :leaf_list1_stmt )       { Rubyang::Model::LeafList.new( 'leaf-list1', leaf_list1_substmts ) }
  let( :leaf_list2_stmt )       { Rubyang::Model::LeafList.new( 'leaf_list2', leaf_list2_substmts ) }
  let( :list1_stmt )            { Rubyang::Model::List.new( 'list1', list1_substmts ) }
  let( :list2_stmt )            { Rubyang::Model::List.new( 'list2', list2_substmts ) }
  let( :choice1_stmt )          { Rubyang::Model::Choice.new( 'choice1', choice1_substmts ) }
  let( :choice2_stmt )          { Rubyang::Model::Choice.new( 'choice2', choice2_substmts ) }
  let( :case1_stmt )            { Rubyang::Model::Case.new( 'case1', case1_substmts ) }
  let( :case2_stmt )            { Rubyang::Model::Case.new( 'case2', case2_substmts ) }
  let( :anyxml1_stmt )          { Rubyang::Model::Anyxml.new( 'anyxml1', anyxml1_substmts ) }
  let( :anyxml2_stmt )          { Rubyang::Model::Anyxml.new( 'anyxml2', anyxml2_substmts ) }
  let( :uses1_stmt )            { Rubyang::Model::Uses.new( 'uses1', uses1_substmts ) }
  let( :key_leaf1_stmt )        { Rubyang::Model::Key.new( 'leaf1' ) }
  let( :type_binary_stmt )      { Rubyang::Model::Type.new( 'binary', type_binary_substmts ) }
  let( :type_bits_stmt )        { Rubyang::Model::Type.new( 'bits', type_bits_substmts ) }
  let( :type_boolean_stmt )     { Rubyang::Model::Type.new( 'boolean', type_boolean_substmts ) }
  let( :type_decimal64_stmt )   { Rubyang::Model::Type.new( 'decimal64', type_decimal64_substmts ) }
  let( :type_empty_stmt )       { Rubyang::Model::Type.new( 'empty', type_empty_substmts ) }
  let( :type_enumeration_stmt ) { Rubyang::Model::Type.new( 'enumeration', type_enumeration_substmts ) }
  let( :type_identityref_stmt ) { Rubyang::Model::Type.new( 'identityref', type_identityref_substmts ) }
  let( :type_instance_identifier_stmt ){ Rubyang::Model::Type.new( 'instance-identifier', type_instance_identifier_substmts ) }
  let( :type_int8_stmt )        { Rubyang::Model::Type.new( 'int8', type_int8_substmts ) }
  let( :type_int16_stmt )       { Rubyang::Model::Type.new( 'int16', type_int16_substmts ) }
  let( :type_int32_stmt )       { Rubyang::Model::Type.new( 'int32', type_int32_substmts ) }
  let( :type_int64_stmt )       { Rubyang::Model::Type.new( 'int64', type_int64_substmts ) }
  let( :type_leafref_stmt )     { Rubyang::Model::Type.new( 'leafref', type_leafref_substmts ) }
  let( :type_string_stmt )      { Rubyang::Model::Type.new( 'string', type_string_substmts ) }
  let( :type_uint8_stmt )       { Rubyang::Model::Type.new( 'uint8', type_uint8_substmts ) }
  let( :type_uint16_stmt )      { Rubyang::Model::Type.new( 'uint16', type_uint16_substmts ) }
  let( :type_uint32_stmt )      { Rubyang::Model::Type.new( 'uint32', type_uint32_substmts ) }
  let( :type_uint64_stmt )      { Rubyang::Model::Type.new( 'uint64', type_uint64_substmts ) }
  let( :type_decimal64_stmt )   { Rubyang::Model::Type.new( 'decimal64', type_decimal64_substmts ) }
  let( :type_union_stmt )       { Rubyang::Model::Type.new( 'union', type_union_substmts ) }
  let( :type_derived_type_stmt ){ Rubyang::Model::Type.new( 'derived-type', type_derived_type_substmts ) }
  let( :range1_stmt )           { Rubyang::Model::Range.new( '1', range1_substmts ) }
  let( :fraction_digits1_stmt ) { Rubyang::Model::FractionDigits.new( '1' ) }
  let( :length1_stmt )          { Rubyang::Model::Length.new( '1', length1_substmts ) }
  let( :length2_stmt )          { Rubyang::Model::Length.new( '2', length2_substmts ) }
  let( :pattern1_stmt )         { Rubyang::Model::Pattern.new( '1', pattern1_substmts ) }
  let( :pattern2_stmt )         { Rubyang::Model::Pattern.new( '2', pattern2_substmts ) }
  let( :enum1_stmt )            { Rubyang::Model::Enum.new( 'enum1', enum1_substmts ) }
  let( :enum2_stmt )            { Rubyang::Model::Enum.new( 'enum2', enum2_substmts ) }
  let( :value1_stmt )            { Rubyang::Model::Value.new( '1' ) }
  let( :bit1_stmt )             { Rubyang::Model::Bit.new( 'bit1', bit1_substmts ) }
  let( :bit2_stmt )             { Rubyang::Model::Bit.new( 'bit2', bit2_substmts ) }
  let( :path1_stmt )            { Rubyang::Model::Path.new( '../path1', path1_substmts ) }
  let( :path2_stmt )            { Rubyang::Model::Path.new( '../path2', path2_substmts ) }
  let( :require_instance_true_stmt ){ Rubyang::Model::RequireInstance.new( 'true', require_instance_true_substmts ) }
  let( :require_instance_false_stmt ){ Rubyang::Model::RequireInstance.new( 'false', require_instance_false_substmts ) }
  let( :error_message1_stmt )   { Rubyang::Model::ErrorMessage.new( 'error-message1' ) }
  let( :error_app_tag1_stmt )   { Rubyang::Model::ErrorAppTag.new( 'error-app-tag1' ) }
  let( :position1_stmt )        { Rubyang::Model::Position.new( '1' ) }
  let( :augment1_stmt )         { Rubyang::Model::Augment.new( '/augment1', augment1_substmts ) }
  let( :augment2_stmt )         { Rubyang::Model::Augment.new( '/augment2', augment2_substmts ) }
  let( :rpc1_stmt )             { Rubyang::Model::Rpc.new( 'rpc1', rpc1_substmts ) }
  let( :rpc2_stmt )             { Rubyang::Model::Rpc.new( 'rpc2', rpc2_substmts ) }
  let( :notification1_stmt )    { Rubyang::Model::Notification.new( 'notification1', notification1_substmts ) }
  let( :notification2_stmt )    { Rubyang::Model::Notification.new( 'notification2', notification2_substmts ) }
  let( :deviation1_stmt )       { Rubyang::Model::Deviation.new( '/deviation1', deviation1_substmts ) }
  let( :deviation2_stmt )       { Rubyang::Model::Deviation.new( '/deviation2', deviation2_substmts ) }
  let( :deviate_not_supported_stmt ){ Rubyang::Model::Deviate.new( 'not-supported' ) }
  let( :deviate_add1_stmt )     { Rubyang::Model::Deviate.new( 'add', deviate_add1_substmts ) }
  let( :deviate_add2_stmt )     { Rubyang::Model::Deviate.new( 'add', deviate_add2_substmts ) }
  let( :deviate_replace1_stmt ) { Rubyang::Model::Deviate.new( 'replace', deviate_replace1_substmts ) }
  let( :deviate_replace2_stmt ) { Rubyang::Model::Deviate.new( 'replace', deviate_replace2_substmts ) }
  let( :deviate_delete1_stmt )  { Rubyang::Model::Deviate.new( 'delete', deviate_delete1_substmts ) }
  let( :deviate_delete2_stmt )  { Rubyang::Model::Deviate.new( 'delete', deviate_delete2_substmts ) }
  let( :when1_stmt )            { Rubyang::Model::When.new( 'when1', when1_substmts ) }
  let( :when2_stmt )            { Rubyang::Model::When.new( 'when2', when2_substmts ) }
  let( :must1_stmt )            { Rubyang::Model::Must.new( 'must1' ) }
  let( :must2_stmt )            { Rubyang::Model::Must.new( 'must2' ) }
  let( :config_true_stmt )      { Rubyang::Model::Config.new( 'true' ) }
  let( :config_true_2_stmt )    { Rubyang::Model::Config.new( 'true' ) }
  let( :config_false_stmt )     { Rubyang::Model::Config.new( 'false' ) }
  let( :config_false_2_stmt )   { Rubyang::Model::Config.new( 'false' ) }
  let( :presence1_stmt )        { Rubyang::Model::Presence.new( 'presence1' ) }
  let( :presence2_stmt )        { Rubyang::Model::Presence.new( 'presence2' ) }
  let( :mandatory_true_stmt )   { Rubyang::Model::Mandatory.new( 'true' ) }
  let( :mandatory_false_stmt )  { Rubyang::Model::Mandatory.new( 'false' ) }
  let( :min_elements1_stmt )    { Rubyang::Model::MinElements.new( '1' ) }
  let( :max_elements1_stmt )    { Rubyang::Model::MaxElements.new( '1' ) }
  let( :ordered_by_user_stmt )  { Rubyang::Model::OrderedBy.new( 'user' ) }
  let( :ordered_by_system_stmt ){ Rubyang::Model::OrderedBy.new( 'system' ) }
  let( :unique1_stmt )          { Rubyang::Model::Unique.new( 'unique1' ) }
  let( :unique2_stmt )          { Rubyang::Model::Unique.new( 'unique2' ) }
  let( :refine1_stmt )          { Rubyang::Model::Refine.new( 'refine1', refine1_substmts ) }
  let( :refine2_stmt )          { Rubyang::Model::Refine.new( 'refine2', refine2_substmts ) }
  let( :uses_augment1_stmt )    { Rubyang::Model::Augment.new( 'uses/augment1', uses_augment1_substmts ) }
  let( :uses_augment2_stmt )    { Rubyang::Model::Augment.new( 'uses/augment2', uses_augment2_substmts ) }
  let( :input1_stmt )           { Rubyang::Model::Input.new( input1_substmts ) }
  let( :output1_stmt )          { Rubyang::Model::Output.new( output1_substmts ) }

  let( :module1_substmts )      { [] }
  let( :submodule1_substmts )   { [] }
  let( :belongs_to_substmts )   { [] }
  let( :import1_substmts )      { [] }
  let( :import2_substmts )      { [] }
  let( :revision1_substmts )    { [] }
  let( :revision2_substmts )    { [] }
  let( :include1_substmts )     { [] }
  let( :include2_substmts )     { [] }
  let( :extension1_substmts )   { [] }
  let( :extension2_substmts )   { [] }
  let( :argument1_substmts )    { [] }
  let( :argument2_substmts )    { [] }
  let( :feature1_substmts )     { [] }
  let( :feature2_substmts )     { [] }
  let( :identity1_substmts )    { [] }
  let( :identity2_substmts )    { [] }
  let( :typedef1_substmts )     { [] }
  let( :typedef2_substmts )     { [] }
  let( :grouping1_substmts )    { [] }
  let( :grouping2_substmts )    { [] }
  let( :grouping3_substmts )    { [] }
  let( :container1_substmts )   { [] }
  let( :container2_substmts )   { [] }
  let( :leaf1_substmts )        { [] }
  let( :leaf2_substmts )        { [] }
  let( :leaf_list1_substmts )   { [] }
  let( :leaf_list2_substmts )   { [] }
  let( :list1_substmts )        { [] }
  let( :list2_substmts )        { [] }
  let( :choice1_substmts )      { [] }
  let( :choice2_substmts )      { [] }
  let( :case1_substmts )        { [] }
  let( :case2_substmts )        { [] }
  let( :anyxml1_substmts )      { [] }
  let( :anyxml2_substmts )      { [] }
  let( :uses1_substmts )        { [] }
  let( :type_binary_substmts )  { [] }
  let( :type_bits_substmts )    { [] }
  let( :type_boolean_substmts ) { [] }
  let( :type_decimal64_substmts ){ [] }
  let( :type_empty_substmts )   { [] }
  let( :type_enumeration_substmts ){ [] }
  let( :type_identityref_substmts ){ [] }
  let( :type_instance_identifier_substmts ){ [] }
  let( :type_int8_substmts )    { [] }
  let( :type_int16_substmts )   { [] }
  let( :type_int32_substmts )   { [] }
  let( :type_int64_substmts )   { [] }
  let( :type_leafref_substmts ) { [] }
  let( :type_string_substmts )  { [] }
  let( :type_uint8_substmts )   { [] }
  let( :type_uint16_substmts )  { [] }
  let( :type_uint32_substmts )  { [] }
  let( :type_decimal64_substmts ){ [] }
  let( :type_uint64_substmts )  { [] }
  let( :type_union_substmts )   { [] }
  let( :type_derived_type_substmts ){ [] }
  let( :range1_substmts )       { [] }
  let( :length1_substmts )      { [] }
  let( :length2_substmts )      { [] }
  let( :pattern1_substmts )     { [] }
  let( :pattern2_substmts )     { [] }
  let( :enum1_substmts )        { [] }
  let( :enum2_substmts )        { [] }
  let( :bit1_substmts )         { [] }
  let( :bit2_substmts )         { [] }
  let( :path1_substmts )        { [] }
  let( :path2_substmts )        { [] }
  let( :require_instance_true_substmts ){ [] }
  let( :require_instance_false_substmts ){ [] }
  let( :base1_substmts )        { [] }
  let( :base2_substmts )        { [] }
  let( :augment1_substmts )     { [] }
  let( :augment2_substmts )     { [] }
  let( :rpc1_substmts )         { [] }
  let( :rpc2_substmts )         { [] }
  let( :notification1_substmts ){ [] }
  let( :notification2_substmts ){ [] }
  let( :deviation1_substmts )   { [] }
  let( :deviation2_substmts )   { [] }
  let( :deviate_add1_substmts ) { [] }
  let( :deviate_add2_substmts ) { [] }
  let( :deviate_replace1_substmts ){ [] }
  let( :deviate_replace2_substmts ){ [] }
  let( :deviate_delete1_substmts ){ [] }
  let( :deviate_delete2_substmts ){ [] }
  let( :when1_substmts )        { [] }
  let( :when2_substmts )        { [] }
  let( :refine1_substmts )      { [] }
  let( :refine2_substmts )      { [] }
  let( :uses_augment1_substmts ){ [] }
  let( :uses_augment2_substmts ){ [] }
  let( :input1_substmts )       { [] }
  let( :output1_substmts )      { [] }

  describe 'module-stmt' do
    context 'with module-header-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with linkage-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 { prefix prefix1; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt] }
      let( :import1_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with meta-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            organization organization1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, organization1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with revision-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with body-stmts' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'submodule-stmt' do
    context 'with submodule-header-stmts' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with linkage-stmts' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
            import module2 { prefix prefix2; }
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt, import1_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      let( :import1_substmts ){ [prefix2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with meta-stmts' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
            organization organization1;
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt, organization1_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with revision-stmts' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
            revision 1234-12-23;
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt, revision1_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with body-stmts' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
            container container1 {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt, container1_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      let( :container1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'module-header-stmts' do
    context 'without yang-version-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with yang-version-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            yang-version '1';
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, yang_version_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'submodule-header-stmts' do
    context 'without yang-version-stmt' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without yang-version-stmt' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
            yang-version '1';
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt, yang_version_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'meta-stmts' do
    context 'without any-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with organization-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            organization organization1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, organization1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with contact-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            contact contact1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, contact1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            description description1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            reference reference1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'linkage-stmts' do
    context 'without any-stmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with import-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 { prefix prefix1; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt] }
      let( :import1_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple import-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 { prefix prefix1; }
            import module3 { prefix prefix2; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt, import2_stmt] }
      let( :import1_substmts ){ [prefix1_stmt] }
      let( :import2_substmts ){ [prefix2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with include-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            include submodule1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, include1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple include-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            include submodule1;
            include submodule2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, include1_stmt, include2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with both multiple stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 { prefix prefix1; }
            include submodule1;
            import module3 { prefix prefix2; }
            include submodule2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt, include1_stmt, import2_stmt, include2_stmt] }
      let( :import1_substmts ){ [prefix1_stmt] }
      let( :import2_substmts ){ [prefix2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'revision-stmts' do
    context 'without revision-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with revision-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple revision-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23;
            revision 1234-12-24;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt, revision2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'body-stmts' do
    context 'with extension-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple extension-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt, extension2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1;
            feature feature2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt, feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with identity-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple identity-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1;
            identity identity2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt, identity2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 { type string; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 { type string; }
            typedef typedef2 { type int8; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1;
            grouping grouping2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt, grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              leaf leaf1 { type string; }
            }
            container container2 {
              leaf leaf2 { type int8; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt, container2_stmt] }
      let( :container1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :container2_substmts ){ [leaf2_stmt] }
      let( :leaf2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with augment-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple augment-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
            }
            augment /augment2 {
              leaf leaf2 { type int8; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt, augment2_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :augment2_substmts ){ [leaf2_stmt] }
      let( :leaf2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with rpc-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple rpc-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1;
            rpc rpc2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt, rpc2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with notification-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple notification-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1;
            notification notification2;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt, notification2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deviation-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate not-supported; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple deviation-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { default default1; } }
            deviation /deviation2 { deviate add { default default2; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt, deviation2_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [default1_stmt] }
      let( :deviation2_substmts ){ [deviate_add2_stmt] }
      let( :deviate_add2_substmts ){ [default2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'body-stmts' do
    context 'with container-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with leaf-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with leaf-list-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 { type string; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with list-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [key_leaf1_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with choice-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with anyxml-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with case-stmt' do
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
                leaf leaf2 { type int8; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt, case2_stmt] }
      let( :case1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :case2_substmts ){ [leaf2_stmt] }
      let( :leaf2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'yang-version-stmt' do
    context 'with version 1' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            yang-version 1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, yang_version_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with version not 1' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            yang-version 2;
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'import-stmt' do
    context 'without revision-date-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 {
              prefix prefix1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt] }
      let( :import1_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with revision-date-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 {
              prefix prefix1;
              revision-date 1234-12-23;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt] }
      let( :import1_substmts ){ [prefix1_stmt, revision_date1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'include-stmt' do
    context 'without revision-date-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            include submodule1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, include1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without revision-date-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            include submodule1 {
              revision-date 1234-12-23;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, include1_stmt] }
      let( :include1_substmts ){ [revision_date1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'namespace-stmt' do
    context 'with uri argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with not uri argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "1234567890";
            prefix module1;
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'belongs-to-stmt' do
    context 'with prefix-stmt' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1' { prefix prefix1; }
          }
        EOB
      }
      let( :stmt_tree ){ submodule1_stmt }
      let( :submodule1_substmts ){ [belongs_to_stmt] }
      let( :belongs_to_substmts ){ [prefix1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without prefix-stmt' do
      let( :yang_str ){
        <<-EOB
          submodule submodule1 {
            belongs-to 'module1';
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'revision-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      let( :revision1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      let( :revision1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with both description1_stmt and reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23 {
              description description1;
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      let( :revision1_substmts ){ [description1_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with both description1_stmt and reference-stmt in inverse order' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            revision 1234-12-23 {
              reference reference1;
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, revision1_stmt] }
      let( :revision1_substmts ){ [reference1_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'extension-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with argument-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'argument-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1 {
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with yin-element-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1 {
                yin-element true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      let( :argument1_substmts ){ [yin_element_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'yin-element-stmt' do
    context 'with true' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1 {
                yin-element true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      let( :argument1_substmts ){ [yin_element_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with false' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1 {
                yin-element false;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, extension1_stmt] }
      let( :extension1_substmts ){ [argument1_stmt] }
      let( :argument1_substmts ){ [yin_element_false_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
    context 'with not true nor false' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            extension extension1 {
              argument argument1 {
                yin-element aaa;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'identity-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with base-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1 {
              base base1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      let( :identity1_substmts ){ [base1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      let( :identity1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      let( :identity1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            identity identity1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, identity1_stmt] }
      let( :identity1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'feature-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      let( :feature1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      let( :feature1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      let( :feature1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      let( :feature1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            feature feature1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, feature1_stmt] }
      let( :feature1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'typedef-stmt' do
    context 'with type-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 { type string; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              units units1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              default default1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

  end

  describe 'type-stmt' do
    context 'with built-in int8 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type int8; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in int8 argument with numerical-restrictions' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type int8 { range 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in int16 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type int16; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int16_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in int32 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type int32; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int32_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in int64 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type int64; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int64_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in uint8 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type uint8; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_uint8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in uint16 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type uint16; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_uint16_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in uint32 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type uint32; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_uint32_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in uint64 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type uint64; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_uint64_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in decimal64 argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in decimal64 argument with decimal64-specification' do
      context "without range" do
        let( :yang_str ){
          <<-EOB
            module module1 {
              namespace "http://module1.rspec/";
              prefix module1;
              leaf leaf1 { type decimal64 { fraction-digits 1; } }
            }
          EOB
        }
        let( :stmt_tree ){ module1_stmt }
        let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
        let( :leaf1_substmts ){ [type_decimal64_stmt] }
        let( :type_decimal64_substmts ){ [fraction_digits1_stmt] }
        subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
        it { is_expected.to eq stmt_tree_yaml }
      end

      context "with range" do
        let( :yang_str ){
          <<-EOB
            module module1 {
              namespace "http://module1.rspec/";
              prefix module1;
              leaf leaf1 {
                type decimal64 {
                  fraction-digits 1;
                  range 1;
                }
              }
            }
          EOB
        }
        let( :stmt_tree ){ module1_stmt }
        let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
        let( :leaf1_substmts ){ [type_decimal64_stmt] }
        let( :type_decimal64_substmts ){ [fraction_digits1_stmt, range1_stmt] }
        subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
        it { is_expected.to eq stmt_tree_yaml }
      end

      context "with range before fraction-digits" do
        let( :yang_str ){
          <<-EOB
            module module1 {
              namespace "http://module1.rspec/";
              prefix module1;
              leaf leaf1 {
                type decimal64 {
                  range 1;
                  fraction-digits 1;
                }
              }
            }
          EOB
        }
        let( :stmt_tree ){ module1_stmt }
        let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
        let( :leaf1_substmts ){ [type_decimal64_stmt] }
        let( :type_decimal64_substmts ){ [range1_stmt, fraction_digits1_stmt] }
        subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
        it { is_expected.to eq stmt_tree_yaml }
      end
    end

    context 'with built-in string argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in string argument with string-restrictions' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string { length 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in boolean argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type boolean; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_boolean_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in enumeration argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type enumeration; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_enumeration_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in enumeration argument with enum-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type enumeration { enum enum1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_enumeration_stmt] }
      let( :type_enumeration_substmts ){ [enum1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in bits argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type bits; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_bits_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in bits argument with bits-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type bits { bit bit1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_bits_stmt] }
      let( :type_bits_substmts ){ [bit1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in binary argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type binary; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_binary_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in leafref argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in leafref argument with leafref-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { path ../path1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      let( :type_leafref_substmts ){ [path1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in identityref argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type identityref; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_identityref_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in identityref argument with identityref-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type identityref { base base1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_identityref_stmt] }
      let( :type_identityref_substmts ){ [base1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in empty argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type empty; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_empty_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in union argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type union; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_union_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in union argument with union-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type union { type string; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_union_stmt] }
      let( :type_union_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in instance-identifier argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type instance-identifier; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_instance_identifier_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in instance-identifier argument with instance-identifier-specification' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type instance-identifier { require-instance true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_instance_identifier_stmt] }
      let( :type_instance_identifier_substmts ){ [require_instance_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with derived-type argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type derived-type; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_derived_type_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with built-in string argument with string-restrictions and numerical-restrictions' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1;
                range 1;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'range-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1 {
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-message-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1 {
                  error-message error-message1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      let( :range1_substmts ){ [error_message1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-app-tag-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1 {
                  error-app-tag error-app-tag1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      let( :range1_substmts ){ [error_app_tag1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1 {
                  description description1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      let( :range1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1 {
                  reference reference1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range1_stmt] }
      let( :range1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'fraction-digits-stmt' do
    context 'with "1" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits1_stmt] }
      let( :fraction_digits1_stmt ){ Rubyang::Model::FractionDigits.new( '1' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "2" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 2; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits2_stmt] }
      let( :fraction_digits2_stmt ){ Rubyang::Model::FractionDigits.new( '2' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "3" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 3; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits3_stmt] }
      let( :fraction_digits3_stmt ){ Rubyang::Model::FractionDigits.new( '3' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "4" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 4; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits4_stmt] }
      let( :fraction_digits4_stmt ){ Rubyang::Model::FractionDigits.new( '4' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "5" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 5; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits5_stmt] }
      let( :fraction_digits5_stmt ){ Rubyang::Model::FractionDigits.new( '5' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "6" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 6; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits6_stmt] }
      let( :fraction_digits6_stmt ){ Rubyang::Model::FractionDigits.new( '6' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "7" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 7; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits7_stmt] }
      let( :fraction_digits7_stmt ){ Rubyang::Model::FractionDigits.new( '7' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "8" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 8; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits8_stmt] }
      let( :fraction_digits8_stmt ){ Rubyang::Model::FractionDigits.new( '8' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "9" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 9; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits9_stmt] }
      let( :fraction_digits9_stmt ){ Rubyang::Model::FractionDigits.new( '9' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "10" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 10; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits10_stmt] }
      let( :fraction_digits10_stmt ){ Rubyang::Model::FractionDigits.new( '10' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "11" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 11; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits11_stmt] }
      let( :fraction_digits11_stmt ){ Rubyang::Model::FractionDigits.new( '11' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "12" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 12; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits12_stmt] }
      let( :fraction_digits12_stmt ){ Rubyang::Model::FractionDigits.new( '12' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "13" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 13; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits13_stmt] }
      let( :fraction_digits13_stmt ){ Rubyang::Model::FractionDigits.new( '13' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "14" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 14; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits14_stmt] }
      let( :fraction_digits14_stmt ){ Rubyang::Model::FractionDigits.new( '14' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "15" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 15; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits15_stmt] }
      let( :fraction_digits15_stmt ){ Rubyang::Model::FractionDigits.new( '15' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "16" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 16; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits16_stmt] }
      let( :fraction_digits16_stmt ){ Rubyang::Model::FractionDigits.new( '16' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "17" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 17; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits17_stmt] }
      let( :fraction_digits17_stmt ){ Rubyang::Model::FractionDigits.new( '17' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "18" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 18; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_decimal64_stmt] }
      let( :type_decimal64_substmts ){ [fraction_digits18_stmt] }
      let( :fraction_digits18_stmt ){ Rubyang::Model::FractionDigits.new( '18' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "0" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 0; } }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end

    context 'with "19" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 19; } }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end

    context 'with "20" arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type decimal64 { fraction-digits 20; } }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'string-restrictions' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string { } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with length-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string { length 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with pattern-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type string { pattern 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple pattern-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1;
                pattern 2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt, pattern2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple length-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1;
                length 2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end
  end

  describe 'length-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1 {
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-message-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1 {
                  error-message error-message1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      let( :length1_substmts ){ [error_message1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-app-tag-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1 {
                  error-app-tag error-app-tag1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      let( :length1_substmts ){ [error_app_tag1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1 {
                  description description1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      let( :length1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1 {
                  reference reference1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length1_stmt] }
      let( :length1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'pattern-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1 {
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-message-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1 {
                  error-message error-message1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      let( :pattern1_substmts ){ [error_message1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with error-app-tag-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1 {
                  error-app-tag error-app-tag1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      let( :pattern1_substmts ){ [error_app_tag1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1 {
                  description description1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      let( :pattern1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                pattern 1 {
                  reference reference1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [pattern1_stmt] }
      let( :pattern1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  context 'enum-specification' do
    context 'with enum-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type enumeration { enum enum1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_enumeration_stmt] }
      let( :type_enumeration_substmts ){ [enum1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple enum-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type enumeration {
                enum enum1;
                enum enum2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_enumeration_stmt] }
      let( :type_enumeration_substmts ){ [enum1_stmt, enum2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'enum-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1 {
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with value-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1 {
                  value 1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      let( :enum1_substmts ){ [value1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1 {
                  status current;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      let( :enum1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1 {
                  description description1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      let( :enum1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                enum enum1 {
                  reference reference1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [enum1_stmt] }
      let( :enum1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  context 'leafref-specification' do
    context 'with path-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { path ../path1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      let( :type_leafref_substmts ){ [path1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with require-instance-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { require-instance true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      let( :type_leafref_substmts ){ [require_instance_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple path-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type leafref {
                path ../path1;
                path ../path2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'require-instance-arg-str' do
    context 'with true arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { require-instance true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      let( :type_leafref_substmts ){ [require_instance_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
    context 'with false arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { require-instance false; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_leafref_stmt] }
      let( :type_leafref_substmts ){ [require_instance_false_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
    context 'with not true nor false arg' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type leafref { require-instance aaa; } }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'identityref-specification' do
    context 'with base-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type identityref { base base1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_identityref_stmt] }
      let( :type_identityref_substmts ){ [base1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with base-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type identityref {
                base base1;
                base base2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'union-specification' do
    context 'type-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type union { type string; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_union_stmt] }
      let( :type_union_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'type-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type union {
                type string;
                type int8;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_union_stmt] }
      let( :type_union_substmts ){ [type_string_stmt, type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'bits-specification' do
    context 'with bit-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 { type bits { bit bit1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_bits_stmt] }
      let( :type_bits_substmts ){ [bit1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple bit-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type bits {
                bit bit1;
                bit bit2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_bits_stmt] }
      let( :type_bits_substmts ){ [bit1_stmt, bit2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'bit-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1 {
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with position-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1 {
                  position 1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      let( :bit1_substmts ){ [position1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1 {
                  status current;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      let( :bit1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1 {
                  description description1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      let( :bit1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                bit bit1 {
                  reference reference1;
                }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [bit1_stmt] }
      let( :bit1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'status-stmt' do
    context 'with current argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with obsolete argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              status obsolete;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, status_obsolete_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deprecated argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              status deprecated;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt, status_deprecated_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with not current nor obsolete nor deprecated argument' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            typedef typedef1 {
              type string;
              status aaa;
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'grouping-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              typedef typedef1 {
                type string;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              typedef typedef1 {
                type string;
              }
              typedef typedef2 {
                type int8;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              grouping grouping2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              grouping grouping2;
              grouping grouping3;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [grouping2_stmt, grouping3_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            grouping grouping1 {
              container container1;
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, grouping1_stmt] }
      let( :grouping1_substmts ){ [container1_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'container-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              must must1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              must must1;
              must must2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with presence-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              presence presence1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [presence1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              typedef typedef1 {
                type string;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              typedef typedef1 {
                type string;
              }
              typedef typedef2 {
                type int8;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              grouping grouping1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              grouping grouping1;
              grouping grouping2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [grouping1_stmt, grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              container container2;
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [container2_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'leaf-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with type-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              units units1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              must must1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              must must1;
              must must2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              default default1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              mandatory true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string;
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without type-stmt' do
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
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end
  end

  describe 'leaf-list-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with type-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              units units1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              must must1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              must must1;
              must must2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min-elements-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, min_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max-elements-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, max_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with ordered-by-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              ordered-by user;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, ordered_by_user_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf-list leaf-list1 {
              type string;
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without type-stmt' do
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
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end
  end

  describe 'list-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              must must1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              must must1;
              must must2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with key-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              key leaf1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, key_leaf1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              unique unique1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, unique1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              unique unique1;
              unique unique2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, unique1_stmt, unique2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              min-elements 1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, min_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              max-elements 1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, max_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with ordered-by-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              ordered-by user;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, ordered_by_user_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              typedef typedef1 {
                type string;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              typedef typedef1 {
                type string;
              }
              typedef typedef2 {
                type int8;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              grouping grouping1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              grouping grouping1;
              grouping grouping2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, grouping1_stmt, grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            list list1 {
              container container1;
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, list1_stmt] }
      let( :list1_substmts ){ [container1_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    #context 'without data-def-stmt' do
    #  let( :yang_str ){
    #    <<-EOB
    #      module module1 {
    #        namespace "http://module1.rspec/";
    #        prefix module1;
    #        list list1 {
    #        }
    #      }
    #    EOB
    #  }
    #  subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
    #  it { is_expected.to raise_exception Racc::ParseError }
    #end
  end

  describe 'choice-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              default default1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              mandatory true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with short-case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple short-case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              container container1;
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [container1_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1;
              case case2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt, case2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'short-case-stmt' do
    context 'with container-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with leaf-stmt' do
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
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with leaf-list-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              leaf-list leaf-list1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [leaf_list1_stmt] }
      let( :leaf_list1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with list-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              list list1 {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [list1_stmt] }
      let( :list1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with anyxml-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              anyxml anyxml1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [anyxml1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'case-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                when when1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                if-feature if-feature1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                if-feature if-feature1;
                if-feature if-feature2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                status current;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                description description1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                reference reference1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            choice choice1 {
              case case1 {
                container container1;
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, choice1_stmt] }
      let( :choice1_substmts ){ [case1_stmt] }
      let( :case1_substmts ){ [container1_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'anyxml-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              must must1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              must must1;
              must must2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              config true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              mandatory true;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            anyxml anyxml1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, anyxml1_stmt] }
      let( :anyxml1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'uses-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with refine-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with uses-augment-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'refine-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                must must1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                must must1;
                must must2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with presence-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                presence presence1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [presence1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                config true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                description description1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                reference reference1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                default default1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                mandatory true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                min-elements 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [min_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                max-elements 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [refine1_stmt] }
      let( :refine1_substmts ){ [max_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple presence-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                presence presence1;
                presence presence2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                config true;
                config false;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                description description1;
                description description2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                reference reference1;
                reference reference2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                default default1;
                default default2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                mandatory true;
                mandatory false;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple min-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                min-elements 1;
                min-elements 2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple max-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              refine refine1 {
                max-elements 1;
                max-elements 2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end
  end

  describe 'uses-augment-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                when when1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, when1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                if-feature if-feature1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, if_feature1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                if-feature if-feature1;
                if-feature if-feature2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, if_feature1_stmt, if_feature2_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                status current;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, status_current_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                description description1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, description1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                reference reference1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, reference1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                leaf leaf1 { type string; }
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [leaf1_stmt, container1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                case case1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [case1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment uses/augment1 {
                case case1;
                case case2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment1_stmt] }
      let( :uses_augment1_substmts ){ [case1_stmt, case2_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    #context 'without substmts' do
    #  let( :yang_str ){
    #    <<-EOB
    #      module module1 {
    #        namespace "http://module1.rspec/";
    #        prefix module1;
    #        uses uses1 {
    #          augment uses/augment1 {
    #          }
    #        }
    #      }
    #    EOB
    #  }
    #  subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
    #  it { is_expected.to raise_exception Racc::ParseError }
    #end
  end

  describe 'augment-stmt' do
    context 'with when-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, when1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, if_feature1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, if_feature1_stmt, if_feature2_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, status_current_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, description1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, reference1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              leaf leaf1 { type string; }
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [leaf1_stmt, container1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              case case1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [case1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple case-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /augment1 {
              case case1;
              case case2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment1_stmt] }
      let( :augment1_substmts ){ [case1_stmt, case2_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    #context 'without substmts' do
    #  let( :yang_str ){
    #    <<-EOB
    #      module module1 {
    #        namespace "http://module1.rspec/";
    #        prefix module1;
    #        augment /augment1 {
    #          }
    #        }
    #      }
    #    EOB
    #  }
    #  subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
    #  it { is_expected.to raise_exception Racc::ParseError }
    #end
  end

  describe 'when-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1 {
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [when1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1 {
                description description1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [when1_stmt] }
      let( :when1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1 {
                reference reference1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [when1_stmt] }
      let( :when1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1 {
                description description1;
                description description2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end

    context 'with multiple reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              when when1 {
                reference reference1;
                reference reference2;
              }
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception ArgumentError }
    end
  end

  describe 'rpc-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              typedef typedef1 {
                type string;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              typedef typedef1 {
                type string;
              }
              typedef typedef2 {
                type int8;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              grouping grouping1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              grouping grouping1;
              grouping grouping2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [grouping1_stmt, grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with input-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with output-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'input-stmt' do
    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                typedef typedef1 { type string; }
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [typedef1_stmt, container1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                typedef typedef1 { type string; }
                typedef typedef2 { type int8; }
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [typedef1_stmt, typedef2_stmt, container1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                grouping grouping1;
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [grouping1_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                grouping grouping1;
                grouping grouping2;
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [grouping1_stmt, grouping2_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              input {
                container container1;
                container container2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [input1_stmt] }
      let( :input1_substmts ){ [container1_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'output-stmt' do
    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                typedef typedef1 { type string; }
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [typedef1_stmt, container1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                typedef typedef1 { type string; }
                typedef typedef2 { type int8; }
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [typedef1_stmt, typedef2_stmt, container1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                grouping grouping1;
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [grouping1_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                grouping grouping1;
                grouping grouping2;
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [grouping1_stmt, grouping2_stmt, container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                container container1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            rpc rpc1 {
              output {
                container container1;
                container container2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, rpc1_stmt] }
      let( :rpc1_substmts ){ [output1_stmt] }
      let( :output1_substmts ){ [container1_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'notification-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1;
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              if-feature if-feature1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [if_feature1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple if-feature-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              if-feature if-feature1;
              if-feature if-feature2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [if_feature1_stmt, if_feature2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with status-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              status current;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [status_current_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              typedef typedef1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [typedef1_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple typedef-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              typedef typedef1 { type string; }
              typedef typedef2 { type int8; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [typedef1_stmt, typedef2_stmt] }
      let( :typedef1_substmts ){ [type_string_stmt] }
      let( :typedef2_substmts ){ [type_int8_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              grouping grouping1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [grouping1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple grouping-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              grouping grouping1;
              grouping grouping2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [grouping1_stmt, grouping2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              container container1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [container1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple data-def-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            notification notification1 {
              container container1;
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, notification1_stmt] }
      let( :notification1_substmts ){ [container1_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'deviation-stmt' do
    context 'with description-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate not-supported;
              description description1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt, description1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with reference-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate not-supported;
              reference reference1;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt, reference1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deviate-not-supported-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate not-supported; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deviate-add-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple deviate-add-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { default default1; } }
            deviation /deviation2 { deviate add { default default2; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt, deviation2_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [default1_stmt] }
      let( :deviation2_substmts ){ [deviate_add2_stmt] }
      let( :deviate_add2_substmts ){ [default2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deviate-replace-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple deviate-replace-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { default default1; } }
            deviation /deviation2 { deviate replace { default default2; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt, deviation2_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [default1_stmt] }
      let( :deviation2_substmts ){ [deviate_replace2_stmt] }
      let( :deviate_replace2_substmts ){ [default2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with deviate-delete-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple deviate-delete-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { default default1; } }
            deviation /deviation2 { deviate delete { default default2; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt, deviation2_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [default1_stmt] }
      let( :deviation2_substmts ){ [deviate_delete2_stmt] }
      let( :deviate_delete2_substmts ){ [default2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'deviate-not-supported-stmt' do
    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate not-supported; }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'without substmts' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate not-supported {
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_not_supported_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'deviate-add-stmt' do
    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { units units1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { must must1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate add {
                must must1;
                must must2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { unique unique1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [unique1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate add {
                unique unique1;
                unique unique2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [unique1_stmt, unique2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { config true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { mandatory true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { min-elements 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [min_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate add { max-elements 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_add1_stmt] }
      let( :deviate_add1_substmts ){ [max_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'deviate-delete-stmt' do
    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { units units1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { must must1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [must1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple must-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate delete {
                must must1;
                must must2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [must1_stmt, must2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { unique unique1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [unique1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with multiple unique-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 {
              deviate delete {
                unique unique1;
                unique unique2;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [unique1_stmt, unique2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate delete { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_delete1_stmt] }
      let( :deviate_delete1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'deviate-replace-stmt' do
    context 'with type-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { type string; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with units-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { units units1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [units1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with default-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { default default1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [default1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with config-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { config true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with mandatory-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { mandatory true; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [mandatory_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { min-elements 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [min_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max-elements-stmt' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            deviation /deviation1 { deviate replace { max-elements 1; } }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, deviation1_stmt] }
      let( :deviation1_substmts ){ [deviate_replace1_stmt] }
      let( :deviate_replace1_substmts ){ [max_elements1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'range-arg' do
    context 'with 1' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '1' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with -11' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range -11;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '-11' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with 1.1' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range 1.1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '1.1' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range min;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( 'min' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range max;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( 'max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min..max' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range min..max;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( 'min..max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "min .. max"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range "min .. max";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( 'min .. max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "-100.0 .. +5.2"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range "-100.0 .. +5.2";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '-100.0 .. +5.2' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "0 .. max | 10 .. 20"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range "0 .. max | 10 .. 20";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '0 .. max | 10 .. 20' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "-100.0 .. +5.2 | 0.0"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range "-100.0 .. +5.2 | 0.0";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '-100.0 .. +5.2 | 0.0' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "0 .. max | 10 .. 20 | min .. max"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type int8 {
                range "0 .. max | 10 .. 20 | min .. max";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_int8_stmt] }
      let( :type_int8_substmts ){ [range_stmt] }
      let( :range_stmt ){ Rubyang::Model::Range.new( '0 .. max | 10 .. 20 | min .. max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'length-arg' do
    context 'with 1' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length 1;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( '1' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length min;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( 'min' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with max' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length max;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( 'max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with min..max' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length min..max;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( 'min..max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "min .. max"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length "min .. max";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( 'min .. max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "0 .. max | 10 .. 20"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length "0 .. max | 10 .. 20";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( '0 .. max | 10 .. 20' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "0 .. max | 10 .. 20 | min .. max"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            leaf leaf1 {
              type string {
                length "0 .. max | 10 .. 20 | min .. max";
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      let( :type_string_substmts ){ [length_stmt] }
      let( :length_stmt ){ Rubyang::Model::Length.new( '0 .. max | 10 .. 20 | min .. max' ) }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'date-arg' do
    context 'with 1234-12-23' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 {
              prefix prefix1;
              revision-date 1234-12-23;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, import1_stmt] }
      let( :import1_substmts ){ [prefix1_stmt, revision_date1_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with "234-12-23"' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            import module2 {
              prefix prefix1;
              revision-date "234-12-23";
            }
          }
        EOB
      }
      subject { ->{ Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Racc::ParseError }
    end
  end

  describe 'absolute-schema-nodeid' do
    context 'with /a' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with /a/b' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a/b {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a/b', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with /a/b/c' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a/b/c {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a/b/c', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with /a:a' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a:a {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a:a', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with /a:a/b' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a:a/b {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a:a/b', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with /a:a/b/c' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            augment /a:a/b/c {
              leaf leaf1 { type string; }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, augment_stmt] }
      let( :augment_stmt ){ Rubyang::Model::Augment.new( '/a:a/b/c', augment_substmts ) }
      let( :augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'descendant-schema-nodeid' do
    context 'with a' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with a/b' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a/b {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a/b', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with a/b/c' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a/b/c {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a/b/c', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with a:a' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a:a {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a:a', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with a:a/b' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a:a/b {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a:a/b', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'with a:a/b/c' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            uses uses1 {
              augment a:a/b/c {
                leaf leaf1 { type string; }
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, uses1_stmt] }
      let( :uses1_substmts ){ [uses_augment_stmt] }
      let( :uses_augment_stmt ){ Rubyang::Model::Augment.new( 'a:a/b/c', uses_augment_substmts ) }
      let( :uses_augment_substmts ){ [leaf1_stmt] }
      let( :leaf1_substmts ){ [type_string_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end
  end

  describe 'config-stmt' do
    context 'when no config under no config' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when no config under config true' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config true;
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_true_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when no config under config false' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config false;
              container container2;
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_false_stmt, container2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when config false under no config' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              container container2 {
                config false;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [container2_stmt] }
      let( :container2_substmts ){ [config_false_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when config false under config true' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config true;
              container container2 {
                config false;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_true_stmt, container2_stmt] }
      let( :container2_substmts ){ [config_false_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when config false under config false' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config false;
              container container2 {
                config false;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_false_stmt, container2_stmt] }
      let( :container2_substmts ){ [config_false_2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when config true under no config' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              container container2 {
                config true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [container2_stmt] }
      let( :container2_substmts ){ [config_true_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    context 'when config true under config true' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config true;
              container container2 {
                config true;
              }
            }
          }
        EOB
      }
      let( :stmt_tree ){ module1_stmt }
      let( :module1_substmts ){ [namespace_stmt, prefix_stmt, container1_stmt] }
      let( :container1_substmts ){ [config_true_stmt, container2_stmt] }
      let( :container2_substmts ){ [config_true_2_stmt] }
      subject { Rubyang::Model::Parser.parse( yang_str ).to_yaml }
      it { is_expected.to eq stmt_tree_yaml }
    end

    # TODO: should raise error
=begin
    context 'when config true under config false' do
      let( :yang_str ){
        <<-EOB
          module module1 {
            namespace "http://module1.rspec/";
            prefix module1;
            container container1 {
              config false;
              container container2 {
                config true;
              }
            }
          }
        EOB
      }
      subject { -> { Rubyang::Model::Parser.parse( yang_str ).to_yaml } }
      it { is_expected.to raise_exception Exception }
    end
=end
  end
end
