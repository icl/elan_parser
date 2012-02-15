require 'active_record'

module ElanParser
	module DB
		class AnnotationDocumentTier < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_tiers'

			belongs_to :annotation_document
			belongs_to :tier
		end
	end
end