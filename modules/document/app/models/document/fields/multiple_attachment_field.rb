module Document
  module Fields
    class MultipleAttachmentField < Document::Field

      after_save do
        unless nested_form
          build_nested_form.save! unless nested_form.present?
          nested_form.fields.build({name: name, label: name, type: "Document::Fields::AttachmentField"})
        end
      end

      serialize :validations, Validations::MultipleAttachmentField
      serialize :options, Options::MultipleAttachmentField

      def attached_nested_form?
        true
      end

      def stored_type
        :string
      end

      ## TODO
      def interpret_to(model, overrides: {})
        check_model_validity!(model)

        accessibility = overrides.fetch(:accessibility, self.accessibility)
        return model if accessibility == :hidden

        nested_model = nested_form.to_virtual_model(overrides: { _global: { accessibility: accessibility } })

        model.nested_models[name] = nested_model

        model.has_many_attached name
        model.attr_readonly name if accessibility == :readonly

        interpret_validations_to model, accessibility, overrides
        interpret_extra_to model, accessibility, overrides

        model
      end

    end
  end
end
