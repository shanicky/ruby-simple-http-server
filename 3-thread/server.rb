require 'socket'

require './request'
require './response'

require '../log.rb'

class Server
  attr_accessor :socket, :request

  class << self
    def log_request(request, response)
      req_line = request.request_line
      case response.status
      when 200 then Log.info  %Q{"#{req_line}" 200}
      when 404 then Log.error %Q{"#{req_line}" 404}
      when 400 then Log.error "bad Request-line: #{req_line}"
      end
    end

    def answer(socket, request, response)
      begin
        log_request(request, response)

        socket.print ["HTTP/1.1 #{response.http_code}",
                      *response.headers.map{ |h, v| "#{h}: #{v}" },
                      "\r\n"].join("\r\n")
        if response.body.kind_of? IO
          IO.copy_stream response.body, socket
        else
          socket.puts response.body
        end
      rescue Errno::EPIPE
        Log.error 'Connection is broken'
      end
    end
  end


  def initialize(host, port, handler) @host, @port, @handler = host, port, handler end

  def run
    Log.info "Starting server: http://#{@host}:#{@port}"
    tcp_server = TCPServer.new @host, @port
    handler = @handler

    loop do
      Thread.new(self, tcp_server.accept) do |server, socket|
        begin
          request = Request.new(socket.gets.to_s.chomp)
          response = if request.processable?
                       handler.process request
                     else
                       Response.new 400, "Bad request\n"
                     end

          Server.answer(socket, request, response)
        rescue Exception => ex
          Log.error "#{ex.class}: #{ex.message}\n\t" << ex.backtrace.join("\n\t") << "\n"
        ensure
          socket.close
        end
      end
    end
  end
end
