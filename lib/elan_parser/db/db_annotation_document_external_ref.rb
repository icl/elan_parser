require 'active_record'

module ElanParser
	module DB
		#STUB
		class AnnotationDocumentExternalref < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_external_refs'
		end
	end
end