require 'active_record'

module ElanParser
	module DB
		class Connect
			ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))
		end

		class Document < ActiveRecord::Base
			self.table_name = 'elan_parser_documents'

			belongs_to :project
			has_one :annotation_document
		end

		class Project < ActiveRecord::Base
			self.table_name = 'elan_parser_projects'

			has_one :documents
		end

		class MediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_media_descriptors'

		end

		class Property < ActiveRecord::Base
			self.table_name = 'elan_parser_properties'

		end

		class LinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_linked_file_descriptors'
		end

		class Header < ActiveRecord::Base
			self.table_name = 'elan_parser_headers'
		end

		class HeaderMediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_media_descriptors'

			belongs_to :header
			belongs_to :media_descriptor
		end

		class HeaderLinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_linked_file_descriptors'
		end

		class HeaderProperty < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_properties'
		end

		class TimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_time_slots'
		end

		class TimeOrder < ActiveRecord::Base
			self.table_name = 'elan_parser_time_orders'
		end

		class ReferenceAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_reference_annotations'
		end

		class AlignableAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations'
		end

		class AlignableAnnotationTimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations_time_slots'
		end

		class Annotation < ActiveRecord::Base
			self.table_name = 'elan_parser_annotations'
		end

		class AnnotationDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents'

			belongs_to :documents

			has_one :header
	#		has_one :time_order
			has_many :tiers_to_annotations
			has_many :tiers, :through => :tiers_to_annotations
	#		has_many :linguistic_types
	#		has_many :locales
	#		has_many :constraints
	#		has_many :controlled_vocabularies
	#		has_many :lexicon_refs
	#		has_many :external_refs
		end

		class Tier < ActiveRecord::Base
			self.table_name = 'elan_parser_tiers'

			has_many :tiers_to_annotations
			has_many :tiers, :through => :tiers_to_annotations
		end

		class AnnotationTier < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_tiers'

			belongs_to :annotation_document
			belongs_to :tier
		end

		class LinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_linguistic_types'

		end

		class Locale < ActiveRecord::Base
			self.table_name = 'elan_parser_locales'
		end

		class Constraint < ActiveRecord::Base
			self.table_name = 'elan_parser_constraints'
		end

		class CvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_cv_entries'
		end

		class ControlledVocabulary < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies'
		end

		class ControlledVocabularyCvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies_cv_entries'
		end

		class LexiconReference < ActiveRecord::Base
			self.table_name = 'elan_parser_lexicon_references'
		end

		class ExternalReference < ActiveRecord::Base
			self.table_name = 'elan_parser_external_references'
		end

		class AnnotationDocumentLinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_linguistic_types'
		end

		class AnnotationDocumentLocale < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_locales'
		end

		class AnnotationDocumentConstraint < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_constraints'
		end

		class AnnotationControlledVocabularyDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_controlled_vocabularies_documents'
		end

		class AnnotationDocumentLexiconRef < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_lexicon_refs'
		end

		class AnnotationDocumentExternalref < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_external_refs'
		end
	end
end

	#tier = ElanParser::DB::Tier.create(:linguistic_type_ref => "blah", :default_locale => "en", :tier_id => "blahs")

#	annotation_document = ElanParser::AnnotationDocument.create(:author => "Aaron", :date => Date.new(2003,1,12))
#	puts annotation_document.id

#	ElanParser::AnnotationTier.create(:annotation_document => annotation_document, :tier => tier)

	#ElanParser::Documents.create(:projects_id => ElanParser::Projects.create(:project_name => "blah", :description => "woot").id, :file_name => "test")


	#ElanParser::Documents.all.each do |t|
	#	puts ElanParser::Projects.find(t.id).description
	#	puts t.file_name
	#end
