module Document
  module Fields::Options
    class RatingField < Document::FieldOptions

      attribute :begin_value, :integer
      attribute :end_value, :integer

      validates :begin_value,
                presence: true

      validates :end_value,
                presence: true

      def interpret_to(model, field_name, accessibility, _options = {})
        return unless accessibility == :read_and_write

        klass = model.nested_models[field_name]

        klass.validates :begin,
                        numericality: {
                          greater_than_or_equal_to: begin_value
                        },
                        allow_blank: true

        klass.validates :end,
                        numericality: {
                          less_than_or_equal_to: end_value
                        },
                        allow_blank: true
      end

    end
  end
end
