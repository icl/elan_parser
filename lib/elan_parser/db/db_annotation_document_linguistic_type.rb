require 'active_record'

module ElanParser
	module DB
		class AnnotationDocumentLinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_linguistic_types'

			belongs_to :linguistic_type
			belongs_to :annotation_document
		end
	end
end