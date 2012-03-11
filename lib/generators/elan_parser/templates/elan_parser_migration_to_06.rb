class ElanParserMigrationTo06 < ActiveRecord::Migration
  def self.up
		drop_table :elan_parser_alignable_annotations

		create_table :elan_parser_alignable_annotations do |t|
      t.column :svg_ref, :string
      t.column :ext_ref, :string
      t.belongs_to :annotation_value
		end

		create_table :elan_parser_annotation_values do |t|
      t.column :annotation_value, :text
		end
	end
end
