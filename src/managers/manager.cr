module Pkg

  abstract class Manager
    # The location of the package manager executable.
    abstract def location : String
    # Search for the given terms
    abstract def search(*terms : String)
    # Bring all non-pinned packages up-to-date
    abstract def update(*pkg : String)
    # Install the given package, after updating sources and while updating
    # packages
    def install(*pkg : String)
      update *pkg
    end
    # Install the given package only
    abstract def install_only(*pkg : String)
    # Remove the given package and all relevant configuration
    abstract def uninstall(*pkg : String)
    # Remove the package, leaving configuration files intact
    abstract def delete(*pkg : String)
    # list all installed packages
    abstract def list_installed
    # List all packages that match the given regular expression
    abstract def list(re : RegExp)
    # show information about the packages
    abstract def info(*pkg : String)

    private def run( *args : String )
      Command.new( location, *args ).stream
    end
    # When implementing a Pkg::Manager you may find that a particular package
    # manager does not implement a given feature. When you come upon such a
    # case, you should implement that method by calling this one with the
    # package name and a message, if either are relevant.
    private def feature_not_implemented(pkg : String?, message : String?)
      # TODO: what to do when a feature is not implemented for a package
      # manager?
    end
  end

end
