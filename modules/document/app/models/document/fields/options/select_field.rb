module Document
  module Fields::Options
    class SelectField < Document::FieldOptions
      attribute :strict, :boolean, default: true
      attribute :choices, :string, array: true, default: []
    end
  end
end
