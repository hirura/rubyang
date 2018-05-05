# coding: utf-8
# vim: et ts=2 sw=2

require_relative 'base'

class Example < Rubyang::Server::Base
end

example = Example.new
example.run
