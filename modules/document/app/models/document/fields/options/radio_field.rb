module Document
  module Fields::Options
    class RadioField < BaseOptions
      embeds_many :choices, class_name: "Document::Fields::Options::CheckboxField::Choices"
      accepts_nested_attributes_for :choices, reject_if: :all_blank, allow_destroy: true

      class Choices < Document::FieldOptions

        attribute :label, :string
        attribute :value, :string

      end
    end
  end
end
