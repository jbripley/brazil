require 'rio'

module Test
  module RIO
    module FTP
      module Const
        FTPUSER = 'ftp'
        
        DRV = $mswin32 ? 'x:' : ''
        FSROOT = rio("#{DRV}/srv/ftp")
        #FSROOT = rio("../../srv/ftp")
        #FTPHOST = '192.168.1.101'
        FTPHOST = 'riotest.hopto.org'
        #FTPHOST = 'localhost'
        FTPROOT = rio("ftp://#{FTPHOST}/")

        TESTDIR = rio('riotest')

        RODIR = rio('ro')
        RWDIR = rio('rw')
        FTP_RWROOT = FTPROOT/TESTDIR/RWDIR
        FTP_ROROOT = FTPROOT/TESTDIR/RODIR
        FS_RWROOT = FSROOT/TESTDIR/RWDIR
        FS_ROROOT = FSROOT/TESTDIR/RODIR
        unless $mswin32
          PASSWDFILE = '/etc/passwd'
          UID,GID = rio(PASSWDFILE).lines[/^#{FTPUSER}/][0].split(':')[2..3].map{|strid| strid.to_i}
        end
      end
      include Const
      def init_test_files
        fsdir = rio(FSROOT,TESTDIR).delete!.mkdir
        rodir = rio(fsdir,RODIR).mkdir
        rwdir = rio(fsdir,RWDIR).mkdir
        f0 = rodir/'f0' < "File0\n"
        d0 = rio(rodir,'d0').mkdir
        f1 = rio(d0,'f1') < "File1\n"
        d1 = rio(d0,'d1').mkdir
        f2 = rio(d1,'f2') < "File2\n"
        f0.chown(UID,GID).chmod(0555)
        f1.chown(UID,GID).chmod(0555)
        f2.chown(UID,GID).chmod(0555)
        d1.chown(UID,GID).chmod(0555)
        d0.chown(UID,GID).chmod(0555)
        rodir.chown(UID,GID).chmod(0555)
        rwdir.chown(UID,GID).chmod(0777)
        fsdir.chown(UID,GID).chmod(0555)
        
        puts rio(FSROOT,TESTDIR).all[]
      end
      module_function :init_test_files
    end
  end
end

