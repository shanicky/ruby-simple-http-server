require 'webrick'
require '../opts'

include WEBrick

config = getopts

server = HTTPServer.new Port: config.port, DocumentRoot: config.document_root
trap('INT') { server.shutdown }
server.start
