module Criteria
  class Query

    attr_accessor :clauses, :form, :virtual_model

    def initialize clauses: [], form:, virtual_model: nil
      self.form = form
      self.virtual_model = virtual_model || form.to_virtual_model
      self.clauses = clauses
    end

    def perform_query
      model = virtual_model
      clauses.with_object(model) do |clause, model|
        logical_operator = clause.logical_operator || :where
        model.send(logical_operator, clause.to_criteria)
      end
    end

    class << self

      def build form:, virtual_model: nil
        fields = []
        form.sections.each do |section|
          fields = fields + section.fields
        end
        clauses = build_hash_of_clause(fields)
        self.new(form: form, virtual_model: virtual_model, clauses: clauses)
      end

      def build_hash_of_clause fields, namespace = nil
        fields.reject{|f| f.file_field? }.each_with_object([]) do |field, collection|
          name = namespace ? "#{namespace}.#{field.name}" : field.name
          if field.attached_nested_form?
            collection + build_hash_of_clause(field.nested_form.fields, name)
          else
            if field.range_field?
              from = Clause.new(comparison_operator: :eq, type: field.stored_type, field: "#{name}.begin")
              to = Clause.new(comparison_operator: :eq, type: field.stored_type, field: "#{name}.end")
              collection + [from, to]
            else
              hash = {comparison_operator: :eq, type: field.stored_type, field: name }
              if field.has_choices_option?
                hash[:choices] = field.options.choices
              end
              clause = Clause.new hash
              collection << clause
            end
          end
        end
      end

    end

  end
end