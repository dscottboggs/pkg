module Pkg

  abstract class Manager
    # The location of the package manager executable.
    abstract def location : String
    # Search for the given terms
    abstract def search(*terms : String)
    # List all packages that match the given regular expression
    abstract def search(re : RegExp)
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
    # Downgrade the package to the previous version
    abstract def downgrade(*pkg : String)
    # list all installed packages
    abstract def list_installed
    # show information about the packages
    abstract def info(*pkg : String)
    # List files installed by the package
    abstract def list_files( *pkg : String )
    # List dependencies of the given packages
    abstract def dependencies_of( *pkg : String )
    # List packages that depend on the given packge
    abstract def depends_on( *pkg : String )

    # If normally is true, the text of the command is output like normal.
    # Otherwise, each newline is replace with a carriage return, causing
    # all output to erase over itself when the next line prints.
    private def run(*command : String, normally : Bool=false) : Nil
      return puts `#{location} #{command.join ' '}` if normally
      Command.new( location, *args ).stream
    end
    # check_run runs a process and returns a CommandResponse (which has a
    # .success? method)
    def check_run(*command : String) : CommandResponse
      res = Process.run command[0], args: command[1..-1]
      if res.exit_code === 0
        CommandResponse.new.success
      else
        CommandResponse.new.failure
      end
    end
    # When implementing a Pkg::Manager you may find that a particular package
    # manager does not implement a given feature. When you come upon such a
    # case, you should implement that method by calling this one with the
    # package name and a message, if either are relevant.
    private def feature_not_implemented(feature : Symbol)
      raise FeatureNotImplementedByThisManager.new feature, location
    end

    private def which(command : String) : String?
      pr = Process.new("which", args: [command])
      if pr.wait.exit_code === 0
        pr.output.gets "\n", chomp: true
      end
    end
  end

end
