module Document
  module Fields::Options
    class MultipleSelectField < Document::FieldOptions
      attribute :strict, :boolean, default: true
      attribute :choices, :string, array: true, default: []
    end
  end
end
