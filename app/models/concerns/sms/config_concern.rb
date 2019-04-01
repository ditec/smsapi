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

require 'active_support/concern'

module Sms::ConfigConcern
  extend ActiveSupport::Concern

  included do
    has_many :messages, dependent: :destroy

    DELIVERY_METHOD_TIPES = ["Inmediato", "Un dia antes", "X dias antes"]
    
    before_validation :_delivery_method

    validates :delivery_method, presence: true, :inclusion => { :in => DELIVERY_METHOD_TIPES }
    validates :template, presence: true
    validates :cant, numericality: {only_integer: true, less_than_or_equal_to: 365, greater_than_or_equal_to: 0 }
    validates :key, presence: true, uniqueness: true
    validates_datetime :time, :if => Proc.new {|a| a.time.present?}
    validate :_cant, :if => Proc.new {|a| a.cant.present?}
    validate :template_length, :if => Proc.new {|a| a.template.present?}
  end

  private

    def template_length
      errors.add(:base, "Error: La cantidad de caracteres debe ser menor o igual a 160") if self.template.gsub(/#\w+/, "").length > 160
    end

    def _cant
      errors.add(:base, "Error: Falta ingresar la cantidad de dias") if self.delivery_method == "X dias antes" && self.cant == 0
    end

    def _delivery_method
      self.cant = 0 unless self.delivery_method == "X dias antes"
      self.time = nil if self.delivery_method == "Inmediato"
    end
end
