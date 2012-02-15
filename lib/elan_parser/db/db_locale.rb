require 'active_record'

module ElanParser
	module DB
		class Locale < ActiveRecord::Base
			self.table_name = 'elan_parser_locales'

			has_many :annotation_document_locales
			has_many :annotation_documents, :through => :annotation_document_locales, :dependent => :destroy
		end
	end
end