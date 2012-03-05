require 'nokogiri'

module ElanParser
	module XML
		class Build
			attr_reader :elan_parser_xml, :validation_errors

			def initialize
				@elan_parser_xml = Nokogiri::XML::Document.new
			end

			def build_eaf_document(annotation_document_id)
				annotation_document = ElanParser::DB::AnnotationDocument.find(
          annotation_document_id
				)

				#Build out each module of the XML document
				annotation_document(annotation_document)
				header(annotation_document.header)
				media_descriptors(annotation_document.header.media_descriptors)
				properties(annotation_document.header.properties)
				time_slot_ref = time_order(annotation_document.time_order.time_slots)

				tiers(annotation_document.tiers, time_slot_ref)
        linguistic_type(annotation_document.linguistic_types)
        locale(annotation_document.locales)
        constraint(annotation_document.constraints)

				controlled_vocabularies(annotation_document.controlled_vocabularies)

        #validate the document and destroy it if it's not valid
        elan_validator = ElanParser::Helper::Validator.new
        @validation_errors = elan_validator.validate_elan_xml(@elan_parser_xml)

        #@elan_parser_xml = nil if @validation_errors.size > 0
			end

			def annotation_document(annotation_document)
				annotation_node = Nokogiri::XML::Node.new("ANNOTATION_DOCUMENT", @elan_parser_xml)

				annotation_node["AUTHOR"] = annotation_document.author
				annotation_node["DATE"] = DateTime.parse(annotation_document.date.to_s).to_s
				annotation_node["FORMAT"] = annotation_document.format
				annotation_node["VERSION"] = annotation_document.version

