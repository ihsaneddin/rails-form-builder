class Forms::DataController < Forms::ApplicationController
  before_action :set_form_with_eager_load_fields_and_sections, except: [:show]
  before_action :data, only: [:show, :edit, :update, :destroy]
  before_action :criteria_builder, only: [:index]

  def index
    if params[:search].present?
      @data = model.lazy_search(params[:search])
    else
      if params[:heavy_search].present?
        @data = model.search(params[:heavy_search])
      else
        if params[:advanced_search].present?
          @data = model.run_advanced_search form: @form, array_of_clause_hashes: advanced_search_params
        else
          @data = model.all
        end
      end
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

    def criteria_builder
      @criteria_builder ||= model.build_criteria_template(@form)
    end

    def advanced_search_params
      (params.permit![:advanced_search] || []).map(&:to_h)
    end

end
