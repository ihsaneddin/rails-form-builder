class Forms::FieldsController < Forms::ApplicationController
  before_action :set_field, only: %i[show edit update destroy]

  def index
    @fields = @form.fields.includes(:section).all
  end

  def new
    @field = @form.fields.build
  end

  def edit; end

  def create
    @field = @form.fields.build(field_params)
    if @field.save
      redirect_to form_fields_url(@form), notice: "Field was successfully created."
    else
      render :new
    end
  end

  def update
    if @field.update(field_params)
      redirect_to form_fields_url(@form), notice: "Field was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @field.destroy
    redirect_to form_fields_url(@form), notice: "Field was successfully destroyed."
  end

  private

    def set_field
      @field = @form.fields.find(params[:id])
    end

    def field_params
      params.fetch(:field, {}).permit(:name, :label, :hint, :section_id, :accessibility, :type)
    end
end
