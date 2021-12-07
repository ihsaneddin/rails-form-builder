class Forms::DataController < Forms::ApplicationController
  before_action :set_form_with_eager_load_fields_and_sections, except: [:show]
  before_action :data, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @data = model.search(params[:search])
    else
      @data = model.all
    end
    @data = @data.page(params[:page]).per(1)
  end

  def new
    @data = model.new
  end

  def create
    @data = model.new data_params
    if @data.save
      redirect_to form_datum_path(@form, @data), notice: "Data was successfully created."
    else
      render :new
    end
    rescue => e
      debugger
  end

  def show
  end

  def edit
  end

  def update
    if @data.update data_params
      redirect_to form_datum_path(@form, @data), notice: "Data was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    data.destroy
    redirect_to form_data_path, notice: "Data was successfully destroyed."
  end

  private

    def model
      @model ||= @form.to_virtual_model
    end

    def data_params
      params.fetch(:data, {}).permit!
    end

    def data
      @data = model.find(params[:id])
    end

end
