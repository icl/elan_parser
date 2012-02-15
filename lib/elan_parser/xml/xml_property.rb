require "happymapper"

module ElanParser
	module XML
		class Property
			include HappyMapper

			tag 'PROPERTY'
			content :value
			attribute :name, String, :tag => 'NAME'
		end
	end
end