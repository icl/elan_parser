require 'active_record'

module ElanParser
	module DB
		class TimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_time_slots'

			has_one :alignable_annotation_time_slot, :dependent => :destroy
			has_one :time_order, :dependent => :destroy
		end
	end
end