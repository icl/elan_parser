require 'active_record'

module ElanParser
	module DB
		#STUB
		class CvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_cv_entries'

			belongs_to :controlled_vocabulary
		end
	end
end
