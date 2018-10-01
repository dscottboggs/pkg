module Pkg

  class Debian

    property location

    def initialize
      if found = `which aptitude`
        location = found
      elsif found = `which apt`
        location = found
      elsif found = `which apt-get`
        location = found
      else
        raise PackageManagerNotFound( :Aptitude )
      end
    end

    def update_sources
      run "update"
    end
    def update(*pkg)
      run "upgrade", "-y", *pkg
    end
    def install_only(*pkg : String)
      run "install", "-y", *pkg
    end
    def uninstall(*pkg : String)
      run "purge", "-y", *pkg
    end
    def delete( *pkg : String )
      run "remove", "-y", *pkg
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
  end

end
