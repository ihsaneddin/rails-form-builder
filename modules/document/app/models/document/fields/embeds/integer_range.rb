module Document
  module Fields::Embeds
    class IntegerRange < Document::VirtualModel

      attribute :begin, :integer
      attribute :end, :integer

      validates :begin, :end,
                presence: true,
                numericality: { only_integer: true }

      validates :end,
                numericality: {
                  greater_than: :begin
                },
                allow_blank: true,
                if: -> { read_attribute(:begin).present? }

    end
  end
end
