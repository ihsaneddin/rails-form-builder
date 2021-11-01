module Document
  module Fields::Options
    class TextField < Document::FieldOptions

      attribute :multiline, :boolean, default: false

    end
  end
end
