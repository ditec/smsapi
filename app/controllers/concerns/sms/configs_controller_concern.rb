require 'active_support/concern'

module Sms::ConfigsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    before_action :build_time, only:[:create, :update]
  end

  def show
    @config = Sms::Config.last
  end

  def new
    @config = Sms::Config.new
  end

  def edit
    @config = Sms::Config.last
  end

  def create
    @config = Sms::Config.new(config_params)

    if @config.save
      redirect_to config_path, notice: 'Config was successfully created.'
    else
      render :new
    end
  end

  def update
    @config = Sms::Config.last

    if @config.update(config_params)
      redirect_to config_path, notice: 'Config was successfully updated.'
    else
      render :edit
    end
  end

  private

    def build_time
      if !(params[:fixed_time].present?) || (params[:fixed_time].present? && !(params[:fixed_time] == "true"))
        (1..5).each do |index|
          params[:config].delete "time(#{index}i)"
        end
        params[:config].merge!(time: nil) 
      end
    end

    def config_params
      params.require(:config).permit(:delivery_method, :time, :template, :cant, :key)
    end
  
end