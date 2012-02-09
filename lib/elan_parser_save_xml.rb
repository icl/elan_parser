
module ElanParser
	module Xml
		class Save
			def initialize(parsed_annotation_document, project)
				annotation_document = create_annotation_document(parsed_annotation_document, project)

				create_linguistic_type(parsed_annotation_document, annotation_document)
				create_locale(parsed_annotation_document, annotation_document)
				create_constraint(parsed_annotation_document, annotation_document)

				header = create_header(parsed_annotation_document, annotation_document)
				media_descriptors = create_media_descriptors(parsed_annotation_document)
				join_header_media_descriptors(header, media_descriptors)

				properties = create_properties(parsed_annotation_document)
				join_header_properties(header, properties)
				
				#Create any new time slots, then assign them to the time order in this document.
				time_slots = create_time_slots(parsed_annotation_document)
				create_time_orders(parsed_annotation_document, time_slots, annotation_document)
				create_annotations(parsed_annotation_document, time_slots, annotation_document)
			end

			def create_annotations(doc, time_slots, annotation_document)
				#Loop through the tiers, save them, then loop thru and save the annotations. Then link them to the tiers.
				doc.tiers.each do |t|

					#Create tier ActiveRecord object
					tier = create_tier(t)

					#Bind the annotation document and the tier
					join_annotation_document_tier(tier, annotation_document)

					#Loop through each annotation within the tier, save it, and link it.
					t.annotations.each do |a|
						#puts a.alignable_annotations.inspect

						a.alignable_annotations.each do |aa|
							alignable_annotation = create_alignable_annotation(aa)

							annotation = create_annotation(alignable_annotation)

							join_annotation_tier(annotation, tier)
#
							#Tie the time slots and annotations together.
							join_annotation_time_slot(time_slots, alignable_annotation, aa)
						end
					end
				end
			end

			def join_annotation_document_tier(tier, annotation_document)
				ElanParser::DB::AnnotationDocumentTier.find_or_create_by_tier_id_and_annotation_document_id(
					tier.id,
					annotation_document.id
				)
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

			#Incomplete
			def create_linguistic_type(parsed_annotation_document, annotation_document)
				parsed_annotation_document.linguistic_types.each do |linguistic_type|
					linguistic_type = ElanParser::DB::LinguisticType.create(
						:graphic_references => linguistic_type.graphic_references.to_s,
						:linguistic_type_id =>  linguistic_type.linguistic_type_id,
						:time_alignable => linguistic_type.time_alignable,
						:constraints => linguistic_type.constraints,
						:controlled_vocabulary_ref => linguistic_type.controlled_vocabulary_ref,
						:ext_ref => linguistic_type.ext_ref,
						:lexicon_ref => linguistic_type.lexicon_ref
					)

					join_annotation_document_linguistic_type(annotation_document, linguistic_type)
				end
			end

			def join_annotation_document_linguistic_type(annotation_document, linguistic_type)
				ElanParser::DB::AnnotationDocumentLinguisticType.create(
					:annotation_document => annotation_document,
					:linguistic_type => linguistic_type
				)
			end

			def create_locale(parsed_annotation_document, annotation_document)
				parsed_annotation_document.locales.each do |locale|
					locale = ElanParser::DB::Locale.create(
						:language_code => locale.language_code,
						:country_code => locale.country_code,
						:variant => locale.variant
					)

					join_annotation_document_locale(annotation_document, locale)
				end
			end

			def join_annotation_document_locale(annotation_document, locale)
				ElanParser::DB::AnnotationDocumentLocale.create(
					:annotation_document => annotation_document,
					:locale => locale
				)
			end

			def create_constraint(parsed_annotation_document, annotation_document)
				parsed_annotation_document.constraints.each do |constraint|
					constraint = ElanParser::DB::Constraint.create(
						:stereotype => constraint.stereotype,
						:description => constraint.description
					)

					join_annotation_document_constraint(annotation_document, constraint)
				end
			end

			def join_annotation_document_constraint(annotation_document, constraint)
				ElanParser::DB::AnnotationDocumentConstraint.create(
					:annotation_document => annotation_document,
					:constraint => constraint
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
					:annotation_value => happymapper_alignable_annotation.annotation_value
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
					:xsi_no_name_space_schema_location => doc.xmlns_nonamespaceschemalocation
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
						File.basename(m.media_url),
						:relative_media_url => m.media_url,
						:mime_type => m.mime_type,
						:time_origin => m.time_origin,
						:extracted_from => m.extracted_from
					)
				end

				return media_descriptors
			end

			def join_header_media_descriptors(header, media_descriptors)
				media_descriptors.each do |md|
					ElanParser::DB::HeaderMediaDescriptor.create(
						:header => header,
						:media_descriptor => md
					)
				end
			end

			def create_header(doc, annotation_document)
				header = ElanParser::DB::Header.find_or_create_by_time_units(
					doc.header.time_units,
					:media_file => doc.header.media_file,
					:annotation_document => annotation_document
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

			def join_header_properties(header, properties)
				properties.each do |property|
					ElanParser::DB::HeaderProperty.create(
						:header => header,
						:property => property
					)
				end
			end

			def create_time_orders(doc, time_slots, annotation_document)
				#Create our time order and then link the time order with the time slots
				time_order = ElanParser::DB::TimeOrder.create(
					:annotation_document => annotation_document
				)

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
