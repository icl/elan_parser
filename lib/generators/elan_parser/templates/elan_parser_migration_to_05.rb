class ElanParserMigrationTo05 < ActiveRecord::Migration
  def self.up
		drop_table :elan_parser_controlled_vocabularies
		drop_table :elan_parser_controlled_cv_entries_vocabularies
		drop_table :elan_parser_cv_entries

		create_table :elan_parser_cv_entries do |t|
			t.belongs_to :controlled_vocabulary
			t.column :description, :text, :null => true
			t.column :ext_ref, :string, :null => true
			t.column :cv_entry, :string, :null => false
		end

		create_table :elan_parser_controlled_vocabularies do |t|
			t.column :cv_id, :string, :null => false
			t.column :description, :text, :null => false
			t.column :ext_ref, :string, :null => true
			t.belongs_to :annotation_document
		end
	end
end
