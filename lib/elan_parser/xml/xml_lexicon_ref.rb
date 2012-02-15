require "happymapper"

module ElanParser
	module XML
		class LexiconRef
			include HappyMapper

			tag 'LEXICON_REF'

			attribute :lex_ref_id, String, :tag => 'LEX_REF_ID'
			attribute :name, String, :tag => 'NAME'
			attribute :type, String, :tag => 'TYPE'
			attribute :url, String, :tag => 'URL'
			attribute :lexicon_id, String, :tag => 'LEXICON_ID'
			attribute :lexicon_name, String, :tag => 'LEXICON_NAME'
			attribute :datcat_id, String, :tag => 'DATCAT_ID'
			attribute :datcat_name, String, :tag => 'DATCAT_NAME'
		end
	end
end