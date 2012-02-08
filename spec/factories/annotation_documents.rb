require 'factory_girl'

#Factories used in the ElanParser::DB specs
Factory.define :annotation_document, :class => ElanParser::DB::AnnotationDocument do |f|
	f.author "Sir Test"
	f.date Date.new(2012,1,26)
	f.format "2.7"
	f.version "2.7"
	f.xsi_no_name_space_schema_location "http://www.mpi.nl/tools/elan/EAFv2.7.xsd"
end

Factory.define :document, :class => ElanParser::DB::Document do |f|
	f.file_name "something.xml"
end

Factory.define :project, :class => ElanParser::DB::Project do |f|
	f.project_name "Test Project"
	f.description "This is a project description used for testing"
end

Factory.define :tier, :class => ElanParser::DB::Tier do |f|
	f.participant "Test Participant"
	f.annotator "Test Annotator"
	f.linguistic_type_ref "default-lt"
	f.default_locale "en"
	f.tier_id "Test Marking"
end

Factory.define :header, :class => ElanParser::DB::Header do |f|
	f.time_units "milliseconds"
end

Factory.define :property, :class => ElanParser::DB::Property do |f|
	f.name "lastUsedAnnotationId"
	f.value "944"
end

Factory.define :media_descriptor, :class => ElanParser::DB::MediaDescriptor do |f|
	f.media_url "file://path/to/test_file"
	f.relative_media_url "test_file"
	f.mime_type "mpeg"
	f.time_origin "123456"
end

FactoryGirl.define do 
	factory :time_slot, :class => ElanParser::DB::TimeSlot do 
		sequence(:time_value) {|n| n}
	end

	factory :alignable_annotation, :class => ElanParser::DB::AlignableAnnotation do
		sequence(:annotation_value) {|n| n}
	end
end

Factory.define :annotation, :class => ElanParser::DB::Annotation do |f|

end

#Factory.define :alignable_annotation, :class => ElanParser::DB::AlignableAnnotation do |f|
#	f.annotation_value "TEST ANNOTATION VALUE"
#end

Factory.define :alignable_annotation_time_slot, :class => ElanParser::DB::AlignableAnnotationTimeSlot do |f|
	f.association :alignable_annotation
	f.association :time_slot_ref1, :factory => :time_slot
	f.association :time_slot_ref2, :factory => :time_slot
end

Factory.define :linguistic_type, :class => ElanParser::DB::LinguisticType do |f|
	f.linguistic_type_id "default-lt"
	f.time_alignable "true"
	f.graphic_references "false"
end

Factory.define :annotation_document_linguistic_type, :class => ElanParser::DB::AnnotationDocumentLinguisticType do |f|
	f.association :annotation_document
	f.association :linguistic_type
end

Factory.define :locale, :class => ElanParser::DB::Locale do |f|
	f.country_code "US"
	f.language_code "US"
end

Factory.define :annotation_document_locale, :class => ElanParser::DB::AnnotationDocumentLocale do |f|
	f.association :annotation_document
	f.association :locale
end

Factory.define :constraint, :class => ElanParser::DB::Constraint do |f|
	f.description "Constraint Description"
	f.stereotype "Time_Subdivision"
end

Factory.define :annotation_document_constraint, :class => ElanParser::DB::AnnotationDocumentConstraint do |f|
	f.association :annotation_document
	f.association :constraint
end
