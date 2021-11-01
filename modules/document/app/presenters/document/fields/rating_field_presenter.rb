module Document
  module Fields
    class RatingFieldPresenter < CompositeFieldPresenter

      def value_for_preview
        record = value
        return unless record

        "#{record.begin} ~ #{record.end}"
      end

      def begin
        min
      end

      def end
        max
      end

      def weight
        @model.options.weights[value] || value
      end

      private

        def begin_disabled?
          access_readonly?
        end

        def end_disabled?
          access_readonly?
        end

        def min
          return if begin_disabled?
          @model.options.begin_value
        end

        def max
          return if end_disabled?
          @model.options.end_value
        end

    end
  end
end
