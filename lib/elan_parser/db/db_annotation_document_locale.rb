require 'active_record'

module ElanParser
	module DB
		#STUB
		class AnnotationDocumentLocale < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_documents_locales'

			belongs_to :annotation_document
			belongs_to :locale
		end
	end
end