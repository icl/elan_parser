require 'active_record'

module ElanParser
	module DB
		#STUB
		class ControlledVocabulary < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies'
		end
	end
end