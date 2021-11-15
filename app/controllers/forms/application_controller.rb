class Forms::ApplicationController < ApplicationController
  layout "forms"

  before_action :set_form

  protected

    def set_form
      @form = Document::Form.find(params[:form_id])
    end

    def set_form_with_eager_load_fields_and_sections
      @form = Document::Form.includes(:sections, :fields).find(params[:form_id])

      grouped_fields = @form.fields.group_by(&:section_id)
      @form.sections.each do |section|
        association = section.fields.instance_variable_get(:@association)
        association.target.concat grouped_fields.fetch(section.id, []).sort_by(&:position)
        association.loaded!
      end
    end
end
