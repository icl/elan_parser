require 'active_record'

module ElanParser
	module DB
		class AnnotationDocumentConstraint < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_constraints'

			belongs_to :annotation_document
			belongs_to :constraint
		end
	end
end