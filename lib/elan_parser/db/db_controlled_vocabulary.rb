require 'active_record'

module ElanParser
	module DB
		#STUB
		class ControlledVocabulary < ActiveRecord::Base
			self.table_name = 'elan_parser_controlled_vocabularies'

			has_many :cv_entries
			belongs_to :annotation_document
		end
	end
end
