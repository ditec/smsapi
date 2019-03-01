# == Schema Information
#
# Table name: sms_messages
#
#  id         :bigint(8)        not null, primary key
#  text       :text(65535)      not null
#  phone      :string(255)      not null
#  date       :datetime         not null
#  config_id  :bigint(8)        not null
#  status     :string(255)      not null
#  error      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Sms
  class Message < ApplicationRecord
    include Sms::MessageConcern

    # Your code goes here...
    
  end
end
