require 'active_record'

module ElanParser
	module DB
		class TimeOrderTimeSlot < ActiveRecord::Base
			self.table_name = 'elan_parser_time_orders_time_slots'

			belongs_to :time_order
			belongs_to :time_slot
		end
	end
end