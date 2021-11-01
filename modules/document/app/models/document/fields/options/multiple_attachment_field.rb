module Document
  module Fields::Options
    class MultipleAttachmentField < Document::FieldOptions
      attribute :whitelist, :string, array: true, default: []
      attribute :max_file_size, :integer, default: 10
      attribute :max_file_size_unit, :string, default: "megabytes"
    end
  end
end
