module ElanParser
  module Helper
		class Validator
			def validate_elan_xml(document_xml)
				xsd = Nokogiri::XML::Schema(File.open(File.expand_path('../../assets/EAFv2.7.xsd', __FILE__)))
				is_valid = xsd.validate(document_xml)

				return is_valid
			end
		end
	end
end
