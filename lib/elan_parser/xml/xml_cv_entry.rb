require "happymapper"

module ElanParser
	module XML
		class CvEntry
			include HappyMapper

			attribute :description, :tag => 'DESCRIPTION'
			attribute :ext_ref, :tag => 'EXT_REF'
		end
	end
end