require 'active_record'

module ElanParser
	module DB
		#STUB
		class LinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_linked_file_descriptors'
		end
	end
end