module FieldsHelper
  def options_for_field_types(selected: nil)
    options_for_select(Document::Field.descendants.map { |klass| [klass.model_name.human, klass.to_s] }, selected)
  end

  def options_for_mime_types selected: []
    options_for_select(Mime::EXTENSION_LOOKUP.map{|m| [m[0].titleize, m[1].to_s] }, selected)
  end

  def field_label(form, field_name:)
    field_name = field_name.to_s.split(".").first.to_sym

    form.fields.select do |field|
      field.name == field_name
    end.first&.label
  end

  def options_for_enum_select(klass, attribute, selected = nil)
    container = klass.public_send(attribute.to_s.pluralize).map do |k, v|
      v ||= k
      [klass.human_enum_value(attribute, k), v]
    end

    options_for_select(container, selected)
  end

  def fields_path
    form = @field.form

    case form
    when Form
      form_fields_path(form)
    when NestedForm
      nested_form_fields_path(form)
    else
      raise "Unknown form: #{form.class}"
    end
  end
end
