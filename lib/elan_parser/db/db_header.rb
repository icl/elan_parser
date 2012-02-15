require 'active_record'

module ElanParser
	module DB
		class Header < ActiveRecord::Base
			self.table_name = 'elan_parser_headers'

			belongs_to :annotation_document

			has_many :header_media_descriptors
			has_many :media_descriptors, :through => :header_media_descriptors, :dependent => :destroy

			has_many :header_properties
			has_many :properties, :through => :header_properties, :dependent => :destroy
		end
	end
end