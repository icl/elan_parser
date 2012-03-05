require 'rails/generators/migration'

module ElanParser
 module Generators
  class CvGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)
    desc "Add the migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "elan_parser_migration_to_05.rb", "db/migrate/elan_parser_migration_to_05.rb"
      end
    end
  end
end
