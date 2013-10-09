require 'rubygems'
require 'bundler/setup'

require 'socket'
require 'uri'
require 'stringio'

require 'mime/types'

require_relative '../log.rb'
require_relative '../opts.rb'


STATUS_CODES = {
  200 => '200 OK',
  400 => '400 Bad Request',
  404 => '404 Not Found',
}

def acceptable?(method, http_spec)
  method == 'GET' && (http_spec = 'HTTP/1.1' || http_spec = 'HTTP/1.0')
end

def safe_path(path)
  path.split('/').reject{ |p| p == '.' || p == '..' }
end

config = getopts
server = TCPServer.new '127.0.0.1', config.port

Log.info "Starting server: http://127.0.0.1:#{config.port}"

loop do
  socket = server.accept
  begin
    request_line = socket.gets
    method, request_uri, http_spec = request_line.to_s.split(' ', 3)
    status, headers, body =
      if acceptable? method, http_spec

        path, _query = request_uri.split('?', 2)

        path = File.join(config.document_root, *safe_path(URI.unescape(path)))

        if File.exist?(path) && !File.directory?(path)
          Log.info %Q{"#{request_line}" 200}
          headers = {'Content-type' => MIME::Types.type_for(path).first}
          [200, headers, File.open(path, 'rb')]
        else
          Log.info %Q{"#{request_line}" 404}
          headers = {'Content-type' => 'text/plain'}
          [404, headers, StringIO.new("File not found\n")]
        end
      else
        Log.error "bad Request-Line: #{request_line}"
        headers = {'Content-type' => 'text/plain'}
        [400, headers, StringIO.new("Bad request\n")]
      end

    headers.merge!({ 'Content-length' => body.size,
                     'Connection' => 'close' })
    begin
      socket.print ["HTTP/1.1 #{STATUS_CODES[status]}",
                    *headers.map{ |h, v| "#{h}: #{v}" },
                    "\r\n"].join("\r\n")
      IO.copy_stream body, socket
    rescue Errno::EPIPE
      Log.error 'Connection is broken'
    end
  ensure
    socket.close
  end
end
