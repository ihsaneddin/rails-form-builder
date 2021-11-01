module Document
  module Concerns
    module Models
      module Form
        extend ActiveSupport::Concern

        def to_virtual_model(model_name: "Document::Form",
                            fields_scope: proc { |fields| fields },
                            overrides: {})
          model = Document.virtual_model_class.build model_name
          append_to_virtual_model(model, fields_scope: fields_scope, overrides: overrides)
        end

        def append_to_virtual_model(model,
                                    fields_scope: proc { |fields| fields },
                                    overrides: {})
          check_model_validity! model

          global_overrides = overrides.fetch(:_global, {})
          fields_scope.call(fields).each do |f|
            f.interpret_to model, overrides: global_overrides.merge(overrides.fetch(f.name, {}))
          end
          model.form = self
          model
        end

        private

          def check_model_validity!(model)
            unless model.is_a?(Class) && model < ::Document::VirtualModel
              raise ArgumentError, "#{model} must be a #{::Document::VirtualModel}'s subclass"
            end
          end
      end
    end
  end
end
