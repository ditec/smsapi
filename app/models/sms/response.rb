# == Schema Information
#
# Table name: sms_responses
#
#  id         :bigint(8)        not null, primary key
#  text       :text(65535)      not null
#  message_id :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Sms
  class Response < ApplicationRecord
    include Sms::ResponseConcern

    # Your code goes here...
    
  end
end
