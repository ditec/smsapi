require "jquery-rails"
require "validates_timeliness"
require "sms/engine"
require "active_support"

module Sms

  def self.send! config_id, number, date, params
    require 'uri'
    require 'net/http'
    
    config = Config.where(id:config_id).first

    unless config.nil?
      text = self.build_message(config, params)
      date = self.build_date(config, date)
      date.present? ? date2 = date : date2 = DateTime.now

      message = Message.new(config_id: config_id, text: text, phone: number, date: date2, status: "pending", log: "Esperando respuesta del servidor..")

      if message.save
        return self.connect_to_api(message, date, config)
      end
    end

    return nil
  end

  def self.resend! message_id
    message = Message.find(message_id)

    if !message.nil? && message.status == "fail"
      message.update(status: "pending", log: "reenviando..")
      
      return self.connect_to_api(message, message.date.strftime('%Y-%m-%d %H:%M:%S'), message.config)
    else
      return nil
    end
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

    def self.connect_to_api message, date, config
      if message.present? && date.present? && config.present?
        begin
          url = URI("http://"+ Sms::Engine.url_api_sms)
          url.port = Sms::Engine.port_api_sms

          if url.host.present? && url.port.present?
            http = Net::HTTP.new(url.host, url.port)

            request = Net::HTTP::Post.new(url)
            request["Destinatario"] = message.phone.to_s
            request["Mensaje"] = message.text
            request["Id_sms"] = message.id.to_s
            request["Emisor"] = config.key.to_s
            request["Fecha_envio"] = date

            response = http.request(request)
            body = JSON.parse(response.body)

            if response.code.to_i == 200
              if body["estado"].present?
                message.update(status: "success", log: body["estado"])
              else
                message.update(status: "fail", log: "Error 101")
              end 
            else
              array = Array.new
              errores = ["Error en el ID del mensaje", "Error en el destinatario", "Error en la fecha"]          
              errores.each_with_index do |error, index|
                array << error if !(body["errores"][index].nil?) && body["errores"][index] == 1
              end 
              array.empty? ? (error = "Error 109") : (error = array.join(", "))

              message.update(status: "fail", log: error) 
            end
          else
            message.update(status: "fail", log: "Servidor no configurado")
          end

          return message
        rescue SocketError, OpenURI::HTTPError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e       
          message.update(status: "fail", log: "Servidor no responde")
          puts e

          return message
        end
      else
        return nil
      end
    end
end