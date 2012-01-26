require "elan_parser/version"
require "HappyMapper"

module ElanParser
	module XML
		class MediaDescriptor
			include HappyMapper

			tag 'MEDIA_DESCRIPTOR'

			attribute :media_url, String, :tag => 'MEDIA_URL'
			attribute :relative_media_url, String, :tag => 'RELATIVE_MEDIA_URL'
			attribute :mime_type, String, :tag => 'MIME_TYPE'
			attribute :time_origin, String, :tag => 'TIME_ORIGIN'
			attribute :extracted_from, String, :tag => 'EXTRACTED_FROM'
		end

		class Property
			include HappyMapper

			tag 'PROPERTY'
			attribute :name, String, :tag => 'NAME'
		end

		class LinkedFileDescriptor
			include HappyMapper

			tag 'LINKED_FILE_DESCRIPTOR'

			attribute :link_url, String, :tag => 'LINK_URL'
			attribute :relative_link_url, String, :tag => 'RELATIVE_LINK_URL'
			attribute :mime_type, String, :tag => 'MIME_TYPE'
			attribute :time_origin, Integer, :tag => 'TIME_ORIGIN'
			attribute :associated_with, String, :tag => 'ASSOCIATED_WITH'
		end

		class Header
			include HappyMapper

			tag 'HEADER'

			#Deprecated in favor of media_descriptors
			attribute :media_file, String, :tag => 'MEDIA_FILE'
			attribute :time_units, String, :tag => 'TIME_UNITS'

			has_many :media_descriptors, MediaDescriptor
			has_many :linked_file_descriptors, LinkedFileDescriptor
			has_many :properties, Property
		end

		class TimeSlot
			include HappyMapper

			tag 'TIME_SLOT'

			attribute :time_slot_id, String
			attribute :time_value, Integer
		end

		class TimeOrder
			include HappyMapper

			tag 'TIME_ORDER'

			has_many :time_slots, TimeSlot
		end

		class RefAnnotation
			include HappyMapper

			tag 'REF_ANNOTATION'

			attribute :annotation_id, String, :tag => 'ANNOTATION_ID'
			attribute :ext_ref, String, :tag => 'EXT_REF' 
			attribute :annotation_ref, String, :tag => 'ANNOTATION_REF'
			attribute :previous_annotation, String, :tag => 'PREVIOUS_ANNOTATION'

			element :annotation_value, String, :tag => 'ANNOTATION_VALUE'
		end

		class AlignableAnnotation
			include HappyMapper

			tag 'ALIGNABLE_ANNOTATION'

			attribute :time_slot_ref1, Integer, :tag => 'TIME_SLOT_REF1'
			attribute :time_slot_ref2, Integer, :tag => 'TIME_SLOT_REF2'
			attribute :svg_ref, String, :tag => 'SVG_REF'

			attribute :annotation_id, String, :tag => 'ANNOTATION_ID'
			attribute :ext_ref, String, :tag => 'EXT_REF' 

			element :annotation_value, String, :tag => 'ANNOTATION_VALUE'
		end

		class Annotation
			include HappyMapper

			tag 'ANNOTATION'

			has_many :alignable_annotations, AlignableAnnotation
			has_many :ref_annotations, RefAnnotation
		end

		class Tier
			include HappyMapper

			tag 'TIER'

			attribute :tier_id, String, :tag => 'TIER_ID'
			attribute :participant, String, :tag => 'PARTICIPANT'
			attribute :annotator, String, :tag => 'ANNOTATOR'
			attribute :linguistic_type_ref, String, :tag => 'LINGUISTIC_TYPE_REF'
			attribute :default_locale, String, :tag =>'DEFAULT_LOCALE'
			attribute :parent_ref, String, :tag => 'PARENT_REF'

			has_many :annotations, Annotation
		end

		class LinguisticType
			include HappyMapper

			tag 'LINGUISTIC_TYPE'

			attribute :linguistic_type_id, String, :tag => 'LINGUISTIC_TYPE_ID'
			attribute :time_alignable, Boolean, :tag => 'TIME_ALIGNABLE'
			attribute :constraints, String, :tag => 'CONSTRAINTS'
			attribute :graphic_references, Boolean, :tag => 'GRAPHIC_REFERENCES'
			attribute :controlled_vocabulary_ref, String, :tag => 'CONTROLLED_VOCABULARY_REF'
			attribute :ext_ref, String, :tag => 'EXT_REF'
			attribute :lexicon_ref, String, :tag => 'LEXICON_REF'

		end

		class Locale
			include HappyMapper

			tag 'LOCALE'

			attribute :language_code, String, :tag => 'LANGUAGE_CODE'
			attribute :country_code, String, :tag => 'COUNTRY_CODE'
			attribute :variant, String, :tag => 'VARIANT'
		end

		class Constraint
			include HappyMapper

			tag 'CONSTRAINT'

			attribute :stereotype, String, :tag => 'STEREOTYPE'
			attribute :description, String, :tag => 'DESCRIPTION'
		end

		class CvEntry
			include HappyMapper

			attribute :description, :tag => 'DESCRIPTION'
			attribute :ext_ref, :tag => 'EXT_REF'
		end

		class ControlledVocabulary
			include HappyMapper

			tag 'CONTROLLED_VOCABULARY'

			attribute :cv_id, String, :tag => 'CV_ID'
			attribute :description, String, :tag => 'DESCRIPTION'
			attribute :ext_ref, String, :tag => 'EXT_REF'

			has_many :cv_entries, CvEntry
		end

		class LexiconRef
			include HappyMapper

			tag 'LEXICON_REF'

			attribute :lex_ref_id, String, :tag => 'LEX_REF_ID'
			attribute :name, String, :tag => 'NAME'
			attribute :type, String, :tag => 'TYPE'
			attribute :url, String, :tag => 'URL'
			attribute :lexicon_id, String, :tag => 'LEXICON_ID'
			attribute :lexicon_name, String, :tag => 'LEXICON_NAME'
			attribute :datcat_id, String, :tag => 'DATCAT_ID'
			attribute :datcat_name, String, :tag => 'DATCAT_NAME'
		end

		class ExternalRef
			include HappyMapper

			tag 'EXTERNAL_REF'

			attribute :ext_ref_id, String, :tag => 'EXT_REF_ID'
			attribute :type, String, :tag => 'TYPE'
			attribute :value, String, :tag => 'VALUE'

			element :iso12620, String
			element :ecv, String
			element :cve_id, String
			element :lexen_id, String
			element :resource_url, String

		end

		class AnnotationDocument
			include HappyMapper

			tag 'ANNOTATION_DOCUMENT'

			attribute :author, String, :tag => 'AUTHOR'
			attribute :date, DateTime, :tag => 'DATE'
			attribute :format, String, :tag => 'FORMAT'
			attribute :version, String, :tag => 'VERSION'

			has_one :header, Header
			has_one :time_order, TimeOrder
			has_many :tiers, Tier
			has_many :linguistic_types, LinguisticType
			has_many :locales, Locale
			has_many :constraints, Constraint
			has_many :controlled_vocabularies, ControlledVocabulary
			has_many :lexicon_refs, LexiconRef
			has_many :external_refs, ExternalRef
		end
	end
end
