require 'active_record'

module ElanParser
	module DB
		class TimeOrder < ActiveRecord::Base
			self.table_name = 'elan_parser_time_orders'

			belongs_to :annotation_document

			has_many :time_order_time_slots
			has_many :time_slots, :through => :time_order_time_slots, :dependent => :destroy
		end
	end
end