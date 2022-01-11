class Forms::DataController < Forms::ApplicationController
  before_action :set_form_with_eager_load_fields_and_sections, except: [:show]
  before_action :activate_step_form, only: [:new, :create, :edit, :update]
  before_action :data, only: [:show, :edit, :update, :destroy]
  before_action :criteria_builder, only: [:index]
  before_action :query_builder_templates, only: [:index]

  def index
    if params[:search].present?
      @data = model.lazy_search(params[:search])
    else
      if params[:heavy_search].present?
        @data = model.search(params[:heavy_search])
      else
        if params[:advanced_search].present?
          @data = model.run_advanced_search advanced_search_params
        elsif params[:simple_advanced_search].present?
          @data = model.run_advanced_search simple_advanced_search_params
        else
          @data = model.all
        end
      end
    end
    @data = @data.page(params[:page]).per(1)
  rescue => e
    debugger
  end

  def new
    @data = model.new
  end

  def create
    @data = model.new data_params
    if @data.save
      if @form.step && step.present?
        unless last_step
          return redirect_to edit_form_datum_path(@form, @data, {step: step.to_i + 1})
        end
      end
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
      if @form.step && step.present?
        unless last_step
          return redirect_to edit_form_datum_path(@form, @data, {step: step.to_i + 1})
        end
      end
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
      return @data if @data
      @data = model.find(params[:id])
      if(step)
        @data.set_current_step(step.to_i)
      end
      @data
    end

    def criteria_builder
      @criteria_builder ||= model.build_criteria_template(@form)
    end

    def query_builder_templates
      @query_builder_templates ||= Configurations::Form.where(configurable: @form).all
    end

    def advanced_search_params
      (params.permit![:advanced_search] || []).map(&:to_h)
    end

    def simple_advanced_search_params
      (params.permit![:simple_advanced_search] || []).map(&:to_h)
    end

    def step
      params[:step]
    end

    def last_step
      step.to_i + 1 == @form.step_options.total
    end

    def first_step
      step.to_i == 0
    end

    def activate_step_form
      if @form.step
        if step
          @form.activate_step step.to_i
        else
          @form.activate_step_from_uid params[:id]
        end
      end
    end

end
