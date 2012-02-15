require 'active_record'

module ElanParser
	module DB
		#STUB
		class ControlledVocabularyCvEntry < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies_cv_entries'
		end
	end
end