require_dependency "sms/application_controller"

module Sms
  class Api::V1::ResponsesController < ActionController::API

    def api_sms_response
      @message = Message.where(id: request.headers["IdSMS"]).first
      
      if !@message.nil? && @message.status = "success" && request.headers["token"].present? && @message.valid_key?(request.headers["token"])
        @response = @message.responses.new(text: request.headers["response"])

        if @response.save
          render json: :ok, status: :ok     
        else
          render json: :fail, status: :bad_request
        end
      else
        render json: :fail, status: :bad_request
      end
    end
  end
end
