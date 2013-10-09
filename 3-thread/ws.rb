require 'rubygems'
require 'bundler/setup'

require 'mime/types'

require '../opts.rb'
require './server'

$config = getopts

module FileHandler
  class << self
    def process(request)
      path = process_path(request.path)

      if File.exist?(path) && !File.directory?(path)
        Response.new 200, File.open(path, 'rb'), 'Content-type' => mime_type(path)
      else
        Response.new 404, "File not found\n"
      end
    end

    def process_path(path)
      parts = path.split('/').reject{ |p| p == '.' || p == '..' }
      File.join($config.document_root, *parts)
    end

    def mime_type(path) MIME::Types.type_for(path).first end
  end
end

Server.new('127.0.0.1', $config.port, FileHandler).run
