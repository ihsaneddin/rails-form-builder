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

  def options_for_enum_select(klass, attribute, selected = nil)
    container = klass.public_send(attribute.to_s.pluralize).map do |k, v|
      v ||= k
      [klass.human_enum_value(attribute, k), v]
    end

    options_for_select(container, selected)
  end

end
