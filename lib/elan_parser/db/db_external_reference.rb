require 'active_record'

module ElanParser
	module DB
		#STUB
		class ExternalReference < ActiveRecord::Base
			self.table_name = 'elan_parser_external_references'
		end
	end
end