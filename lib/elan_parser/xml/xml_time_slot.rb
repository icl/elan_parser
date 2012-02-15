require "happymapper"

module ElanParser
	module XML
		class TimeSlot
			include HappyMapper

			tag 'TIME_SLOT'

			attribute :time_slot_id, String, :tag => 'TIME_SLOT_ID'
			attribute :time_value, Integer, :tag => 'TIME_VALUE'
		end
	end
end