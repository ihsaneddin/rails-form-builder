module Document
  class Section < ApplicationRecord

    self.table_name = "document_sections"

    belongs_to :form, touch: true, inverse_of: :sections

    has_many :fields, -> { order(position: :asc) }, dependent: :nullify, inverse_of: :section, index_errors: true
    accepts_nested_attributes_for :fields, allow_destroy: true
    alias_method :inputs=, :fields_attributes=

    include RankedModel
    ranks :position, with_same: [:form_id]

    validates :title, presence: true, unless: :headless

    def virtual_fields instance, _fields = nil
      _fields ||= fields.rank(:position)
      _fields.map do |field|
        vp = present_virtual_field(field, target: instance)
        if field.nested_form && vp.value_for_preview
          if vp.multiple_nested_form?
            field.nested_form.virtual_fields = []
            vp.value_for_preview.each do |nested_instance|
              field.nested_form.virtual_fields << virtual_fields(nested_instance, field.nested_form.fields.rank(:position))
            end
          else
            field.nested_form.virtual_fields = virtual_fields vp.value_for_preview, field.nested_form.fields.rank(:position)
          end
        end
        vp
      end.reject(&:access_hidden?)
    end

    protected

      def present_virtual_field(model, options = {})
        klass = options.delete(:presenter_class) || "#{model.class}Presenter".constantize
        presenter = klass.new(model, self, options)

        yield(presenter) if block_given?

        presenter
      end

  end
end
