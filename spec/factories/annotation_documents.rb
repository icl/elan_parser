require 'factory_girl'

#Factories used in the ElanParser::DB specs
Factory.define :annotation_document, :class => ElanParser::DB::AnnotationDocument do |f|
	f.author "Sir Test"
	f.date Date.new(2012,1,26)
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
	f.linguistic_type_ref "en-US"
	f.default_locale "en-US"
	f.tier_id "Test Marking"
end

Factory.define :header, :class => ElanParser::DB::Header do |f|
	f.time_units "milliseconds"
end

Factory.define :media_descriptor, :class => ElanParser::DB::MediaDescriptor do |f|
	f.media_url "file://path/to/test_file"
	f.relative_media_url "test_file"
	f.mime_type "mpeg"
	f.time_origin "123456"
end

Factory.define :time_slot_a, :class => ElanParser::DB::TimeSlot do |f|
	f.time_value "2600"
end

Factory.define :time_slot_b, :class => ElanParser::DB::TimeSlot do |f|
	f.time_value "2700"
end
