module Document
  module Fields
    class IntegerRangeField < Document::Field

      serialize :validations, Validations::IntegerRangeField
      serialize :options, Options::IntegerRangeField

      def interpret_to(model, overrides: {})
        check_model_validity!(model)

        accessibility = overrides.fetch(:accessibility, self.accessibility)
        return model if accessibility == :hidden

        nested_model = Class.new(::Fields::Embeds::IntegerRange)

        model.nested_models[name] = nested_model

        model.embeds_one name, anonymous_class: nested_model, validate: true
        model.accepts_nested_attributes_for name, reject_if: :all_blank

        interpret_validations_to model, accessibility, overrides
        interpret_extra_to model, accessibility, overrides

        model
      end

    end
  end
end
