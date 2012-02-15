require "happymapper"

module ElanParser
	module XML
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
	end
end