require "colorize"
require "option_parser"
require "http/server"

directory = "./"
port = 7498

class IndexHandler 
  include HTTP::Handler

  def call(context) 
    if context.request.path == "/"
      context.request.path = "/index.html"
    end
    call_next context
  end
end

OptionParser.parse do |parser|
  parser.banner = "Usage : lp_game [-d directory] [-p port]"
  parser.on("-d DIR", "--dir=DIR", "Directory to server") {|dir| directory = dir}
  parser.on("-p PORT", "--port=PORT", "Listening port") {|p| port = p.to_i}
  parser.on("-h", "--help", "Print this message") { puts parser }
end

server = HTTP::Server.new ([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  IndexHandler.new,
  HTTP::StaticFileHandler.new(directory, directory_listing: false)
]) 

server.bind_tcp "0.0.0.0", port
puts "Listening on port #{port.to_s.colorize(:white)}".colorize(:green)
server.listen


