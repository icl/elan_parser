class ElanParserMigration < ActiveRecord::Migration
  def self.up
	create_table :elan_parser_media_descriptors do |t|
		t.column :media_url, :string, :null => false
		t.column :relative_media_url, :string, :null => false
		t.column :mime_type, :string, :null => false
		t.column :time_origin, :string, :null => false
		t.column :extracted_from, :string, :null => true
	end

	create_table :elan_parser_properties do |t|
		t.column :name, :string, :null => false
		t.column :value, :string, :null => false
	end

	create_table :elan_parser_linked_file_descriptors do |t|
	  # This is untested and may have :null => false requirements
		t.column :link_url, :string, :null => true
		t.column :relative_link_url, :string, :null => true
		t.column :mime_type, :string, :null => true
		t.column :time_origin, :integer, :null => true
		t.column :associated_with, :string, :null => true
	end

	create_table :elan_parser_headers do |t|
		#Deprecated in favor of media_descriptors
		t.column :media_file, :string, :null => true
		t.column :time_units, :string, :null => false

		t.belongs_to :annotation_document
	end

	create_table :elan_parser_headers_media_descriptors do |t|
	  t.belongs_to :header
	  t.belongs_to :media_descriptor
	end

	create_table :elan_parser_headers_linked_file_descriptors do |t|
	  t.belongs_to :header
	  t.belongs_to :linked_file_descriptor
	end

	create_table :elan_parser_headers_properties do |t|
	  t.belongs_to :header
	  t.belongs_to :property
	end

	create_table :elan_parser_time_slots do |t|
		t.column :time_value, :integer, :null => false
	end

	create_table :elan_parser_time_orders do |t|
		t.belongs_to :annotation_document
	end

	create_table :elan_parser_time_orders_time_slots do |t|
		t.belongs_to :time_slot
		t.belongs_to :time_order
	end

	create_table :elan_parser_reference_annotations do |t|
		t.column :ext_ref, :string, :null => true
		t.column :annotation_ref, :string, :null => true
		t.column :previous_annotation, :string, :null => true
		t.column :annotation_value, :string, :null => true
	end

	create_table :elan_parser_alignable_annotations do |t|
		t.column :svg_ref, :string, :null => true
		t.column :ext_ref, :string, :null => true
		t.column :annotation_value, :string, :null => true
	end

	create_table :elan_parser_alignable_annotations_time_slots do |t|
		t.belongs_to :alignable_annotation
		t.column :time_slot_ref1, :integer, :null => false
		t.column :time_slot_ref2, :integer, :null => false
	end

	create_table :elan_parser_annotations do |t|
	  t.belongs_to :alignable_annotation
	  t.belongs_to :ref_annotation
	end

	create_table :elan_parser_tiers do |t|
		t.column :participant, :string, :null => true
		t.column :annotator, :string, :null => true
		t.column :linguistic_type_ref, :string, :null => false
		t.column :default_locale, :string, :null => false
		t.column :parent_ref, :string, :null => true
		t.column :tier_id, :string, :null => false
	end

	create_table :elan_parser_annotations_tiers do |t|
	  t.belongs_to :tier
	  t.belongs_to :annotation
	end

	create_table :elan_parser_linguistic_types do |t|
	    # This is untested and may have :null => false requirements
		t.column :linguistic_type_id, :string, :null => true
		t.column :time_alignable, :boolean, :null => true
		t.column :constraints, :string, :null => true
		t.column :graphic_references, :boolean, :null => true
		t.column :controlled_vocabulary_ref, :string, :null => true
		t.column :ext_ref, :string, :null => true
		t.column :lexicon_ref, :string, :null => true
	end

	create_table :elan_parser_locales do |t|
		t.column :language_code, :string, :null => true
		t.column :country_code, :string, :null => true
		t.column :variant, :string, :null => true
	end

	create_table :elan_parser_constraints do |t|
		t.column :stereotype, :string, :null => true
		t.column :description, :string, :null => true
	end

	create_table :elan_parser_cv_entries do |t|
	    # This is untested and may have :null => false requirements
		t.column :description, :string, :null => true
		t.column :ext_ref, :string, :null => true
	end

	create_table :elan_parser_controlled_vocabularies do |t|
		t.column :cv_id, :string, :null => false
		t.column :description, :string, :null => false
		t.column :ext_ref, :string, :null => true
	end

	create_table :elan_parser_controlled_cv_entries_vocabularies do |t|
	  t.belongs_to :controlled_vocabularie
	  t.belongs_to :cv_entrie
	end

	create_table :elan_parser_lexicon_references do |t|
	    # This is untested and may have :null => false requirements
		t.column :lex_ref_id, :string, :null => false
		t.column :name, :string, :null => false
		t.column :type, :string, :null => false
		t.column :url, :string, :null => true
		t.column :lexicon_id, :string, :null => false
		t.column :lexicon_name, :string, :null => false
		t.column :datcat_id, :string, :null => false
		t.column :datcat_name, :string, :null => false
	end

	create_table :elan_parser_external_references do |t|
	    # This is untested and may have :null => false requirements
		t.column :ext_ref_id, :string, :null => false
		t.column :type, :string, :null => false
		t.column :value, :string, :null => false
		t.column :iso12620, :string, :null => true
		t.column :ecv, :string, :null => true
		t.column :cve_id, :string, :null => true
		t.column :lexen_id, :string, :null => true
		t.column :resource_url, :string, :null => true
	end

	create_table :elan_parser_annotation_documents do |t|
		t.column :author, :string, :null => false
		t.column :date, :datetime, :null => false
		t.column :format, :string, :null => true
		t.column :version, :string, :null => true
		t.column :xsi_no_name_space_schema_location, :string, :null => false
		t.column :file_name, :string, :null => false
	end

	create_table :elan_parser_annotation_documents_tiers do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :tier
	end

	create_table :elan_parser_annotation_documents_linguistic_types do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :linguistic_type
	end

	create_table :elan_parser_annotation_documents_locales do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :locale
	end

	create_table :elan_parser_annotation_documents_constraints do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :constraint
	end

	create_table :elan_parser_annotation_controlled_vocabularies_documents do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :controlled_vocabularie
	end

	create_table :elan_parser_annotation_documents_lexicon_refs do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :lexicon_ref
	end

	create_table :elan_parser_annotation_documents_external_refs do |t|
	  t.belongs_to :annotation_document
	  t.belongs_to :external_ref
	end
  end
end
