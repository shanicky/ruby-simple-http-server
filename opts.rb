require 'ostruct'

def usage
  $stderr.puts "Usage: #{File.basename($0)}: --public <directory> --port <port>"
  exit(1)
end

def getopts
  res = OpenStruct.new
  loop do
    case ARGV[0]
      when '--public' then ARGV.shift; res[:document_root] = ARGV.shift
      when '--port'   then ARGV.shift; res[:port] = ARGV.shift.to_i
      else break
    end
  end
  usage if res.to_h.size != 2
  res
end
