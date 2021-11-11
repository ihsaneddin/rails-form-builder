class FormsController < ApplicationController
  layout "application"

  before_action :set_form, only: %i[edit update destroy]

  def index
    @forms = Document::Form.all
  end

  def new
    @form = Document::Form.new
  end

  def edit; end

  def create
    @form = Document::Form.new(form_params)
    if @form.save
      redirect_to form_fields_url(@form), notice: "Form was successfully created."
    else
      render :new
    end
  end

  def update
    if @form.update(form_params)
      redirect_to form_fields_url(@form), notice: "Form was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @form.destroy
    redirect_to forms_url, notice: "Form was successfully destroyed."
  end

  private

    def set_form
      @form = Document::Form.find(params[:id])
    end

    def form_params
      params.fetch(:form, {}).permit(:title, :name, :description)
    end
end
