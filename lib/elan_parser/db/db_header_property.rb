require 'active_record'

module ElanParser
	module DB
		class HeaderProperty < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_properties'

			belongs_to :header
			belongs_to :property
		end
	end
end