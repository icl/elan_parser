require "spec_helper"
require "factories/annotation_documents"

describe ElanParser::XML::Save do
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

	it "Should parse one fixture into a happymapper document and match the values to saved active record values" do
		file_name = "elan_test.xml"

		ElanParser::XML::Save.new(
			fixture_file(file_name),
			file_name
		)

		annotation_document = ElanParser::DB::AnnotationDocument.find_by_file_name(file_name)

    happymapper_document = ElanParser::XML::AnnotationDocument.parse(fixture_file(file_name))
		
		#The saved annotations should match the annotations from the fixture
		happymapper_document.tiers.each do |tier|
			tier.annotations.each do |annotation|
				#Compare the saved value with the happymapper document value of tiers
				db_tier = annotation_document.tiers.find_by_tier_id(tier.tier_id)
				tier.tier_id.equal? db_tier.tier_id

				annotation.alignable_annotations.each do |alignable_annotation|
					#Compare the happymapper annotation value with the db value
					ElanParser::DB::AnnotationValue.find_by_annotation_value(alignable_annotation.annotation_value).equal? alignable_annotation.annotation_value
				end
			end
		end
	end
end
