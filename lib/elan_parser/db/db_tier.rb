require 'active_record'

module ElanParser
	module DB
		class Tier < ActiveRecord::Base
			self.table_name = 'elan_parser_tiers'
			has_many :annotation_tiers
			has_many :annotations, :through => :annotation_tiers, :dependent => :destroy

			has_many :annotation_document_tiers
			has_many :annotation_documents, :through => :annotation_document_tiers, :dependent => :destroy
		end
	end
end