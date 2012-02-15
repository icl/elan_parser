require "happymapper"

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
	end
end