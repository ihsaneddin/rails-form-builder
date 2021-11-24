module Document
  module Fields
    class CheckboxField < Document::Field

      serialize :validations, Validations::CheckboxField
      serialize :options, Options::CheckboxField

      def stored_type
        :array
      end

      def interpret_to(model, overrides: {})
        check_model_validity!(model)

        accessibility = overrides.fetch(:accessibility, self.accessibility)
        return model if accessibility == :hidden

        model.field name, type: Array, default: []
        model.attr_readonly name if accessibility == :readonly

        interpret_validations_to model, accessibility, overrides
        interpret_extra_to model, accessibility, overrides

        model
      end

      protected

        def interpret_extra_to(model, accessibility, overrides = {})
          super
          return if accessibility != :read_and_write

          choices = options.choices
          return if choices.empty?
          model.validates_with Document::Concerns::Models::Fields::Validators::SubsetValidator, _merge_attributes([name, in: options.choices.pluck(:value) , allow_blank: true])
        end

    end
  end
end
