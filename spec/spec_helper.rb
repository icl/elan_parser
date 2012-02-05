require 'rubygems'
require 'bundler/setup'
require 'database_cleaner'

#require 'rspec'
require File.expand_path('../../lib/elan_parser_happymapper.rb', __FILE__)
require File.expand_path('../../lib/elan_parser_db_model.rb', __FILE__)
require File.expand_path('../../lib/elan_parser_save_xml.rb', __FILE__)
require File.expand_path('../../lib/elan_parser_build_xml.rb', __FILE__)
require File.expand_path('../../lib/elan_parser_helper.rb', __FILE__)

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end
