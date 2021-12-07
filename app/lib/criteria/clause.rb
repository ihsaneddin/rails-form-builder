module Criteria
  class Clause

    attr_accessor :comparison_operator, :type, :field, :values, :choices, :logical_operator, :casted_hash, :label, :placeholder

    DATA_TYPES = {
      :integer => Integer,
      :float => Float,
      :big_decimal => BigDecimal,
      :boolean => ActiveModel::Type::Boolean,
      :date => Date,
      :date_time => DateTime,
      :object_id => BSON::ObjectId,
      :array => Array,
      :hash => Hash,
      :binary => BSON::Binary,
      :range => Range,
      :set => Set,
      :string => String,
      :symbol => Symbol,
      :time => Time,
      :time_with_zone => ActiveSupport::TimeWithZone
    }

    COMPARISON_OPERATORS = {
      eq: { symbol: "$eq", name: "Equal" },
      like: { symbol: "$eq", name: "Like", only: [:string] },
      ilike: { symbol: "$eq", name: "Ilike", only: [:string] },
      gt: { symbol: "$gt", name: "Greater Than", only: [:integer, :big_decimal, :float, :time] },
      gte: { symbol: "$gt", name: "Greater Than or Equal", only: [:integer, :big_decimal, :float, :time]},
      lt: { symbol: "$lt", name: "Less Than", only: [:integer, :big_decimal, :float, :time]},
      lte: { symbol: "$lt", name: "Less Than or Equal", only: [:integer, :big_decimal, :float, :time]},
      in: { symbol: "$in", name: "Inclusion" },
      nin: { symbol: "$nin", name: "Exclusion"},
      not_equal: { symbol: "$ne", name: "Not Equal"},
    }

    LOGICAL_OPERATORS = {
      and: { symbol: "$and", name: "And" },
      or: { symbol: "$or", name: "Or" },
    }

    def initialize values: nil, type: :string, field:, comparison_operator: :eq,logical_operator: nil, choices: nil, placeholder: nil, label: nil
      self.values = values
      self.type = type.to_sym
      self.field = field
      self.comparison_operator = comparison_operator.to_sym
      self.logical_operator = logical_operator.try(:to_sym)
      self.choices = choices
      self.label = label
      self.placeholder = placeholder
      cast_clause!
    end

    def comparison_operators
      COMPARISON_OPERATORS.select{|k,v| v[:only] ? v[:only].include?(self.type) : v }
    end

    def logical_operators
      LOGICAL_OPERATORS
    end

    def data_type
      DATA_TYPES[self.types]
    end

    def cast_clause!
      case self.type
      when BigDecimal
        self.values = self.values.to_s unless values.is_a?(String)
      when Array
        self.values = self.values.to_s.gsub(/\s+/, "").split(",") unless values.is_a?(Array)
      end
    end

    def to_criteria
      if verified?
        {
          "#{field}": { comparison_operator[comparison_operator].symbol => values }
        }
      end
    end

    def verified?
      comparison_operators.dig(self.comparison_operator.to_sym)
    end

  end
end