class Fields::ApplicationController < ApplicationController
  before_action :set_field

  protected

    def set_field
      @field = Document::Field.find(params[:field_id])
    end

    def fields_url
      form = @field.form

      case form
      when Document::Form
        form_fields_url(form)
      when Document::NestedForm
        nested_form_fields_url(form)
      else
        raise "Unknown form: #{form.class}"
      end
    end
end