#				annotation_node["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
#				annotation_node["xsi:noNamespaceSchemaLocation"] = annotation_document.xsi_no_name_space_schema_location

				@elan_parser_xml.add_child(annotation_node)
			end

			def controlled_vocabularies(controlled_vocabularies)
				controlled_vocabularies.each do |cv|
					cv_node = Nokogiri::XML::Node.new("CONTROLLED_VOCABULARY", @elan_parser_xml)

					cv_node["CV_ID"] = cv.cv_id
					cv_node["DESCRIPTION"] = cv.description
					cv_node["EXT_REF"] = cv.ext_ref
					
					cv.cv_entries.each do |entry|
						cv_entry_node = Nokogiri::XML::Node.new("CV_ENTRY", @elan_parser_xml)
						cv_entry_node["DESCRIPTION"] = entry.description
						cv_entry_node["EXT_REF"] = entry.ext_ref
						cv_entry_node.content = entry.cv_entry
						cv_node.add_child(cv_entry_node)
					end

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(cv_node)
				end
			end

			def linguistic_type(linguistic_types)
				linguistic_types.each do |linguistic_type|
					linguistic_type_node = Nokogiri::XML::Node.new("LINGUISTIC_TYPE", @elan_parser_xml)

					linguistic_type_node["GRAPHIC_REFERENCES"] = linguistic_type.graphic_references.to_s
					linguistic_type_node["LINGUISTIC_TYPE_ID"] = linguistic_type.linguistic_type_id
					linguistic_type_node["TIME_ALIGNABLE"] = linguistic_type.time_alignable.to_s
					if linguistic_type.constraints.length > 0 then linguistic_type_node["CONSTRAINTS"] = linguistic_type.constraints end
				  if linguistic_type.controlled_vocabulary_ref.length > 0 then	linguistic_type_node["CONTROLLED_VOCABULARY_REF"] = linguistic_type.controlled_vocabulary_ref end
					if linguistic_type.ext_ref.length > 0 then linguistic_type_node["EXT_REF"] = linguistic_type.ext_ref end
					if linguistic_type.lexicon_ref.length > 0 then linguistic_type_node["LEXICON_REF"] = linguistic_type.lexicon_ref end

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(linguistic_type_node)
				end
			end

			def locale(locales)
				locales.each do |locale|
					locale_node = Nokogiri::XML::Node.new("LOCALE", @elan_parser_xml)
					
					locale_node["LANGUAGE_CODE"] = locale.language_code
					locale_node["COUNTRY_CODE"] = locale.country_code
					locale_node["VARIANT"] = locale.variant if locale.variant

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(locale_node)
				end
			end

			def constraint(constraints)
				constraints.each do |constraint|
					constraint_node = Nokogiri::XML::Node.new("CONSTRAINT", @elan_parser_xml)

					constraint_node["STEREOTYPE"] = constraint.stereotype
					constraint_node["DESCRIPTION"] = constraint.description

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(constraint_node)
				end
			end

			def header(header)
				header_node = Nokogiri::XML::Node.new("HEADER", @elan_parser_xml)

				header_node["TIME_UNITS"] = header.time_units

				#Find the annotation_document node and insert the header
				@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(header_node)
			end

			def media_descriptors(media_descriptors)

				media_descriptors.each do |media_descriptor|
					media_descriptor_node = Nokogiri::XML::Node.new("MEDIA_DESCRIPTOR", @elan_parser_xml)

					media_descriptor_node["MEDIA_URL"] = media_descriptor.media_url
					media_descriptor_node["MIME_TYPE"] = media_descriptor.mime_type
					media_descriptor_node["RELATIVE_MEDIA_URL"] = media_descriptor.relative_media_url
					media_descriptor_node["RELATIVE_MEDIA_URL"] = media_descriptor.relative_media_url

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT/HEADER").first.add_child(media_descriptor_node)
				end
			end

			def properties(properties)
				properties.each do |property|
					property_node = Nokogiri::XML::Node.new("PROPERTY", @elan_parser_xml)

					property_node["NAME"] = property.name
					property_node.content = property.value

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT/HEADER").first.add_child(property_node)
				end
			end

			def time_order(time_slots)
				time_order_node = Nokogiri::XML::Node.new("TIME_ORDER", @elan_parser_xml)

        time_slot_ref = Hash.new

				time_slots.each_with_index do |time_slot, index|
          time_slot_ref[time_slot.id] = index
					time_slot(time_order_node, time_slot, index)
				end

				@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(time_order_node)

        return time_slot_ref
			end

			def time_slot(time_order_node, time_slot, index)
				time_slot_node = Nokogiri::XML::Node.new("TIME_SLOT", @elan_parser_xml)

				time_slot_node["TIME_SLOT_ID"] = "ts" + index.to_s
				time_slot_node["TIME_VALUE"] = time_slot.time_value.to_s

				time_order_node.add_child(time_slot_node)
			end

			def tiers(tiers, time_slot_ref)
				tiers.each do |tier|
					tier_node = Nokogiri::XML::Node.new("TIER", @elan_parser_xml)

					tier_node["DEFAULT_LOCALE"] = tier.default_locale
					tier_node["LINGUISTIC_TYPE_REF"] = tier.linguistic_type_ref
					tier_node["TIER_ID"] = tier.tier_id

					tier.annotations.each do |annotation|
						annotation(tier_node, annotation, time_slot_ref)
					end

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(tier_node)
				end
			end

			def annotation(tier_node, annotation, time_slot_ref)
				annotation_node = Nokogiri::XML::Node.new("ANNOTATION", @elan_parser_xml)

				alignable_annotation(annotation_node, annotation, time_slot_ref)

				tier_node.add_child(annotation_node)
			end

			def alignable_annotation(annotation_node, annotation, time_slot_ref)
				alignable_annotation_node = Nokogiri::XML::Node.new("ALIGNABLE_ANNOTATION", @elan_parser_xml)

        alignable_id = annotation.alignable_annotation.id.to_s

        ts1_id = time_slot_ref[annotation.alignable_annotation.alignable_annotation_time_slot.time_slot_ref1.id].to_s
        ts2_id = time_slot_ref[annotation.alignable_annotation.alignable_annotation_time_slot.time_slot_ref2.id].to_s
        
        #Create a composite key for the annotation's uniqueness
        annotation_id = alignable_id + ts1_id + ts2_id

				alignable_annotation_node["ANNOTATION_ID"] = "a" + annotation_id
				alignable_annotation_node["TIME_SLOT_REF1"] = "ts" + ts1_id
				alignable_annotation_node["TIME_SLOT_REF2"] = "ts" + ts2_id

				annotation_value_node = Nokogiri::XML::Node.new("ANNOTATION_VALUE", @elan_parser_xml)
				annotation_value_node.content = annotation.alignable_annotation.annotation_value

				alignable_annotation_node.add_child(annotation_value_node)
				annotation_node.add_child(alignable_annotation_node)
			end
		end
	end
end
