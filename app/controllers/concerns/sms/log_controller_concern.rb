require 'active_support/concern'

module Sms::LogControllerConcern
  extend ActiveSupport::Concern
  
  included do
  end

  def index
    @messages = Sms::Message.all.order("created_at DESC")
  end

end