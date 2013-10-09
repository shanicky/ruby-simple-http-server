class Response
  STATUS_CODES = {
    200 => '200 OK',
    400 => '400 Bad Request',
    404 => '404 Not Found',
  }

  attr_reader :status, :body

  def initialize(status, body, headers = {})
    @status, @body, @headers = status, body, headers
  end

  def headers
    { 'Content-type' => 'text/plain',
      'Content-length' => body.size,
      'Connection' => 'close' }.merge @headers
  end

  def http_code() STATUS_CODES[status] end
end
