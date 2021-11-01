module Document
  module Fields
    class SelectField < Document::Field

      serialize :validations, Validations::SelectField
      serialize :options, Options::SelectField

      def stored_type
        :string
      end

      def attached_choices?
        true
      end

      protected

        def interpret_extra_to(model, accessibility, overrides = {})
          super
          return if accessibility != :read_and_write || !options.strict

          model.validates name, inclusion: { in: options.choices }, allow_blank: true
        end

    end
  end
end
