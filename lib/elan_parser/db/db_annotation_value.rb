require 'active_record'

module ElanParser
	module DB
		class AnnotationValue < ActiveRecord::Base
			self.table_name = 'elan_parser_annotation_values'

      has_many :alignable_annotations
		end
	end
end
