module Document
  module Fields
    class RadioField < Document::Field

      serialize :validations, Validations::RadioField
      serialize :options, Options::RadioField

      def stored_type
        :string
      end

      def attached_choices?
        true
      end

      protected

        def interpret_extra_to(model, accessibility, overrides = {})
          super
          return if accessibility != :read_and_write

          choices = options.choices
          return if choices.empty?

          model.validates name, inclusion: { in: choices }, allow_blank: true
        end

    end
  end
end
