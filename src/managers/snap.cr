require "./manager"

module Pkg

  class Snap < Manager
    property location
    def initialize
      raise PackageManagerNotFound.new :snap unless location = which "snap"
    end

    def install_only(*pkg : String)
      install *pkg
    end
    def update( *pkg : String )
      `snap install #{pkg.join ' '}`
    end
    def uninstall( *pkg : String )
      `snap remove #{pkg.join ' '}`
    end
    def list_installed( *pkg : String )
      `snap list`
    end
    def search(*terms : String)
      `snap find --narrow #{terms.join ' '}`
    end
    def search(re : RegExp)
      feature_not_implemented :search
    end
    def downgrade(*pkg : String)
      `snap revert #{pkg.join ' '}`
    end
    def info(*pkg : String)
      feature_not_implemented :info
    end
    def list_files(*pkg : String)
      puts pkg.map{ |p| "/snap/#{p}" }.join(' ')
    end
    def dependencies_of(*pkg : String)
      feature_not_implemented :dependencies_of
    end
    def depends_on(*pkg : String)
      feature_not_implemented :depends_on
    end
  end

end
