require "happymapper"

module ElanParser
	module XML
		class Locale
			include HappyMapper

			tag 'LOCALE'

			attribute :language_code, String, :tag => 'LANGUAGE_CODE'
			attribute :country_code, String, :tag => 'COUNTRY_CODE'
			attribute :variant, String, :tag => 'VARIANT'
		end
	end
end