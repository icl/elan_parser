require "spec_helper"

describe ElanParser do
	it "Should parse one document and save it to ActiveRecord" do
		@eparse = ElanParser::SaveDocument.new(
			fixture_file("elan_test.xml"),
			{"name" => "donkey", "description" => "adsf"}
		)
	end
end
