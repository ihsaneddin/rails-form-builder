
module Document
  module Concerns
    module VirtualModels
      module GeneralSearch
        extend ActiveSupport::Concern

        included do

          class_attribute :searchable_fields
          self.searchable_fields = []

          include Mongoid::Search

        end

        module ClassMethods

          def search query, options={}
            full_text_search query, options
          end

          def get_searchable_fields namespace = nil
            relations.each_with_object(searchable_fields).each do |(k,v), collection|
              if v.klass.relations.any? && (v.is_a?(Mongoid::Association::Embedded::EmbedsMany) || v.is_a?(Mongoid::Association::Embedded::EmbedsOne))
                collection << { k.to_sym => v.klass.get_searchable_fields(k) }
              end
              collection
            end
          end

          def add_as_searchable_field field
            self.searchable_fields << field
          end

        end
      end
    end
  end
end
