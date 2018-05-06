# coding: utf-8
# vim: et ts=2 sw=2

require_relative 'model/parser'

module Rubyang
  module Model
    DataDefStmtList  ||= %w( container leaf leaf-list list choice case augment uses anyxml )
    DataNodeList     ||= %w( container leaf leaf-list list anyxml )
    SchemaNodeList   ||= %w( container leaf leaf-list list choice case rpc input output notification anyxml )
    TypeBodyStmtList ||= %w( range fraction-digits length pattern default enum leafref path require-instance identityref union bit position )

    def schema_nodeid
      "(?:#{absolute_schema_nodeid}|#{descendant_schema_nodeid})"
    end
    def absolute_schema_nodeid
      "(?:(?:/#{node_identifier})+)"
    end
    def descendant_schema_nodeid
      "(?:#{node_identifier}#{absolute_schema_nodeid})"
    end
    def node_identifier
      "(?:(?:#{prefix}:)?#{identifier})"
    end
    def instance_identifier
      "(?:(?:/#{node_identifier}(?:#{predicate})*)+)"
    end
    def predicate
      "(?:\[#{wsp}*(?:#{predicate_expr}|#{pos})#{wsp}*\])"
    end
    def predicate_expr
      "(?:(?:#{node_identifier}|[.])#{wsp}*=#{wsp}*(?:(?:#{dquote}[^#{dquote}]*#{dquote})|(?:#{squote}[^#{squote}]*#{squote})))"
    end
    def pos
      '(?:[0-9]+)'
    end
    def prefix
      "(?:#{identifier})"
    end
    def identifier
      '(?:[a-zA-Z][a-zA-Z0-9._-]*)'
    end
    def dquote
      '"'
    end
    def squote
      "'"
    end
    def wsp
      '(?:[ \t])'
    end

    class BaseStmt
      def substatements
        {}
      end
      def initialize substmts=[]
        # raise if received susstatements has invalid substatement
        substmts.each{ |s|
          unless self.substatements.include? StmtMap.find( s.class ).intern
            raise ArgumentError, "#{StmtMap.find( s.class )} is not #{self.class}'s substatement"
          end
        }
        # raise if received susstatements does not satisfy defined substatements' cardinality
        self.substatements.each{ |k, v|
          unless v.include? substmts.count{ |s| StmtMap.find( s ).intern == k }
            raise ArgumentError, "substatement #{StmtMap.find( k )} is not in #{self.class} #{k}'s cardinality"
          end
        }
        # raise if received susstatements has invalid substatement class
        substmts.each{ |s|
          unless BaseStmt === s
            raise ArgumentError, "#{s.class} is not Rubyang::Model's class"
          end
        }
        @substmts = substmts
      end
      def to_s parent=true
        head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
        if parent
          vars.push "@substmts=#{@substmts.map{|s| s.to_s(false)}}"
        end
        head + vars.join(', ') + tail
      end
      def substmt substmt, strict: false
        raise TypeError unless String === substmt
        if strict
          unless self.substatements[substmt.intern]
            raise ArgumentError, "#{StmtMap.find( s ).class} is not #{self.class}'s substatement"
          end
        end
        @substmts.select{ |_s| StmtMap.find( substmt ) === _s }
      end
      def substmts substmts, strict: false
        raise TypeError unless Array === substmts
        if strict
          substmts.each{ |s|
            unless self.substatements[s.intern]
              raise ArgumentError, "#{StmtMap.find( s ).class} is not #{self.class}'s substatement"
            end
          }
        end
        @substmts.select{ |_s| substmts.find{ |s| StmtMap.find( s ) === _s } }
      end
      def has_substmt? substmt
        unless self.substatements[substmt.intern]
          raise ArgumentError, "#{StmtMap.find( substmt ).class} is not #{self.class}'s substatement"
        end
        if @substmts.find{ |s| StmtMap.find( substmt ) === s }
          true
        else
          false
        end
      end
      def schema_node_substmts
        @substmts.select{ |s| SchemaNodeList.include? StmtMap.find( s ) }
      end
      def not_schema_node_substmts
        @substmts.select{ |s| not SchemaNodeList.include? StmtMap.find( s ) }
      end
      def without_not_schema_node_substmts
        self.class.new( self.arg, self.not_schema_node_substmts )
      end
      def to_yang level=0, pretty: false, indent: 2
        str = ""
        str += " " * indent * level if pretty
        str += "#{StmtMap.find( self )} #{self.arg}"
        if @substmts.size > 0
          str += " {\n"
          @substmts.each{ |s|
            str += s.to_yang level+1, pretty: pretty, indent: indent
          }
          str += " " * indent * level if pretty
          str += "}\n"
        else
          str += ";\n"
        end
      end
    end

    class NoArgStmt < BaseStmt
    end

    class ArgStmt < BaseStmt
      def initialize arg, substmts=[]
        p self.class.name
        p arg
        super substmts
        @arg = arg
        unless valid_arg? arg
          raise ArgumentError, "Invalid Argument: '#{arg}'"
        end
      end
      def to_s parent=true
        head, vars, tail = "#<#{self.class.to_s}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} ", Array.new, ">"
        if parent
          vars.push "@arg=#{@arg.to_s}"
          vars.push "@substmts=#{@substmts.map{|s| s.to_s(false)}}"
        end
        head + vars.join(', ') + tail
      end
      def arg
        @arg
      end
      def arg_regexp
        '(?:.*)'
      end
      def valid_arg? arg
        re = Regexp.new( "^#{arg_regexp}$" )
        re === arg
      end
    end

    class Module < ArgStmt
      def substatements
        {
          :'anyxml'       => 0..Float::INFINITY,
          :'augment'      => 0..Float::INFINITY,
          :'choice'       => 0..Float::INFINITY,
          :'contact'      => 0..1,
          :'container'    => 0..Float::INFINITY,
          :'description'  => 0..1,
          :'deviation'    => 0..Float::INFINITY,
          :'extension'    => 0..Float::INFINITY,
          :'feature'      => 0..Float::INFINITY,
          :'grouping'     => 0..Float::INFINITY,
          :'identity'     => 0..Float::INFINITY,
          :'import'       => 0..Float::INFINITY,
          :'include'      => 0..Float::INFINITY,
          :'leaf'         => 0..Float::INFINITY,
          :'leaf-list'    => 0..Float::INFINITY,
          :'list'         => 0..Float::INFINITY,
          :'namespace'    => 1..1,
          :'notification' => 0..Float::INFINITY,
          :'organization' => 0..1,
          :'prefix'       => 1..1,
          :'reference'    => 0..1,
          :'revision'     => 0..Float::INFINITY,
          :'rpc'          => 0..Float::INFINITY,
          :'typedef'      => 0..Float::INFINITY,
          :'uses'         => 0..Float::INFINITY,
          :'yang-version' => 0..1,
          :'unknown'      => 0..Float::INFINITY,
        }
      end
    end

    class YangVersion < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Namespace < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Prefix < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Import < ArgStmt
      def substatements
        {
          :'prefix'        => 1..1,
          :'revision-date' => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class RevisionDate < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Include < ArgStmt
      def substatements
        {
          :'revision-date' => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class Organization < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Contact < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Revision < ArgStmt
      def substatements
        {
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Submodule < ArgStmt
      def substatements
        {
          :'anyxml'       => 0..Float::INFINITY,
          :'augment'      => 0..Float::INFINITY,
          :'belongs-to'   => 1..1,
          :'choice'       => 0..Float::INFINITY,
          :'contact'      => 0..1,
          :'container'    => 0..Float::INFINITY,
          :'description'  => 0..1,
          :'deviation'    => 0..Float::INFINITY,
          :'extension'    => 0..Float::INFINITY,
          :'feature'      => 0..Float::INFINITY,
          :'grouping'     => 0..Float::INFINITY,
          :'identity'     => 0..Float::INFINITY,
          :'import'       => 0..Float::INFINITY,
          :'include'      => 0..Float::INFINITY,
          :'leaf'         => 0..Float::INFINITY,
          :'leaf-list'    => 0..Float::INFINITY,
          :'list'         => 0..Float::INFINITY,
          :'notification' => 0..Float::INFINITY,
          :'organization' => 0..1,
          :'reference'    => 0..1,
          :'revision'     => 0..Float::INFINITY,
          :'rpc'          => 0..Float::INFINITY,
          :'typedef'      => 0..Float::INFINITY,
          :'uses'         => 0..Float::INFINITY,
          :'yang-version' => 0..1,
          :'unknown'      => 0..Float::INFINITY,
        }
      end
    end

    class BelongsTo < ArgStmt
      def substatements
        {
          :'prefix'  => 1..1,
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Typedef < ArgStmt
      def substatements
        {
          :'default'     => 0..1,
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'type'        => 1..1,
          :'units'       => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Type < ArgStmt
      def substatements
        {
          :'bit'              => 0..Float::INFINITY,
          :'enum'             => 0..Float::INFINITY,
          :'length'           => 0..1,
          :'path'             => 0..1,
          :'pattern'          => 0..Float::INFINITY,
          :'range'            => 0..1,
          :'require-instance' => 0..1,
          :'type'             => 0..Float::INFINITY,
          :'fraction-digits'  => 0..1,
          :'base'             => 0..1,
          :'unknown'          => 0..Float::INFINITY,
        }
      end
    end

    class Bit < ArgStmt
      def substatements
        {
          :'position'    => 0..1,
          :'status'      => 0..1,
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Enum < ArgStmt
      def substatements
        {
          :'value'       => 0..1,
          :'status'      => 0..1,
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Value < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class FractionDigits < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Identityref < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Leafref < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Position < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Union < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Length < ArgStmt
      def substatements
        {
          :'error-message' => 0..1,
          :'error-app-tag' => 0..1,
          :'description'   => 0..1,
          :'reference'     => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class Path < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Pattern < ArgStmt
      def substatements
        {
          :'error-message' => 0..1,
          :'error-app-tag' => 0..1,
          :'description'   => 0..1,
          :'reference'     => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class Range < ArgStmt
      def substatements
        {
          :'error-message' => 0..1,
          :'error-app-tag' => 0..1,
          :'description'   => 0..1,
          :'reference'     => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class RequireInstance < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Units < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Default < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Container < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'config'      => 0..1,
          :'container'   => 0..Float::INFINITY,
          :'description' => 0..1,
          :'grouping'    => 0..Float::INFINITY,
          :'if-feature'  => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'must'        => 0..Float::INFINITY,
          :'presence'    => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'typedef'     => 0..Float::INFINITY,
          :'uses'        => 0..Float::INFINITY,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Must < ArgStmt
      def substatements
        {
          :'description'   => 0..1,
          :'error-app-tag' => 0..1,
          :'error-message' => 0..1,
          :'reference'     => 0..1,
          :'unknown'       => 0..Float::INFINITY,
        }
      end
    end

    class ErrorMessage < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class ErrorAppTag < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Presence < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Leaf < ArgStmt
      def substatements
        {
          :'config'      => 0..1,
          :'default'     => 0..1,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'mandatory'   => 0..1,
          :'must'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'type'        => 1..1,
          :'units'       => 0..1,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Mandatory < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class LeafList < ArgStmt
      def substatements
        {
          :'config'       => 0..1,
          :'description'  => 0..1,
          :'if-feature'   => 0..Float::INFINITY,
          :'max-elements' => 0..1,
          :'min-elements' => 0..1,
          :'must'         => 0..Float::INFINITY,
          :'ordered-by'   => 0..1,
          :'reference'    => 0..1,
          :'status'       => 0..1,
          :'type'         => 1..1,
          :'units'        => 0..1,
          :'when'         => 0..1,
          :'unknown'      => 0..Float::INFINITY,
        }
      end
    end

    class MinElements < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class MaxElements < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class OrderedBy < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class List < ArgStmt
      def substatements
        {
          :'anyxml'       => 0..Float::INFINITY,
          :'choice'       => 0..Float::INFINITY,
          :'config'       => 0..1,
          :'container'    => 0..Float::INFINITY,
          :'description'  => 0..1,
          :'grouping'     => 0..Float::INFINITY,
          :'if-feature'   => 0..Float::INFINITY,
          :'key'          => 0..1,
          :'leaf'         => 0..Float::INFINITY,
          :'leaf-list'    => 0..Float::INFINITY,
          :'list'         => 0..Float::INFINITY,
          :'max-elements' => 0..1,
          :'min-elements' => 0..1,
          :'must'         => 0..Float::INFINITY,
          :'ordered-by'   => 0..1,
          :'reference'    => 0..1,
          :'status'       => 0..1,
          :'typedef'      => 0..Float::INFINITY,
          :'unique'       => 0..Float::INFINITY,
          :'uses'         => 0..Float::INFINITY,
          :'when'         => 0..1,
          :'unknown'      => 0..Float::INFINITY,
        }
      end
    end

    class Key < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Unique < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Choice < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'case'        => 0..Float::INFINITY,
          :'config'      => 0..1,
          :'container'   => 0..Float::INFINITY,
          :'default'     => 0..1,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'mandatory'   => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Case < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'uses'        => 0..Float::INFINITY,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Anyxml < ArgStmt
      def substatements
        {
          :'config'      => 0..1,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'mandatory'   => 0..1,
          :'must'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Grouping < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'description' => 0..1,
          :'grouping'    => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'typedef'     => 0..Float::INFINITY,
          :'uses'        => 0..Float::INFINITY,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Uses < ArgStmt
      def substatements
        {
          :'augment'     => 0..1,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'refine'      => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Refine < ArgStmt
      def substatements
        {
          :'config'       => 0..1,
          :'default'      => 0..1,
          :'description'  => 0..1,
          :'mandatory'    => 0..1,
          :'max-elements' => 0..1,
          :'min-elements' => 0..1,
          :'must'         => 0..Float::INFINITY,
          :'presence'     => 0..1,
          :'reference'    => 0..1,
          :'status'       => 0..1,
          :'when'         => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Rpc < ArgStmt
      def substatements
        {
          :'description' => 0..1,
          :'grouping'    => 0..Float::INFINITY,
          :'if-feature'  => 0..Float::INFINITY,
          :'input'       => 0..1,
          :'output'      => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'typedef'     => 0..Float::INFINITY,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Input < NoArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'grouping'    => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'typedef'     => 0..Float::INFINITY,
          :'uses'        => 0..Float::INFINITY,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Output < NoArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'grouping'    => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'typedef'     => 0..Float::INFINITY,
          :'uses'        => 0..Float::INFINITY,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Notification < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'description' => 0..1,
          :'grouping'    => 0..Float::INFINITY,
          :'if-feature'  => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'typedef'     => 0..Float::INFINITY,
          :'uses'        => 0..Float::INFINITY,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Augment < ArgStmt
      def substatements
        {
          :'anyxml'      => 0..Float::INFINITY,
          :'case'        => 0..Float::INFINITY,
          :'choice'      => 0..Float::INFINITY,
          :'container'   => 0..Float::INFINITY,
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'leaf'        => 0..Float::INFINITY,
          :'leaf-list'   => 0..Float::INFINITY,
          :'list'        => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'uses'        => 0..Float::INFINITY,
          :'when'        => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Identity < ArgStmt
      def substatements
        {
          :'base'        => 0..1,
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Base < ArgStmt
    end

    class Extension < ArgStmt
      def substatements
        {
          :'argument'    => 0..1,
          :'description' => 0..1,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Argument < ArgStmt
      def substatements
        {
          :'yin-element' => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class YinElement < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class ConformanceRelated < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Feature < ArgStmt
      def substatements
        {
          :'description' => 0..1,
          :'if-feature'  => 0..Float::INFINITY,
          :'reference'   => 0..1,
          :'status'      => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class IfFeature < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Deviation < ArgStmt
      def substatements
        {
          :'description' => 0..1,
          :'deviate'     => 1..Float::INFINITY,
          :'reference'   => 0..1,
          :'unknown'     => 0..Float::INFINITY,
        }
      end
    end

    class Deviate < ArgStmt
      def substatements
        {
          :'config'       => 0..1,
          :'default'      => 0..1,
          :'mandatory'    => 0..1,
          :'max-elements' => 0..1,
          :'min-elements' => 0..1,
          :'must'         => 0..Float::INFINITY,
          :'type'         => 0..1,
          :'unique'       => 0..Float::INFINITY,
          :'units'        => 0..1,
          :'unknown'      => 0..Float::INFINITY,
        }
      end
    end

    class Config < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
      def valid_arg? arg
        ['true', 'false'].include? arg
      end
    end

    class Status < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Description < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class Reference < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
    end

    class When < ArgStmt
      def substatements
        {
          :'description'  => 0..1,
          :'reference'    => 0..1,
        }
      end
    end

    class Unknown < ArgStmt
      def substatements
        {
          :'unknown' => 0..Float::INFINITY,
        }
      end
      def initialize name, arg='', substmts=[]
        super arg, substmts
        @name = name
      end
      def name
        @name
      end
    end

    class StmtMap
      @@stmt_map = [
        { :name => 'anyxml',           :class => Rubyang::Model::Anyxml },
        { :name => 'augment',          :class => Rubyang::Model::Augment },
        { :name => 'argument',         :class => Rubyang::Model::Argument },
        { :name => 'base',             :class => Rubyang::Model::Base },
        { :name => 'belongs-to',       :class => Rubyang::Model::BelongsTo },
        { :name => 'bit',              :class => Rubyang::Model::Bit },
        { :name => 'case',             :class => Rubyang::Model::Case },
        { :name => 'choice',           :class => Rubyang::Model::Choice },
        { :name => 'config',           :class => Rubyang::Model::Config },
        { :name => 'contact',          :class => Rubyang::Model::Contact },
        { :name => 'container',        :class => Rubyang::Model::Container },
        { :name => 'default',          :class => Rubyang::Model::Default },
        { :name => 'description',      :class => Rubyang::Model::Description },
        { :name => 'deviation',        :class => Rubyang::Model::Deviation },
        { :name => 'deviate',          :class => Rubyang::Model::Deviate },
        { :name => 'enum',             :class => Rubyang::Model::Enum },
        { :name => 'error-app-tag',    :class => Rubyang::Model::ErrorAppTag },
        { :name => 'error-message',    :class => Rubyang::Model::ErrorMessage },
        { :name => 'extension',        :class => Rubyang::Model::Extension },
        { :name => 'feature',          :class => Rubyang::Model::Feature },
        { :name => 'fraction-digits',  :class => Rubyang::Model::FractionDigits },
        { :name => 'grouping',         :class => Rubyang::Model::Grouping },
        { :name => 'identity',         :class => Rubyang::Model::Identity },
        { :name => 'identityref',      :class => Rubyang::Model::Identityref },
        { :name => 'if-feature',       :class => Rubyang::Model::IfFeature },
        { :name => 'import',           :class => Rubyang::Model::Import },
        { :name => 'include',          :class => Rubyang::Model::Include },
        { :name => 'input',            :class => Rubyang::Model::Input },
        { :name => 'key',              :class => Rubyang::Model::Key },
        { :name => 'leaf',             :class => Rubyang::Model::Leaf },
        { :name => 'leaf-list',        :class => Rubyang::Model::LeafList },
        { :name => 'leafref',          :class => Rubyang::Model::Leafref },
        { :name => 'length',           :class => Rubyang::Model::Length },
        { :name => 'list',             :class => Rubyang::Model::List },
        { :name => 'mandatory',        :class => Rubyang::Model::Mandatory },
        { :name => 'max-elements',     :class => Rubyang::Model::MaxElements },
        { :name => 'min-elements',     :class => Rubyang::Model::MinElements },
        { :name => 'module',           :class => Rubyang::Model::Module },
        { :name => 'must',             :class => Rubyang::Model::Must },
        { :name => 'namespace',        :class => Rubyang::Model::Namespace },
        { :name => 'notification',     :class => Rubyang::Model::Notification },
        { :name => 'ordered-by',       :class => Rubyang::Model::OrderedBy },
        { :name => 'organization',     :class => Rubyang::Model::Organization },
        { :name => 'output',           :class => Rubyang::Model::Output },
        { :name => 'path',             :class => Rubyang::Model::Path },
        { :name => 'pattern',          :class => Rubyang::Model::Pattern },
        { :name => 'position',         :class => Rubyang::Model::Position },
        { :name => 'prefix',           :class => Rubyang::Model::Prefix },
        { :name => 'presence',         :class => Rubyang::Model::Presence },
        { :name => 'range',            :class => Rubyang::Model::Range },
        { :name => 'reference',        :class => Rubyang::Model::Reference },
        { :name => 'refine',           :class => Rubyang::Model::Refine },
        { :name => 'revision',         :class => Rubyang::Model::Revision },
        { :name => 'revision-date',    :class => Rubyang::Model::RevisionDate },
        { :name => 'require-instance', :class => Rubyang::Model::RequireInstance },
        { :name => 'rpc',              :class => Rubyang::Model::Rpc },
        { :name => 'status',           :class => Rubyang::Model::Status },
        { :name => 'type',             :class => Rubyang::Model::Type },
        { :name => 'typedef',          :class => Rubyang::Model::Typedef },
        { :name => 'uses',             :class => Rubyang::Model::Uses },
        { :name => 'union',            :class => Rubyang::Model::Union },
        { :name => 'units',            :class => Rubyang::Model::Units },
        { :name => 'unique',           :class => Rubyang::Model::Unique },
        { :name => 'value',            :class => Rubyang::Model::Value },
        { :name => 'when',             :class => Rubyang::Model::When },
        { :name => 'yang-version',     :class => Rubyang::Model::YangVersion },
        { :name => 'yin-element',      :class => Rubyang::Model::YinElement },
        { :name => 'unknown',          :class => Rubyang::Model::Unknown },
      ]
      def self.find key
        case key
        when String, Symbol
          @@stmt_map.find{ |h| h[:name] == key.to_s }[:class]
        when Class
          @@stmt_map.find{ |h| h[:class] == key }[:name]
        else
          @@stmt_map.find{ |h| h[:class] === key }[:name]
        end
      end
    end
  end
end

if __FILE__ == $0
  model_yang_version = Rubyang::Model::YangVersion.new( '1' )
  model_namespace    = Rubyang::Model::Namespace.new( 'testnamespace' )
  model_prefix       = Rubyang::Model::Prefix.new( 'testprefix' )
  model_type         = Rubyang::Model::Type.new( 'string' )
  model_leaf         = Rubyang::Model::Leaf.new( 'testleaf', [model_type] )
  model_module_substmts = [
    model_yang_version,
    model_namespace,
    model_prefix,
    model_leaf,
  ]
  model_module = Rubyang::Model::Module.new( 'testmodule', model_module_substmts )
  p model_module
  p model_module.has_substmt?( 'yang-version' )
  p model_module.has_substmt?( 'namespace' )
  p model_module.has_substmt?( 'prefix' )
  p model_module.substmt( 'yang-version' )
  p model_module.substmt( 'namespace' )
  p model_module.substmt( 'prefix' )

  print model_module.to_yang pretty: true
  p model_module.schema_node_substmts
  p model_module.not_schema_node_substmts
end

