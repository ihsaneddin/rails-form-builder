class Forms::PreviewsController < Forms::ApplicationController
  skip_before_action :set_form
  before_action :set_form_with_eager_load_fields_and_sections

  def show
    @instance = instance_id ? model.find(instance_id) : model.new
  end

  def create
    @instance = @preview.new(preview_params)
    @instance.form_id = @form.id
    if @instance.save
      render :create
    else
      render :show
    end
  end

  private

    def instance_id
      params[:instance_id]
    end

    def model
      @model ||= @form.to_virtual_model
    rescue => e
      logger.error(e.backtrace)
      raise e
    end

    def model_params
      params.fetch(:model, {}).permit!
    end

end
