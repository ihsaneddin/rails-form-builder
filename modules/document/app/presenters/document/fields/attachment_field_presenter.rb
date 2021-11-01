module Document
  module Fields
    class AttachmentFieldPresenter < FieldPresenter

      def value_for_preview
        id = value
        return if id.blank?
        blob = Document::Attachment.find_by id: id
        return unless  blob

        Document::UploadPresenter.new(blob).present
      end

    end
  end
end
