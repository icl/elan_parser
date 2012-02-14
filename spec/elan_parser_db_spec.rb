require "spec_helper"
require "factories/annotation_documents"

describe ElanParser::DB do
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

		@media_descriptor = Factory.build(:media_descriptor)
		@header = Factory.build(:header)
  end

	it "Should save the annotation document to the database" do
		@annotation_document.save

		@annotation_document.id.should be > 0
	end

	it "Should save the media descriptor to the database" do
		@media_descriptor.save

		@media_descriptor.id.should be > 0
	end

	it "Should save the header to the database" do
		@header.save

		@header.id.should be > 0
	end

	it "Should save the header id and the media descriptor id to the join table" do
		header_media_descriptor = ElanParser::DB::HeaderMediaDescriptor.create(:header => @header, :media_descriptor => @media_descriptor)
		header_media_descriptor.id.should be > 0
	end
end
