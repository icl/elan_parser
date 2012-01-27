require "spec_helper"

describe ElanParser::XML do
	before(:all) do
			@eparser = ElanParser::XML::AnnotationDocument.parse(
				fixture_file("elan_test.xml")
			)
	end

		it "Should have a date in the ANNOTATION_DOCUMENT node" do
			puts @eparser.date
		end

		it "Should have at least one media descriptor in the header" do
			puts @eparser.header.media_descriptors[0].media_url
		end

		it "Should have a property with a value" do
			puts @eparser.header.properties[0].name
		end

		it "Should have a time order with at least one time slot" do
			puts @eparser.time_order.time_slots[0].time_value
		end

		it "Should have at least one tier, and one annotation" do
			puts @eparser.tiers[0].annotations[0].alignable_annotations[0].annotation_value
		end
end
