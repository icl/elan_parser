require "happymapper"

module ElanParser
	module XML
		class TimeOrder
			include HappyMapper

			tag 'TIME_ORDER'

			content :value
			has_many :time_slots, TimeSlot
		end
	end
end