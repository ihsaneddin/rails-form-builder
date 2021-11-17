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

      def access_hidden?
        _name = "#{@model.name.to_s}_data"
        target.class.attribute_names.exclude?(_name) && target.class._reflections.keys.exclude?(_name) rescue false
      end

    end
  end
end
