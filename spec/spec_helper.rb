require 'rubygems'
require 'bundler/setup'
require 'database_cleaner'
require 'uri'
require 'net/http'
require 'active_record'

ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))

#require 'rspec'
require File.expand_path('../../lib/elan_parser.rb', __FILE__)
#require File.expand_path('../../lib/elan_parser/happymapper.rb', __FILE__)
#require File.expand_path('../../lib/elan_parser/db_model.rb', __FILE__)
#require File.expand_path('../../lib/elan_parser/save_xml.rb', __FILE__)
#require File.expand_path('../../lib/elan_parser/build_xml.rb', __FILE__)
#require File.expand_path('../../lib/elan_parser/helper.rb', __FILE__)

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end
