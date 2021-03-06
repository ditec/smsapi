require 'active_support/concern'

module Sms::MessagesControllerConcern
  extend ActiveSupport::Concern
  
  included do
  end

  def resend
    @resending = false
    message = Sms::Message.find(params[:id])

    unless message.nil?
      @resending = true

      if Sms.resend!(message).nil?
        message.update(status: "fail", log: "Error al reenviar")
      end
    end
    
    respond_to do |format|
      format.js
    end 
  end

  def cancel
    @cancelling = false
    message = Sms::Message.find(params[:id])

    unless message.nil?
      @cancelling = true

      if Sms.cancel!(message).nil?
        message.update(status: "fail", log: "Error al cancelar")
      end
    end
    
    respond_to do |format|
      format.js
    end 
  end

end