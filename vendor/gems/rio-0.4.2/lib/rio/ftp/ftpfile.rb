
require 'tempfile'
require 'delegate'
module RIO
  module FTP
    class FTPFile < DelegateClass( ::Tempfile )
      def initialize(remote_path, netftp)
        @remote_path = remote_path
        @netftp = netftp
        @ftpfile = ::Tempfile.new('ftpfile')
        super(@ftpfile)
      end
      def close()
        super
        @netftp.put(path(),@remote_path)
      end
      
    end
  end
end
