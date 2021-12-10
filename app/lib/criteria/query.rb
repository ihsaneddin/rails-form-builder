module Criteria
  class Query

    attr_accessor :clauses, :form, :virtual_model

    def initialize clauses: [], form:, virtual_model: nil
      self.form = form
      self.virtual_model = virtual_model || form.to_virtual_model
      self.clauses = clauses
    end

    def run
      model = virtual_model
      clauses.with_object(model) do |clause, model|
        logical_operator = clause.logical_operator || :where
        model.send(logical_operator, clause.to_criteria)
      end
    end

    class << self

      def build form:, virtual_model: nil, array_of_clause_hashes: []
        clauses = array_of_clause_hashes.map{|h| Clause.new(hash) }
        self.new(form: form, virtual_model: virtual_model, clauses: clauses)
      end

    end

  end
end