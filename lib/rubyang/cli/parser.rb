# coding: utf-8
# vim: et ts=2 sw=2

require 'strscan'
#require 'rubyang/cli/parser/parser.tab.rb'

module Rubyang
  class Cli
    class Parser
      def self.parse( str )
        parser = self.new
        parser.parse( str )
      end

      def initialize
      end

      def parse( str )
        @tokens = Array.new

        s = StringScanner.new( str )

        keywords = {
        }

        scanre_list = [
          ["dqstr", /^"(?:[^"]|\\.)*"/],
          ["sqstr", /^'(?:[^']|\\.)*'/],
          ["nqstr", /^[a-zA-Z0-9:\/\|\.=_-]+/],
          ["wsp",   /^[ \t]+/],
        ]
        scanres = scanre_list.to_h

        scanre = Regexp.union( scanre_list.map{ |scanre| scanre[1] } )

        last = ''
        until s.eos?
          token = s.scan( scanre )
          case token
          when scanres["dqstr"] then
            token_ = token.gsub(/^"/,'').gsub(/"$/,'').gsub(/\\n/,"\n").gsub(/\\t/,"\t").gsub(/\\"/,"\"").gsub(/\\\\/,"\\")
            @tokens.push token_
            last = "dqstr"
          when scanres["sqstr"] then
            token_ = token.gsub(/^'/,'').gsub(/'$/,'')
            @tokens.push token_
            last = "sqstr"
          when scanres["nqstr"] then
            @tokens.push token
            last = "nqstr"
          when scanres["wsp"] then
            last = "wsp"
          else raise "token not match to any scanres: #{token.inspect}"
          end
        end
        if last == "wsp"
          @tokens.push ''
        end

        #result = self.do_parse
        return @tokens
      end

      def next_token
        #p @tokens.first
        @tokens.shift
      end
    end
  end
end

if __FILE__ == $0
  p Rubyang::Cli::Parser.parse "set aaa "
end
