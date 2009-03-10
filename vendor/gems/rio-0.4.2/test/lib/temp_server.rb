require 'webrick'
require 'rio'


class TempServer
  def initialize(server_config = {})
    @logdir = rio('log').delete!.mkdir
    @config = { :DocumentRoot => rio('srv/www/htdocs').abs, 
      :Logger => WEBrick::Log.new(@logdir/'server.log'), 
      :AccessLog => [[ @logdir/'access.log', WEBrick::AccessLog::COMBINED_LOG_FORMAT ]],
      :Port => ENV['RIO_TEST_PORT'] || '8088',
    }
    @config.merge!(server_config)
    ENV['RIO_TEST_PORT'] = @config[:Port]
    @server = create_server(@config)
  end
  def self.run(*args)
    new.run(*args)
  end
  def create_server(config = {})
    server = WEBrick::HTTPServer.new(config)
    yield server if block_given?
    ['INT', 'TERM'].each {|signal| 
      trap(signal) {server.shutdown}
    }
    server
  end
  def run_progs(progs)
    progs.each do |prog|
      system("ruby #{prog}")
    end
  end
  def run(*programs)
    Thread.new(@server) { |srv|
      srv.start
    }
    Thread.new(programs) { |progs|
      #Thread.pass
      run_progs(progs)
    }.join()
    
    Thread.new(@server) { |srv|
      srv.shutdown
    }
  end
end
