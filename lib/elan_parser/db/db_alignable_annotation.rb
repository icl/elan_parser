require 'active_record'

module ElanParser
	module DB
		class AlignableAnnotation < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations'

			has_one :alignable_annotation_time_slot, :dependent => :destroy
			has_one :annotation, :dependent => :destroy

      belongs_to :annotation_value
		end
	end
end
