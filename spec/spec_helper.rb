require 'rubygems'
require 'bundler/setup'
require 'database_cleaner'
require 'uri'
require 'net/http'
require 'active_record'


$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'elan_parser'


def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end
