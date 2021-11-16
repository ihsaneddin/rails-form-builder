module ApplicationHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show", role: "alert") do
        concat content_tag(:button, '', class: "btn-close", data: { bs_dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def display_error_validations object
    if object.errors.any?
      render partial: "shared/errors", locals: { object: object }
    end
  end

  def smart_form_fields_path(form)
    case form
    when Document::Form
      form_fields_path(form)
    when Document::NestedForm
      nested_form_fields_path(form)
    else
      raise "Unknown form: #{form.class}"
    end
  end

end
