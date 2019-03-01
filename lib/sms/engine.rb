module Sms
  class Engine < ::Rails::Engine
    isolate_namespace Sms

    mattr_accessor :url_api_sms, :port_api_sms

    def self.setup
      yield self
    end
  end
end
