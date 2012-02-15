require 'active_record'

module ElanParser
	module DB
		class Property < ActiveRecord::Base
			self.table_name = 'elan_parser_properties'

			has_one :header, :through => 'header_property'
		end
	end
end