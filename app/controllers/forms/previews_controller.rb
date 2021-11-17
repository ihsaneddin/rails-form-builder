class Forms::PreviewsController < Forms::ApplicationController
  skip_before_action :set_form
  before_action :set_form_with_eager_load_fields_and_sections
  before_action :set_preview

  def show
    @instance = @preview.new
    fields = []
    @form.sections.first.fields.each {|field| fields << present(field, target: @instance) }
  end

  def create
    @instance = @preview.new(preview_params)
    if @instance.valid?
      render :create
    else
      render :show
    end
  end

  private

    def set_preview
      @preview = @form.to_virtual_model
    rescue => e
      debugger
      raise e
    end

    def preview_params
      params.fetch(:preview, {}).permit!
    end

    def present(model, options = {})
      klass = options.delete(:presenter_class) || "Document::Fields::#{model.class.name.demodulize}Presenter".constantize
      presenter = klass.new(model, self, options)

      yield(presenter) if block_given?

      presenter
    end
end
