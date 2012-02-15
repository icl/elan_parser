require "happymapper"

module ElanParser
	module XML
		class Constraint
			include HappyMapper

			tag 'CONSTRAINT'

			attribute :stereotype, String, :tag => 'STEREOTYPE'
			attribute :description, String, :tag => 'DESCRIPTION'
		end
	end
end