module Document
  class VirtualModel

    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include Document::Concerns::Models::ActiveStorageBridge::Attached::Macros

    # Hack
    ARRAY_WITHOUT_BLANK_PATTERN = "!ruby/array:ArrayWithoutBlank"

    def dump
      self.class.dump(self).gsub(ARRAY_WITHOUT_BLANK_PATTERN, "")
    end

    class << self

      delegate :dump, :load, to: :coder, allow_nil: false

      def coder
        @_coder ||= Document.virtual_model_coder_class.new(self)
      end

      def attr_readonly?(attr_name)
        readonly_attributes.include? attr_name.to_s
      end

      def coder=(klass)
        raise ArgumentError, "#{klass} should be sub-class of #{Coder}." unless klass && klass < Coder

        @_coder = klass.new(self)
      end

      def name
        @_name ||= "Form"
      end

      def name=(value)
        value = value.classify
        raise ArgumentError, "`value` isn't a valid class name" if value.blank?

        @_name = value
      end

      def build(name: nil, collection: nil)
        if collection
          self.store_in collection: collection
        end
        klass = Class.new(self)
        klass.name = name
        klass
      end

      def nested_models
        @nested_models ||= {}
      end

    end

  end
end
