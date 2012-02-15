require 'active_record'

module ElanParser
	module DB
		#STUB
		class LinguisticType < ActiveRecord::Base
			self.table_name = 'elan_parser_linguistic_types'

			has_many :annotation_document_linguistic_types
			has_many :annotation_documents, :through => :annotation_document_linguistic_types, :dependent => :destroy
		end
	end
end