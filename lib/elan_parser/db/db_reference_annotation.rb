require 'active_record'

module ElanParser
	module DB
		#STUB
		class ReferenceAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_reference_annotations'
		end
	end
end