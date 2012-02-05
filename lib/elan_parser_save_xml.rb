
module ElanParser
	module Xml
		class Save
			def initialize(happymapper_document, project)

				annotation_document = create_annotation_document(happymapper_document, project)

				media_descriptors = create_media_descriptors(happymapper_document)
				header = create_header(happymapper_document)
				properties = create_properties(happymapper_document)
				
				#Create any new time slots, then assign them to the time order in this document.
				time_slots = create_time_slots(happymapper_document)
				create_time_orders(happymapper_document, time_slots)
				create_annotations(happymapper_document, time_slots)
			end

			def create_annotations(doc, time_slots)
				#Loop through the tiers, save them, then loop thru and save the annotations. Then link them to the tiers.
				doc.tiers.each do |t|

					#Create tier ActiveRecord object
					tier = create_tier(t)

					#Loop through each annotation within the tier, save it, and link it.
					t.annotations.each do |a|
						a.alignable_annotations.each do |aa|

							alignable_annotation = create_alignable_annotation(aa)

							annotation = create_annotation(alignable_annotation)

							join_annotation_tier(annotation, tier)

							#Tie the time slots and annotations together.
							join_annotation_time_slot(time_slots, alignable_annotation, aa)
						end
					end
				end
			end

			def join_annotation_time_slot(happymapper_time_slots, activerecord_alignable_annotation, happymapper_alignable_annotation)
				ElanParser::DB::AlignableAnnotationTimeSlot.create(
					:time_slot_ref1 => happymapper_time_slots[happymapper_alignable_annotation.time_slot_ref1],
					:time_slot_ref2 => happymapper_time_slots[happymapper_alignable_annotation.time_slot_ref2],
					:alignable_annotation => activerecord_alignable_annotation
				)
			end

			def create_annotation(happymapper_alignable_annotation)
				annotation = ElanParser::DB::Annotation.create(
					:alignable_annotation => happymapper_alignable_annotation
				)
			end

			def join_annotation_tier(annotation, tier)
				#Tie the tier and annotation together.
				ElanParser::DB::AnnotationTier.create(
					:annotation => annotation,
					:tier => tier
				)
			end

			def create_tier(happymapper_tier)
				#Create tier ActiveRecord object
					tier = ElanParser::DB::Tier.find_or_create_by_tier_id(
					happymapper_tier.tier_id,
					:participant => happymapper_tier.participant,
					:annotator => happymapper_tier.annotator,
					:linguistic_type_ref => happymapper_tier.linguistic_type_ref,
					:default_locale => happymapper_tier.default_locale,
					:parent_ref => happymapper_tier.parent_ref
				)

				return tier
			end

			def create_alignable_annotation(happymapper_alignable_annotation)
				alignable_annotation = ElanParser::DB::AlignableAnnotation.find_or_create_by_annotation_value(
					:annotation_value => happymapper_alignable_annotation.value
				)

				return alignable_annotation
			end

			def create_annotation_document(doc, document)
				ElanParser::DB::AnnotationDocument.create(
					:author => doc.author,
					:date => doc.date,
					:format => doc.format,
					:version => doc.version,
					:document => document,
					:xmlns_xsi => doc.xmlnsxsi
				)
			end

			def create_tiers(doc)
				tiers = Array.new

				doc.tiers.each_with_index do |t, index|
					tiers[index] = ElanParser::DB::Tier.find_or_create_by_tier_id(
						t.tier_id,
						:participant => t.participant,
						:annotator => t.annotator,
						:linguistic_type_ref => t.linguistic_type_ref,
						:default_locale => t.default_locale,
						:parent_ref => t.parent_ref
					)
				end

				return tiers
			end
						

			def create_load_project(project)
				ar_project = ElanParser::DB::Project.find_or_create_by_project_name(
					project["name"],
					:description => project["description"]
				)

				return ar_project
			end

			def create_media_descriptors(doc)
				media_descriptors = Array.new

				doc.header.media_descriptors.each_with_index do |m, index|
					media_descriptors[index] = ElanParser::DB::MediaDescriptor.find_or_create_by_media_url(
						m.media_url,
						:relative_media_url => m.media_url,
						:mime_type => m.mime_type,
						:time_origin => m.time_origin,
						:extracted_from => m.extracted_from
					)
				end

				return media_descriptors
			end

			def create_header(doc)
				header = ElanParser::DB::Header.find_or_create_by_time_units(
					doc.header.time_units,
					:media_file => doc.header.media_file
				)

				return header
			end

			def create_properties(doc)
				properties = Array.new

				doc.header.properties.each_with_index do |p, index|
					properties[index] = ElanParser::DB::Property.find_or_create_by_value(
						p.value,
						:name => p.name
					)

				end

				return properties
			end

			def create_time_orders(doc, time_slots)
				#Create our time order and then link the time order with the time slots
				time_order = ElanParser::DB::TimeOrder.create()

				time_slots.each do |time_slot_ref, time_slot|
					ElanParser::DB::TimeOrderTimeSlot.create(
						:time_order => time_order,
						:time_slot => time_slot
					)
				end
			end

			def create_time_slots(doc)
				#Create the time slots and tiers within each time slot
				time_slots = Hash.new

				doc.time_order.time_slots.each do |t|
					time_slots[t.time_slot_id] = 
						ElanParser::DB::TimeSlot.find_or_create_by_time_value(
							t.time_value
						)
				end

				return time_slots
			end
		end
	end
end
