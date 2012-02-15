require "happymapper"
require 'elan_parser'

module ElanParser
	module XML
		class AnnotationDocument
			include HappyMapper

			tag 'ANNOTATION_DOCUMENT'

			attribute :author, String, :tag => 'AUTHOR'
			attribute :date, DateTime, :tag => 'DATE'
			attribute :format, String, :tag => 'FORMAT'
			attribute :version, String, :tag => 'VERSION'
			attribute :xmlns_nonamespaceschemalocation, String, :tag => 'noNamespaceSchemaLocation', :namespace => 'xsi'

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
