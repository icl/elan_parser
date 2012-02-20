require 'active_record'

module ElanParser
	module DB
		class AlignableAnnotationTimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_alignable_annotations_time_slots'

			belongs_to :alignable_annotation, :class_name => "AlignableAnnotation", :foreign_key => "alignable_annotation_id"
			belongs_to :time_slot_ref1, :class_name => "TimeSlot", :foreign_key => "time_slot_ref1"
			belongs_to :time_slot_ref2, :class_name => "TimeSlot", :foreign_key => "time_slot_ref2"
		end
	end
end
