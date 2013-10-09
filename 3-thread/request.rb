require 'uri'

class Request
  attr_reader :request_line, :path, :query

  def initialize(request_line)
    @request_line = request_line
    @method, request_uri, @http_spec = request_line.split(' ', 3)
    @path = parse_path(request_uri) if processable?
  end

  def processable?
    @method == 'GET' && %w{HTTP/1.1 HTTP/1.0}.include?(@http_spec)
  end

  private

  def parse_path(request_uri)
    path, _query = request_uri.split('?', 2)
    URI.unescape(path)
  end
end
