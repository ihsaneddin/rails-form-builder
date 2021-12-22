class Forms::ConfigurationsFormsController < Forms::ApplicationController
  before_action :set_configuration, only: %i[show edit update destroy]
  before_action :criteria_builder, only: %i[new create edit update]

  def index
    @configurations = Configurations::Form.where(:configurable => @form).all
  end

  def new
    @configuration = Configurations::Form.new(configurable: @form)
  end

  def edit; end

  def create
    @configuration = Configurations::Form.new(configuration_params)
    @configuration.configurable = @form
    @configuration.data.assign_attributes(data_params)
    if @configuration.data.valid? && @configuration.save
      redirect_to form_configurations_forms_path(@form), notice: "Search configuration was successfully created."
    else
      render :new
    end
  end

  def update
    @configuration.data.assign_attributes(data_params)
    if @configuration.data.valid? && @configuration.update(configuration_params)
      redirect_to form_configurations_forms_path(@form), notice: "Search configuration was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @configuration.destroy
    redirect_to form_configurations_forms_path(@form), notice: "Search configuration was successfully destroyed."
  end

  private

    def set_configuration
      @configuration = Configurations::Form.where(:configurable => @form).find(params[:id])
    end

    def criteria_builder
      @criteria_builder ||= virtual_model.build_criteria_template(@form)
    end

    def virtual_model
      @virtual_model ||= @form.to_virtual_model
    end

    def configuration_params
      params.fetch(:configuration, {}).permit(:name)
    end

    def data_params
      (params.dig(:configuration, :data) || {}).permit(clauses_attributes: [:ignore_blank_values, :field, :type, :comparison_operator, :logical_operator, :label, :placeholder, :namespace, choices_attributes: [:label, :value]])
    end

end
