require 'nokogiri'

module ElanParser
	module XML
		class Save
      attr_reader :validation_errors, :pkey_id

			def initialize(eaf_xml, file_name)
        #Validate the XML
        elan_validator = ElanParser::Helper::Validator.new
        nokogiri_doc = Nokogiri::XML(eaf_xml)
        @validation_errors = elan_validator.validate_elan_xml(nokogiri_doc)
        @pkey_id = 0

        if (@validation_errors.size == 0) then
          parsed_annotation_document = ElanParser::XML::AnnotationDocument.parse(eaf_xml)
          annotation_document = create_annotation_document(parsed_annotation_document, file_name)
          #Duplicate file names are possible, set up the ID so it can be joined upstream
          @pkey_id = annotation_document.id

          create_linguistic_type(parsed_annotation_document, annotation_document)
          create_locale(parsed_annotation_document, annotation_document)
          create_constraint(parsed_annotation_document, annotation_document)

          header = create_header(parsed_annotation_document, annotation_document)
          media_descriptors = create_media_descriptors(parsed_annotation_document)
          join_header_media_descriptors(header, media_descriptors)

          properties = create_properties(parsed_annotation_document)
          join_header_properties(header, properties)
          
          #Create any new time slots, then assign them to the time order in this document.
          time_slot_ref = create_time_orders(parsed_annotation_document, annotation_document)
          create_annotations(parsed_annotation_document, time_slot_ref, annotation_document)
        end
			end

			def create_annotations(doc, time_slot_ref, annotation_document)
				#Loop through the tiers, save them, then loop thru and save the annotations. Then link them to the tiers.
				doc.tiers.each do |t|

					#Create tier ActiveRecord object
					tier = create_tier(t)

					#Bind the annotation document and the tier
          annotation_document.tiers.push(
            tier
          )

					#Loop through each annotation within the tier, save it, and link it.
					t.annotations.each do |a|
						a.alignable_annotations.each do |aa|
							alignable_annotation = create_alignable_annotation(aa)

							annotation = create_annotation(alignable_annotation)

              tier.annotations.push(annotation)

							#Tie the time slots and annotations together.
              ts_ref1 = ElanParser::DB::TimeSlot.find_by_time_value(
                time_slot_ref[aa.time_slot_ref1]
              )

              ts_ref2 = ElanParser::DB::TimeSlot.find_by_time_value(
                time_slot_ref[aa.time_slot_ref2]
              )

              ElanParser::DB::AlignableAnnotationTimeSlot.create(
                :time_slot_ref1 => ts_ref1,
                :time_slot_ref2 => ts_ref2,
                :alignable_annotation => alignable_annotation
              )
						end
					end
				end
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

			def create_tier(happymapper_tier)
				#Create tier ActiveRecord object
					tier = ElanParser::DB::Tier.create(
					:tier_id => happymapper_tier.tier_id,
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

			def create_annotation_document(doc, file_name)
				annotation_document = ElanParser::DB::AnnotationDocument.create(
					:author => doc.author,
					:date => doc.date,
					:format => doc.format,
					:version => doc.version,
					:file_name => file_name,
					:xsi_no_name_space_schema_location => doc.xmlns_nonamespaceschemalocation
				)

        return annotation_document
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

			def create_media_descriptors(doc)
				media_descriptors = Array.new

				doc.header.media_descriptors.each_with_index do |m, index|
					media_descriptors[index] = ElanParser::DB::MediaDescriptor.create(
            :media_url => File.basename(m.media_url),
						:relative_media_url => File.basename(m.media_url),
						:mime_type => m.mime_type,
						:time_origin => m.time_origin,
						:extracted_from => m.extracted_from
					)
				end

				return media_descriptors
			end

			def join_header_media_descriptors(header, media_descriptors)
				media_descriptors.each do |md|
          header.media_descriptors.push(md)
				end
			end

			def create_header(doc, annotation_document)
				header = ElanParser::DB::Header.create(
					:time_units => doc.header.time_units,
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
          header.properties.push(property)
				end
			end

			def create_time_orders(doc, annotation_document)
        time_slot_ref = Hash.new

				#Create our time order and then link the time order with the time slots
				time_order = ElanParser::DB::TimeOrder.create(
					:annotation_document => annotation_document
				)

        doc.time_order.time_slots.each do |t|
          #time_slot_ref[t.time_value] = t.time_slot_id
          time_slot_ref[t.time_slot_id] = t.time_value

          time_order.time_slots.push(
            ElanParser::DB::TimeSlot.find_or_create_by_time_value(
              t.time_value
            )
          )
        end

        return time_slot_ref
			end
		end
	end
end
