require 'active_record'

module ElanParser
	module DB
		#STUB
		class AnnotationControlledVocabularyDocument < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_controlled_vocabularies_documents'
		end
	end
end