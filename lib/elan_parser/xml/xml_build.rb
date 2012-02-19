require 'nokogiri'

module ElanParser
	module XML
		class Build
			attr_reader :elan_parser_xml

			def initialize
				@elan_parser_xml = Nokogiri::XML::Document.new
			end

			def build_eaf_document(file_name)
				annotation_document = ElanParser::DB::AnnotationDocument.find_by_file_name(
					file_name
				)

				#Build out each module of the XML document
				annotation_document(annotation_document)
				header(annotation_document.header)
				media_descriptors(annotation_document.header.media_descriptors)
				properties(annotation_document.header.properties)
				time_order(annotation_document.time_order.time_slots)
				tiers(annotation_document.tiers)	
        linguistic_type(annotation_document.linguistic_types)
        locale(annotation_document.locales)
        constraint(annotation_document.constraints)

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

			def linguistic_type(linguistic_types)
				linguistic_types.each do |linguistic_type|
					linguistic_type_node = Nokogiri::XML::Node.new("LINGUISTIC_TYPE", @elan_parser_xml)

					linguistic_type_node["GRAPHIC_REFERENCES"] = linguistic_type.graphic_references.to_s
					linguistic_type_node["LINGUISTIC_TYPE_ID"] = linguistic_type.linguistic_type_id
					linguistic_type_node["TIME_ALIGNABLE"] = linguistic_type.time_alignable.to_s
					if linguistic_type.constraints then linguistic_type_node["CONSTRAINTS"] = linguistic_type.constraints end
				  if linguistic_type.controlled_vocabulary_ref then	linguistic_type_node["CONTROLLED_VOCABULARY_REF"] = linguistic_type.controlled_vocabulary_ref end
					if linguistic_type.ext_ref then linguistic_type_node["EXT_REF"] = linguistic_type.ext_ref end
					if linguistic_type.lexicon_ref then linguistic_type_node["LEXICON_REF"] = linguistic_type.lexicon_ref end

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

				time_slots.each do |time_slot|
					time_slot(time_order_node, time_slot)
				end

				@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(time_order_node)
			end

			def time_slot(time_order_node, time_slot)
				time_slot_node = Nokogiri::XML::Node.new("TIME_SLOT", @elan_parser_xml)

				time_slot_node["TIME_SLOT_ID"] = "ts" + time_slot.id.to_s
				time_slot_node["TIME_VALUE"] = time_slot.time_value.to_s

				time_order_node.add_child(time_slot_node)
			end

			def tiers(tiers)
				tiers.each do |tier|
					tier_node = Nokogiri::XML::Node.new("TIER", @elan_parser_xml)

					tier_node["DEFAULT_LOCALE"] = tier.default_locale
					tier_node["LINGUISTIC_TYPE_REF"] = tier.linguistic_type_ref
					tier_node["TIER_ID"] = tier.tier_id

					tier.annotations.each do |annotation|
						annotation(tier_node, annotation)
					end

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(tier_node)
				end
			end

			def annotation(tier_node, annotation)
				annotation_node = Nokogiri::XML::Node.new("ANNOTATION", @elan_parser_xml)

				alignable_annotation(annotation_node, annotation)

				tier_node.add_child(annotation_node)
			end

			def alignable_annotation(annotation_node, annotation)
				alignable_annotation_node = Nokogiri::XML::Node.new("ALIGNABLE_ANNOTATION", @elan_parser_xml)

        alignable_id = annotation.alignable_annotation.id.to_s
        ts1_id = annotation.alignable_annotation.alignable_annotation_time_slot.time_slot_ref1.id.to_s
        ts2_id = annotation.alignable_annotation.alignable_annotation_time_slot.time_slot_ref2.id.to_s

        
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
