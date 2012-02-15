require 'active_record'

module ElanParser
	module DB
		class AnnotationTier < ActiveRecord::Base
			self.table_name = 'elan_parser_annotations_tiers'

			belongs_to :annotation
			belongs_to :tier
		end
	end
end