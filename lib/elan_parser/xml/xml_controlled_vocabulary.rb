require "happymapper"

module ElanParser
	module XML
		class ControlledVocabulary
			include HappyMapper

			tag 'CONTROLLED_VOCABULARY'

			attribute :cv_id, String, :tag => 'CV_ID'
			attribute :description, String, :tag => 'DESCRIPTION'
			attribute :ext_ref, String, :tag => 'EXT_REF'

			has_many :cv_entries, CvEntry
		end
	end
end