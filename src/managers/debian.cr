require "./manager"

module Pkg

  class Debian < Manager

    property location

    def initialize
      if found = which "aptitude"
        location = found
      elsif found = which "apt"
        location = found
      elsif found = which "apt-get"
        location = found
      else
        raise PackageManagerNotFound.new :aptitude
      end
    end

    def update_sources
      run "update"
    end
    def update(*pkg)
      check_run "upgrade", "-y", *pkg
    end
    def install_only(*pkg : String)
      check_run "install", "-y", *pkg
    end
    def uninstall(*pkg : String)
      check_run "purge", "-y", *pkg
    end
    def delete( *pkg : String )
      check_run "remove", "-y", *pkg
    end
    def list_installed
      run "list", "--installed"
    end
    def search(regex : RegExp)
      Command.new( location, *args ).grep regex
    end
    def search(*terms : String)
      run "search", *terms
    end
    def info(*pkg : String)
      run "show", *pkg
    end
    def list_files(*pkg : String)
      unless (output = `dpkg -L #{pkg.join ' '}`).empty?
        puts output
        return
      end
      raise PackageManagerNotFound.new :dpkg
    end
    def dependencies_of(*pkg : String)
      pkg.each { |p| puts `apt-cache depends #{p}` }
    end
    def depends_on(*pkg : String)
      pkg.each { |p| puts `apt-cache rdepends #{p}` }
    end
  end

end
