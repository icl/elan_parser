require "happymapper"

module ElanParser
	module XML
		class LinkedFileDescriptor
			include HappyMapper

			tag 'LINKED_FILE_DESCRIPTOR'

			attribute :link_url, String, :tag => 'LINK_URL'
			attribute :relative_link_url, String, :tag => 'RELATIVE_LINK_URL'
			attribute :mime_type, String, :tag => 'MIME_TYPE'
			attribute :time_origin, Integer, :tag => 'TIME_ORIGIN'
			attribute :associated_with, String, :tag => 'ASSOCIATED_WITH'
		end
	end
end