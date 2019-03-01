# == Schema Information
#
# Table name: sms_configs
#
#  id              :bigint(8)        not null, primary key
#  delivery_method :string(255)      not null
#  template        :text(65535)      not null
#  time            :time
#  cant            :integer          default(0)
#  key             :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Sms
  class Config < ApplicationRecord
    include Sms::ConfigConcern

    # Your code goes here...

  end
end
