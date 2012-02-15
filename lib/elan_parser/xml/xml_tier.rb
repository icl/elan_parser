require "happymapper"

module ElanParser
	module XML
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
	end
end