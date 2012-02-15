require 'active_record'

module ElanParser
	module DB
		#STUB
		class CvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_cv_entries'
		end
	end
end