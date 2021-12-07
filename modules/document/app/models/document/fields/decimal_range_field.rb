module Document
  module Fields
    class DecimalRangeField < Document::Field

      serialize :validations, Validations::DecimalRangeField
      serialize :options, Options::DecimalRangeField

      def interpret_to(model, overrides: {})
        check_model_validity!(model)

        accessibility = overrides.fetch(:accessibility, self.accessibility)
        return model if accessibility == :hidden

        nested_model = Document::Fields::Embeds::DecimalRange

        model.nested_models[name] = nested_model

        model.embeds_one name, class_name: nested_model.name, validate: true
        model.accepts_nested_attributes_for name, reject_if: :all_blank
        model.add_as_searchable_field field.name if field.options.try(:searchable)

        interpret_validations_to model, accessibility, overrides
        interpret_extra_to model, accessibility, overrides

        model
      end

      def range_field?
        true
      end

    end
  end
end
