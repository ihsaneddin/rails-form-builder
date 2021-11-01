module Document
  class NestedForm < BareForm

    belongs_to :attachable, polymorphic: true, touch: true, inverse_of: :nested_form

    attr_accessor :virtual_fields

  end
end
