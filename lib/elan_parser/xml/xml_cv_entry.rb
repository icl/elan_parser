require "happymapper"

module ElanParser
	module XML
		class CvEntry
			include HappyMapper

			tag 'CV_ENTRY'

			attribute :description, String, :tag => 'DESCRIPTION'
			attribute :ext_ref, String, :tag => 'EXT_REF'
			content :value
		end
	end
end
