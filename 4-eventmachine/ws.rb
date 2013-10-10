require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'evma_httpserver'
require 'mime/types'

require '../opts'

$config = getopts

class FileServer < EM::Connection
  include EM::HttpServer

  def post_init
    super
    no_environment_strings
  end

  def process_http_request
    path = file_path

    resp = if File.exist?(path) && !File.directory?(path)
             perform_response(200, File.open(path, 'rb').read, mime_type(path))
           else
             perform_response(404, "File not found\n", 'text/plain')
           end

    resp.send_response
  end

  def perform_response(status, content, content_type)
    response = EM::DelegatedHttpResponse.new(self)
    response.status = status
    response.content_type content_type
    response.content = content
    response
  end

  def file_path
    parts = @http_path_info.split('/').reject{ |p| p == '.' || p == '..' }
    File.join($config.document_root, *parts)
  end

  def mime_type(path) MIME::Types.type_for(path).first end
end

EM.run{ EM.start_server 'localhost', $config.port, FileServer }
