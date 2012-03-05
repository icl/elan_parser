require 'active_record'

module ElanParser
	module DB
		class AnnotationDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents'

			has_one :header, :dependent => :destroy
			has_one :time_order, :dependent => :destroy

			has_many :annotation_document_tiers
			has_many :tiers, :through => :annotation_document_tiers, :dependent => :destroy

			has_many :annotation_document_linguistic_types
			has_many :linguistic_types, :through => :annotation_document_linguistic_types, :dependent => :destroy

			has_many :annotation_document_locales
			has_many :locales, :through => :annotation_document_locales, :dependent => :destroy

			has_many :annotation_document_constraints
			has_many :constraints, :through => :annotation_document_constraints, :dependent => :destroy

	## These relationships are not active. They are currently stubs.
			has_many :controlled_vocabularies
	#		has_many :lexicon_refs
	#		has_many :external_refs
		end
	end
end
