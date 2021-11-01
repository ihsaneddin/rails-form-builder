module Document
  module Fields::Options
    class CheckboxField < Document::FieldOptions
      attribute :choices, :string, array: true, default: []
    end
  end
end
