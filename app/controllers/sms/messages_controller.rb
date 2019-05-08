require_dependency "sms/application_controller"

module Sms
  class MessagesController < ApplicationController
    include Sms::MessagesControllerConcern

    # def resend
    #   super
    # end
    
    # def cancel
    #   super
    # end

  end
end
