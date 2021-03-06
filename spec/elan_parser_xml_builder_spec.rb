require "spec_helper"
require "factories/annotation_documents"

describe ElanParser::XML::Build do
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
	
	before(:each) do
		@annotation_document = Factory.create(:annotation_document)
		@property = Factory.create(:property)
		@media_descriptor = Factory.create(:media_descriptor)
		@header = Factory.create(:header)
		@time_slot_a = Factory.create(:time_slot)
		@time_slot_b = Factory.create(:time_slot)
		@tier = Factory.create(:tier)
		@alignable_annotation_time_slot_a = Factory.create(:alignable_annotation_time_slot)
		@alignable_annotation_time_slot_b = Factory.create(:alignable_annotation_time_slot)
		@linguistic_type = Factory.create(:linguistic_type)
		@locale = Factory.create(:locale)
		@constraint = Factory.create(:constraint)

		xml_doc = ElanParser::XML::Build.new
	end


	it "Should create the XML root element" do
		#Create our objects from our factory
		xml_doc = ElanParser::XML::Build.new

		xml_doc.annotation_document(@annotation_document)
		xml_doc.header(@header)

		media_descriptors = Array.[](@media_descriptor, @media_descriptor)
		xml_doc.media_descriptors(media_descriptors)

		xml_doc.properties(Array.[](@property))

		time_slots = Array.[](@time_slot_a, @time_slot_b)

		time_slot_ref = xml_doc.time_order(time_slots)

		alignable_annotation_time_slots = Array.[](@alignable_annotation_time_slot_a, @alignable_annotation_time_slot_b)
		xml_doc.tiers(Array.[](@tier), time_slot_ref)

		xml_doc.linguistic_type(Array.[](@linguistic_type))
		xml_doc.locale(Array.[](@locale))
		xml_doc.constraint(Array.[](@constraint))

		#It should validate against the elan XSD
		elan_validator = ElanParser::Helper::Validator.new
		elan_validator.validate_elan_xml(xml_doc.elan_parser_xml).should be_empty
    puts xml_doc.elan_parser_xml
	end
end
