require 'active_record'

module ElanParser
	module DB
		#STUB
		class HeaderLinkedFileDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_headers_linked_file_descriptors'
		end
	end
end