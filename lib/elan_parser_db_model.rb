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

			has_one :document
		end

		class MediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_media_descriptors'

			has_one :header
		end

		class Property < ActiveRecord::Base
			self.table_name = 'elan_parser_properties'

			has_one :header
		end

		#STUB
		class LinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_linked_file_descriptors'
		end

		class Header < ActiveRecord::Base
			self.table_name = 'elan_parser_headers'

			belongs_to :annotation_document
			has_many :media_descriptors, :through => :header_media_descriptor
		end

		class HeaderMediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_media_descriptors'

			belongs_to :header
			belongs_to :media_descriptor
		end

		#STUB
		class HeaderLinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_linked_file_descriptors'
		end

		class HeaderProperty < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_properties'
		end

		class TimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_time_slots'

			has_one :alignable_annotation_time_slot
			has_one :time_order, :through => :time_order_time_slot
		end

		class TimeOrder < ActiveRecord::Base
			self.table_name = 'elan_parser_time_orders'

			belongs_to :annotation_document
			has_many :time_slot, :through => :time_order_time_slot
		end

		class TimeOrderTimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_time_orders_time_slots'

			belongs_to :time_order
			belongs_to :time_slot
		end

		#STUB
		class ReferenceAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_reference_annotations'
		end

		class AlignableAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations'

			has_one :alignable_annotation_time_slot
			has_one :annotation
		end

		class AlignableAnnotationTimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations_time_slots'

			belongs_to :alignable_annotation, :class_name => "AlignableAnnotation", :foreign_key => "alignable_annotation_id"
			belongs_to :time_slot_ref1, :class_name => "TimeSlot", :foreign_key => "time_slot_ref1"
			belongs_to :time_slot_ref2, :class_name => "TimeSlot", :foreign_key => "time_slot_ref2"
		end

		class Annotation < ActiveRecord::Base
			self.table_name = 'elan_parser_annotations'

			has_one :tier, :through => :annotation_tier
			belongs_to :alignable_annotation
		end

		class AnnotationDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents'

			belongs_to :document

			has_one :header
			has_one :time_order

			has_many :tiers, :through => :annotation_tier

	## These relationships are not active. They are currently stubs.
	#		has_many :linguistic_types
	#		has_many :locales
	#		has_many :constraints
	#		has_many :controlled_vocabularies
	#		has_many :lexicon_refs
	#		has_many :external_refs
		end

		class Tier < ActiveRecord::Base
			self.table_name = 'elan_parser_tiers'

			has_many :annotation_tiers, :through => :annotation_tier
		end

		class AnnotationTier < ActiveRecord::Base
			self.table_name = 'elan_parser_annotations_tiers'

			belongs_to :annotation
			belongs_to :tier
		end

		#STUB
		class LinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_linguistic_types'

		end

		#STUB
		class Locale < ActiveRecord::Base
			self.table_name = 'elan_parser_locales'
		end

		#STUB
		class Constraint < ActiveRecord::Base
			self.table_name = 'elan_parser_constraints'
		end

		#STUB
		class CvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_cv_entries'
		end

		#STUB
		class ControlledVocabulary < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies'
		end

		#STUB
		class ControlledVocabularyCvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies_cv_entries'
		end

		#STUB
		class LexiconReference < ActiveRecord::Base
			self.table_name = 'elan_parser_lexicon_references'
		end

		#STUB
		class ExternalReference < ActiveRecord::Base
			self.table_name = 'elan_parser_external_references'
		end

		#STUB
		class AnnotationDocumentLinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_linguistic_types'
		end

		#STUB
		class AnnotationDocumentLocale < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_locales'
		end

		#STUB
		class AnnotationDocumentConstraint < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_constraints'
		end

		#STUB
		class AnnotationControlledVocabularyDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_controlled_vocabularies_documents'
		end

		#STUB
		class AnnotationDocumentLexiconRef < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_lexicon_refs'
		end

		#STUB
		class AnnotationDocumentExternalref < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_external_refs'
		end
	end
end
