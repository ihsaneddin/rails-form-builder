module Document
  module Fields
    module Validations
      class MultipleAttachmentField < FieldOptions
        include Document::Concerns::Models::Fields::Validations::Presence
      end
    end
  end
end
