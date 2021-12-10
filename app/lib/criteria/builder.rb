module Criteria
  class Builder

    attr_accessor :clauses, :form, :virtual_model

    def initialize clauses: [], form:, virtual_model: nil
      self.form = form
      self.virtual_model = virtual_model || form.to_virtual_model
      self.clauses = clauses
    end

    class << self

      def build form:, virtual_model: nil
        fields = []
        form.sections.each do |section|
          fields = fields + section.fields
        end
        clauses = build_clauses(fields)
        self.new(form: form, virtual_model: virtual_model, clauses: clauses)
      end

      def build_clauses fields, namespace = nil
        fields.reject{|f| f.file_field? }.each_with_object([]) do |field, collection|
          nested = namespace.to_s.split(".").map(&:humanize).map(&:titleize).join("/")
          name = namespace ? "#{namespace}.#{field.name}" : field.name
          if field.attached_nested_form?
            collection.push(*build_clauses(field.nested_form.fields, name))
          else
            if field.range_field?
              from = Clause.new(comparison_operator: :eq, type: field.stored_type, field: "#{name}.begin", label: field.label, namespace: nested)
              to = Clause.new(comparison_operator: :eq, type: field.stored_type, field: "#{name}.end", label: field.label, namespace: nested)
              collection + [from, to]
            else
              hash = {comparison_operator: :eq, type: field.stored_type, field: name, label: field.label, namespace: nested}
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