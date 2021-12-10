
require_relative "./advanced_search/query"
require_relative "./advanced_search/builder"
require_relative "./advanced_search/clause"

module Document
  module Concerns
    module VirtualModels
      module AdvancedSearch
        extend ActiveSupport::Concern

        module ClassMethods

          def build_criteria_template form
            Builder.build(form: form, virtual_model: self )
          end

          def run_advanced_search form:, array_of_clause_hashes: []
            Query.build(form: form, virtual_model: self, array_of_clause_hashes: array_of_clause_hashes).run
          end

        end
      end
    end
  end
end
