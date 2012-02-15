require 'active_record'

module ElanParser
	module DB
		class Constraint < ActiveRecord::Base
			self.table_name = 'elan_parser_constraints'

			has_many :annotation_document_constraints
			has_many :annotation_documents, :through => :annotation_document_constraints, :dependent => :destroy
		end
	end
end