require 'bundler/setup'

if ENV['CI']
  require 'codeclimate-test-reporter'
  SimpleCov.start do
    #add_filter '/spec/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubyang'
