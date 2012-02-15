require "happymapper"

module ElanParser
	module XML
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
	end
end