require 'celluloid/autostart'
require 'celluloid/io'

module CarbonMU
  class Server
    include Celluloid::IO
    finalizer :shutdown

    def initialize(host, port)
      puts "*** Starting server on #{host}:#{port}"

      # Since we included Celluloid::IO, we're actually making a
      # Celluloid::IO::TCPServer here
      @server = TCPServer.new(host, port)
      async.run
    end

    def shutdown
      @server.close if @server
    end

    def run
      loop { async.handle_connection @server.accept }
    end

    def handle_connection(socket)
      ConnectionManager.add(socket)
    end
  end
end