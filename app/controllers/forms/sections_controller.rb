class Forms::SectionsController < Forms::ApplicationController
  before_action :set_section, only: %i[show edit update destroy]

  def index
    @sections = @form.sections.all
  end

  def new
    @section = @form.sections.build
  end

  def edit; end

  def create
    @section = @form.sections.build(section_params)

    if @section.save
      redirect_to form_sections_url(@form), notice: "Section was successfully created."
    else
      render :new
    end
  end

  def update
    if @section.update(section_params)
      redirect_to form_sections_url(@form), notice: "Section was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @section.destroy
    redirect_to form_sections_url(@form), notice: "Section was successfully destroyed."
  end

  private

    def set_section
      @section = @form.sections.find(params[:id])
    end

    def section_params
      params.fetch(:section, {}).permit(:title, :headless)
    end
end
