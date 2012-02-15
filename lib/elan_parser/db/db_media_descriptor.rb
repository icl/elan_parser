require 'active_record'

module ElanParser
	module DB
		class MediaDescriptor < ActiveRecord::Base
			self.table_name = 'elan_parser_media_descriptors'

			has_many :header_media_descriptors
			has_many :media_descriptors, :through => :header_media_descriptors, :dependent => :destroy
		end
	end
end