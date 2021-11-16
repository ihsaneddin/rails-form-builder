class NestedForms::ApplicationController < ApplicationController
  layout "nested_forms"

  before_action :set_nested_form

  protected

    def set_nested_form
      @nested_form = Document::NestedForm.find(params[:nested_form_id])
    end
end
