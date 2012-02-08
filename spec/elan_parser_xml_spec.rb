require "spec_helper"

describe ElanParser::XML do
	before(:all) do
			@eparser = ElanParser::XML::AnnotationDocument.parse(
				fixture_file("elan_test.xml")
			)
	end

		it "Should have a date in the ANNOTATION_DOCUMENT node" do
			DateTime.parse(@eparser.date.to_s).class.should be DateTime
			(@eparser.xmlns_nonamespaceschemalocation =~ URI::regexp).nil?.should be false
		end

		it "Should have at least one media descriptor in the header" do
			(@eparser.header.media_descriptors[0].media_url =~ URI::regexp).nil?.should be false
		end

		it "Should have a property with a value" do
			@eparser.header.properties[0].name.to_s.length.should be > 0
		end

		it "Should have a time order with at least one time slot" do
			@eparser.time_order.time_slots[0].time_value.class.should be Fixnum
		end

		it "Should have at least one tier, and one annotation" do
			@eparser.tiers[0].annotations[0].alignable_annotations[0].annotation_value.to_s.length.should be > 0
		end
end
