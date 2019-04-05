module Sms
  module Generators
    class ControllersGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_controllers
        copy_file "controllers/sms/configs_controller.rb", "app/controllers/sms/configs_controller.rb"
        copy_file "controllers/sms/log_controller.rb", "app/controllers/sms/log_controller.rb"
        copy_file "controllers/sms/messages_controller.rb", "app/controllers/sms/messages_controller.rb"
      end
      
    end
  end
end
