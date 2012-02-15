require 'active_record'

module ElanParser
	module DB
		#STUB
		class LexiconReference < ActiveRecord::Base
			self.table_name = 'elan_parser_lexicon_references'
		end
	end
end