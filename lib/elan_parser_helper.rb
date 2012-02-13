module ElanParser
  module Helper
    def destroy_children(annotation_document)
      annotation_document.header.media_descriptors.each do |md|
        md.destroy
      end

      annotation_document.header.properties.each do |p|
        p.destroy
      end

      annotation_document.time_order.time_slots.each do |ts|
        ts.destroy
      end

      annotation_document.tiers.each do |t|
        t.annotations.each do |a|
          a.alignable_annotation.destroy
          a.destroy
        end

        t.destroy
      end

      annotation_document.linguistic_types.each do |l|
        l.destroy
      end

      annotation_document.constraints.each do |c|
        c.destroy
      end

      annotation_document.locales.each do |l|
        l.destroy
      end
    end
  end
end
