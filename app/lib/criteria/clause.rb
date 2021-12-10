module Criteria
  class Clause

    attr_accessor :comparison_operator, :type, :field, :values, :choices, :logical_operator, :casted_hash, :label, :placeholder, :namespace

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
      gt: { symbol: "$gt", name: "Greater Than", only: [:integer, :big_decimal, :float, :time, :date, :date_time] },
      gte: { symbol: "$gt", name: "Greater Than or Equal", only: [:integer, :big_decimal, :float, :time, :date, :date_time]},
      lt: { symbol: "$lt", name: "Less Than", only: [:integer, :big_decimal, :float, :time]},
      lte: { symbol: "$lt", name: "Less Than or Equal", only: [:integer, :big_decimal, :float, :time]},
      in: { symbol: "$in", name: "Inclusion" },
      nin: { symbol: "$nin", name: "Exclusion"},
      ne: { symbol: "$ne", name: "Not Equal"},
    }

    LOGICAL_OPERATORS = {
      and: { symbol: "$and", name: "And" },
      or: { symbol: "$or", name: "Or" },
    }

    attr_accessor :logical_operators, :comparison_operators

    def initialize values: nil, type: :string, field:, comparison_operator: :eq,logical_operator: nil, choices: nil, placeholder: nil, label: nil, namespace: nil
      self.values = values
      self.type = type.to_sym
      self.field = field
      self.comparison_operator = comparison_operator.to_sym
      self.logical_operator = logical_operator.try(:to_sym)
      self.choices = choices
      self.label = label
      self.placeholder = placeholder
      self.namespace = namespace
      self.logical_operators = LOGICAL_OPERATORS
      self.comparison_operators = COMPARISON_OPERATORS.select{|k,v| v[:only] ? v[:only].include?(self.type) : v }
      cast_clause!
    end

    def data_type
      DATA_TYPES[self.type]
    end

    def cast_clause!
      case self.data_type
      when BigDecimal
        self.values = self.values.to_s unless values.is_a?(String)
      when Array
        self.values = self.values.to_s.gsub(/\s+/, "").split(",") unless values.is_a?(Array)
      when ActiveModel::Type::Boolean
        self.values = ActiveModel::Type::Boolean.new.cast(self.values)
      end
    end

    def to_criteria
      if verified?
        if [:ilike, :like].include?(comparison_operator)
          val = comparison_operator == :like ? /#{values}/ : /#{values}/i
          {
            "#{field}": val
          }
        else
          {
            "#{field}": { comparison_operators[comparison_operator][:symbol] => values }
          }
        end
      end
    end

    def verified?
      comparison_operators.dig(self.comparison_operator.to_sym)
    end

  end
end