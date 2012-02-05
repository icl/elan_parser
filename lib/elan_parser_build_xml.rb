require 'nokogiri'

module ElanParser
	module Xml
		class Build
			attr_reader :elan_parser_xml

			def initialize
				@elan_parser_xml = Nokogiri::XML::Document.new
			end

			def annotation_document(annotation_document)
				annotation_node = Nokogiri::XML::Node.new("ANNOTATION_DOCUMENT", @elan_parser_xml)

				annotation_node["AUTHOR"] = annotation_document.author
				annotation_node["DATE"] = annotation_document.date.to_s
				annotation_node["FORMAT"] = annotation_document.format
				annotation_node["VERSION"] = annotation_document.version
				annotation_node["xmlns:xsi"] = annotation_document.xmlns_xsi
				annotation_node["xsi:noNamespaceSchemaLocation"] = annotation_document.xsi_no_name_space_schema_location

				@elan_parser_xml.add_child(annotation_node)
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

			def property(property)
					property_node = Nokogiri::XML::Node.new("PROPERTY", @elan_parser_xml)

					property_node["NAME"] = property.name
					property_node.content = property.value

					@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT/HEADER").first.add_child(property_node)
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

				time_slot_node["TIME_SLOT_ID"] = time_slot.id.to_s
				time_slot_node["TIME_VALUE"] = time_slot.time_value.to_s

				time_order_node.add_child(time_slot_node)
			end

			def tier(tier, alignable_annotation_time_slots)
				tier_node = Nokogiri::XML::Node.new("TIER", @elan_parser_xml)

				tier_node["DEFAULT_LOCALE"] = tier.default_locale
				tier_node["LINGUISTIC_TYPE_REF"] = tier.linguistic_type_ref
				tier_node["TIER_ID"] = tier.tier_id

				alignable_annotation_time_slots.each do |alignable_annotation_time_slot|
					annotation(tier_node, alignable_annotation_time_slot)
				end

				@elan_parser_xml.xpath("/ANNOTATION_DOCUMENT").first.add_child(tier_node)
			end

			def annotation(tier_node, alignable_annotation_time_slot)
				annotation_node = Nokogiri::XML::Node.new("ANNOTATION", @elan_parser_xml)

				alignable_annotation(annotation_node, alignable_annotation_time_slot)

				tier_node.add_child(annotation_node)
			end

			def alignable_annotation(annotation_node, annotation)
				alignable_annotation_node = Nokogiri::XML::Node.new("ALIGNABLE_ANNOTATION", @elan_parser_xml)

				alignable_annotation_node["ANNOTATION_ID"] = annotation.alignable_annotation.id.to_s
				alignable_annotation_node["TIME_SLOT_REF1"] = annotation.time_slot_ref1.id.to_s
				alignable_annotation_node["TIME_SLOT_REF2"] = annotation.time_slot_ref2.id.to_s

				annotation_value_node = Nokogiri::XML::Node.new("ANNOTATION_VALUE", @elan_parser_xml)
				annotation_value_node.content = annotation.alignable_annotation.annotation_value

				alignable_annotation_node.add_child(annotation_value_node)
				annotation_node.add_child(alignable_annotation_node)
			end
		end
	end
end
