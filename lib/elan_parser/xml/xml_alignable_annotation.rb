require "happymapper"

module ElanParser
	module XML
		class AlignableAnnotation
			include HappyMapper

			tag 'ALIGNABLE_ANNOTATION'

			content :value

			attribute :time_slot_ref1, String, :tag => 'TIME_SLOT_REF1'
			attribute :time_slot_ref2, String, :tag => 'TIME_SLOT_REF2'
			attribute :svg_ref, String, :tag => 'SVG_REF'

			attribute :annotation_id, String, :tag => 'ANNOTATION_ID'
			attribute :ext_ref, String, :tag => 'EXT_REF' 

			element :annotation_value, String, :tag => 'ANNOTATION_VALUE'
		end
	end
end