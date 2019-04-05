require "jquery-rails"
require "validates_timeliness"
require "sms/engine"
require "active_support"

module Sms

  def self.send!(config, number, date, params)  
    if config.present? && number.present? && date.present?
      text = self.build_message(config, params)
      date = self.build_date(config, date)
      date.present? ? date2 = date : date2 = DateTime.now

      message = Sms::Message.new(config_id: config.id, text: text, phone: number, date: date2, status: "pending", log: "Esperando respuesta del servidor..")

      if message.save
        Sms::ConnectToApiJob.perform_later(message, date, config)
        return message
      end
    end

    return nil
  end

  def self.resend!(message)
    if !(message.nil?) && message.status == "fail"
      if message.update(status: "pending", log: "reenviando..")
        Sms::ConnectToApiJob.perform_later(message, message.date.strftime('%Y-%m-%d %H:%M:%S'), message.config)
        return message
      end
    end

    return nil
  end

  private

    def self.build_message config, params
      if params.is_a? Hash
        text = config.template

        params.each do |k, v|
          text = text.sub("##{k}", v.to_s)
        end

        text.truncate(160)
      else
        nil
      end
    end

    def self.build_date config, date
      _date = ""

      if config.delivery_method == "Inmediato"
        return _date
      elsif config.delivery_method == "Un dia antes"
        _date = date.to_datetime - 1.day
      elsif config.delivery_method == "X dias antes"
        _date = date.to_datetime - config.cant.to_i.day
      else
        return _date
      end

      if config.time.present?
        time = Time.parse(config.time.strftime("%H:%M"))
        _date = DateTime.new(_date.year, _date.month, _date.day, time.hour, time.min, time.sec)
      end
            
      return _date.strftime("%Y-%m-%d %H:%M:%S")
    end 
end