require "happymapper"

module ElanParser
	module XML
		class RefAnnotation
			include HappyMapper

			tag 'REF_ANNOTATION'

			attribute :annotation_id, String, :tag => 'ANNOTATION_ID'
			attribute :ext_ref, String, :tag => 'EXT_REF' 
			attribute :annotation_ref, String, :tag => 'ANNOTATION_REF'
			attribute :previous_annotation, String, :tag => 'PREVIOUS_ANNOTATION'

			element :annotation_value, String, :tag => 'ANNOTATION_VALUE'
		end
	end
end