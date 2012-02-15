require 'active_record'

module ElanParser
	module DB
		class HeaderMediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_media_descriptors'

			belongs_to :header
			belongs_to :media_descriptor
		end
	end
end