module Log
  class << self
    def log(message)
      message = Time.now.strftime('[%Y-%m-%d %H:%M:%S]') << " " << message
      message += "\n" if /\n\Z/ !~ message
      $stderr << message
    end

    def info(msg)  log("INFO  "  << msg); end
    def error(msg) log("ERROR  " << msg); end
  end
end
