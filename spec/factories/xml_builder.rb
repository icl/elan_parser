require 'factory_girl'

#Factories used in the ElanParser::Xml::Builder specs
Factory.define :annotation_document, :class => ElanParser::DB::AnnotationDocument do |f|
	f.author "Sir Test"
	f.date Date.new(2012,1,26)
end

Factory.define :header
end

Factory.define :media_descriptor
end

Factory.define :property
end

Factory.define :time_order
end

Factory.define :time_slot
end

Factory.define :tier
end

Factory.define :annotation
end

Factory.define :annotation_value
end
