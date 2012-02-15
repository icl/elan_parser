require "happymapper"

module ElanParser
	module XML
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
	end
end