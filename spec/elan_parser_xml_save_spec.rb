require "spec_helper"
require "factories/annotation_documents"

describe ElanParser::Xml::Save do
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
		happymapper_document = ElanParser::XML::AnnotationDocument.parse(fixture_file("elan_test.xml"))

		factory_document = Factory.build(:document)
		factory_project = Factory.build(:project)

		#Save the document and project to the database so they can be associated with the parsed happymapper document
		project = ElanParser::DB::Project.create(
			:project_name => factory_project.project_name,
			:description => factory_project.description
		)

		
		document = ElanParser::DB::Document.create(
			:file_name => factory_document.file_name,
			:project => project
		)

		ElanParser::Xml::Save.new(
			happymapper_document,
			document
		)


		#The saved annotations should match the annotations from the fixture
		happymapper_document.tiers.each do |tier|
			tier.annotations.each do |annotation|
				#Compare the saved value with the happymapper document value of tiers
				db_tier = document.annotation_document.tiers.find_by_tier_id(tier.tier_id)
				tier.tier_id.equal? db_tier.tier_id

				annotation.alignable_annotations.each do |alignable_annotation|
					#Compare the happymapper annotation value with the db value
					ElanParser::DB::AlignableAnnotation.find_by_annotation_value(alignable_annotation.annotation_value).equal? alignable_annotation.annotation_value
				end
			end
		end
	end
end
