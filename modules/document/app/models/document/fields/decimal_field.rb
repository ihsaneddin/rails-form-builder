module Document
  module Fields
    class DecimalField < Document::Field

      serialize :validations, Validations::DecimalField
      serialize :options, Options::DecimalField

      def stored_type
        :decimal
      end

    end
  end
end
