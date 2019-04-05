require 'active_support/concern'

module Sms::MessagesControllerConcern
  extend ActiveSupport::Concern
  
  included do
  end

  def resend
    @resending = false
    message = Sms::Message.find(params[:id])

    if !(message.nil?) && message.status == "fail"
      @resending = true

      if Sms.resend!(message).nil?
        message.update(status: "fail", log: "Error al reenviar")
      end
    end
    
    respond_to do |format|
      format.js
    end 
  end
end