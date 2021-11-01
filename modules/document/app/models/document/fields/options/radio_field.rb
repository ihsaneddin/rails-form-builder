module Document
  module Fields::Options
    class RadioField < Document::FieldOptions
      attribute :choices, :string, array: true, default: []
    end
  end
end
