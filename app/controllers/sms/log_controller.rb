require_dependency "sms/application_controller"

module Sms
  class LogController < ApplicationController
    include Sms::LogControllerConcern

    # def show
    #   super
    # end

  end
end
