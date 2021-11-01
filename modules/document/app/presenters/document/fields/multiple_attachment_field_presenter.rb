module Document
  module Fields
    class MultipleAttachmentFieldPresenter < FieldPresenter

      def value_for_preview
        ids = value
        return if ids.blank?

        blobs = Document::Attachment.where(id: ids)
        return if blobs.blank?

        blobs.map{|blob| Document::UploadPresenter.new(blob).present }
      end

    end
  end
end
