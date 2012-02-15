require 'active_record'

module ElanParser
	module DB
		#STUB
		class AnnotationDocumentLexiconRef < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_lexicon_refs'
		end	
	end
end