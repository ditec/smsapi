module Sms
  class ConnectToApiJob < ApplicationJob
    queue_as :default
   
    def perform(message, date, config, cancel)
      require 'uri'
      require 'net/http'

      if message.present? && date.present? && config.present?
        begin
          url = URI("http://"+ Sms::Engine.url_api_sms)
          url.port = Sms::Engine.port_api_sms

          if url.host.present? && url.port.present?
            http = Net::HTTP.new(url.host, url.port)

            request = Net::HTTP::Post.new(url)
            request["Destinatario"] = message.phone.to_s
            request["Mensaje"] = message.text.truncate(160)
            request["Id_sms"] = message.id.to_s
            request["Emisor"] = config.key.to_s
            request["Fecha_envio"] = date

            unless cancel
              request["Solicitud"] = true
              request["Cancelacion"] = false
            else
              request["Solicitud"] = false
              request["Cancelacion"] = true
            end 

            response = http.request(request)
            body = JSON.parse(response.body)

            if response.code.to_i == 200
              if body["estado"].present?
                if body["estado"] == "reintente"
                  message.update(status: "fail", log: "reintente")
                elsif body["estado"] == "cancelado"
                  message.update(status: "canceled", log: "")
                else
                  message.update(status: "success", log: body["estado"])
                end
              else
                message.update(status: "fail", log: "Error 35")
              end 
            else
              array = Array.new
              errores = ["Error en el ID del mensaje", "Error en el destinatario", "Error en la fecha"]          
              errores.each_with_index do |error, index|
                array << error if !(body["errores"][index].nil?) && body["errores"][index] == 1
              end 
              array.empty? ? (error = "Error 43") : (error = array.join(", "))

              message.update(status: "fail", log: error) 
            end
          else
            message.update(status: "fail", log: "Servidor no configurado")
          end
        rescue SocketError, OpenURI::HTTPError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e       
          message.update(status: "fail", log: "Servidor no responde")
          puts e
        end
      end
    end
  end
end