require_dependency "sms/application_controller"

module Sms
  class ConfigsController < ApplicationController

    include Sms::ConfigsControllerConcern

    # def show
    #   super
    # end

    # def new
    #   super
    # end

    # def edit
    #   super
    # end
    
    # def create
    #   super
    # end

    # def update
    #   super
    # end

    # private

    #   def build_time
    #     super
    #   end

    #   def config_params
    #     params.require(:config).permit(:delivery_method, :time, :template, :cant, :key)
    #   end

  end
end
