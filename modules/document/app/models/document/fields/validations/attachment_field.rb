module Document
  module Fields
    module Validations
      class AttachmentField < FieldOptions
        include Document::Concerns::Models::Fields::Validations::Presence
      end
    end
  end
end
