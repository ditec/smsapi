# == Schema Information
#
# Table name: sms_responses
#
#  id         :integer          not null, primary key
#  text       :text(65535)      not null
#  message_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'active_support/concern'

module Sms::ResponseConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :message

    validates :text, presence: true, length: { in: 4..65535 }
    validates :message_id, presence: true
  end
end
