require 'active_record'

module ElanParser
	module DB
		class Annotation < ActiveRecord::Base
			self.table_name = 'elan_parser_annotations'

			has_one :annotation_tier, :dependent => :destroy
			has_one :tier, :through => :annotation_tier, :dependent => :destroy

			belongs_to :alignable_annotation
		end
	end
end