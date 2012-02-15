require "happymapper"

module ElanParser
	module XML
		class Annotation
			include HappyMapper

			tag 'ANNOTATION'

			has_many :alignable_annotations, AlignableAnnotation
			has_many :ref_annotations, RefAnnotation
		end
	end
end