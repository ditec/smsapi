require_dependency "sms/application_controller"

module Sms
  class Api::V1::MessagesController < ActionController::API

    def api_sms_status_response
      @message = Message.where(id: request.headers["IdSMS"]).first
      
      if !@message.nil? && request.headers["token"].present? && @message.valid_key?(request.headers["token"]) && @message.update(status: request.headers["status"])
        render json: :ok, status: :ok      
      else
        render json: :fail, status: :bad_request
      end
    end

  end
end
