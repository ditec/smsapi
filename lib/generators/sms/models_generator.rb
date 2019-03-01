module Sms
  module Generators
    class ModelsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_models
        copy_file "models/sms/config.rb", "app/models/sms/config.rb"
        copy_file "models/sms/message.rb", "app/models/sms/message.rb"
        copy_file "models/sms/response.rb", "app/models/sms/response.rb"
      end

    end
  end
end
