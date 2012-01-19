require 'rubygems'
require 'bundler/setup'

require 'rspec'
require File.expand_path('../../lib/elan_parser', __FILE__)

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end
