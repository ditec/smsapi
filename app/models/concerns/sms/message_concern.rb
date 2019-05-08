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
#  log        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cancel     :boolean          default(FALSE)
#

require 'active_support/concern'

module Sms::MessageConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :config
    has_many :responses, dependent: :destroy

    STATUS_TYPES = ["success", "pending", "canceled", "fail"]

    validates :text, presence: true, length: { in: 1..160 }
    validates :config_id, presence: true
    validates :status, presence: true, :inclusion => { :in => STATUS_TYPES }
    validates :log, length: { in: 4..255 }, allow_nil: true, allow_blank: true
    validates :phone, numericality: {only_integer: true}
    validates_length_of :phone, is: 10, :if => Proc.new {|a| a.phone.present?}  
    validates_datetime :date
  end

  def valid_key? key
    return self.config.key.to_s == key.to_s
  end 

end
