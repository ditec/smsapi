module Sms
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_views
        directory "views", "app/views"
      end

    end
  end
end
