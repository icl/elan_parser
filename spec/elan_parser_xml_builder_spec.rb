require "spec_helper"
require "factories/annotation_documents"

describe ElanParser::Xml::Build do
	before(:suite) do
		DatabaseCleaner.strategy = :transaction
		DatabaseCleaner.clean_with(:truncation)
	end

	before(:each) do
		DatabaseCleaner.start
	end

	after(:each) do
		DatabaseCleaner.clean
	end
	
	before(:all) do
		@annotation_document = Factory.build(:annotation_document)
		@document = Factory.build(:document)
		@project = Factory.build(:project)
		@property = Factory.build(:property)
		@media_descriptor = Factory.build(:media_descriptor)
		@header = Factory.build(:header)
		@time_slot_a = Factory.build(:time_slot_b)
		@time_slot_b = Factory.build(:time_slot_a)
		@tier = Factory.build(:tier)
		@alignable_annotation_time_slot = Factory.build(:alignable_annotation_time_slot)

		xml_doc = ElanParser::Xml::Build.new
	end


	it "Should create the XML root element" do
		#Create our objects from our factory
		xml_doc = ElanParser::Xml::Build.new

		xml_doc.annotation_document(@annotation_document)
		xml_doc.header(@header)

		media_descriptors = Array.[](@media_descriptor, @media_descriptor)
		xml_doc.media_descriptors(media_descriptors)

		xml_doc.property(@property)

		time_slots = Array.[](@time_slot_a, @time_slot_b)

		xml_doc.time_order(time_slots)

		alignable_annotation_time_slots = Array.[](@alignable_annotation_time_slot, @alignable_annotation_time_slot)
		xml_doc.tier(@tier, alignable_annotation_time_slots)

		puts xml_doc.elan_parser_xml.to_xml
	end
end
