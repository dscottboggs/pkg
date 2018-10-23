module Pkg
  HelpText = <<-USAGE
      pkg -- a unifying package manager interface

    Usage: pkg [command phrase] [package-name|search terms]

    Available Commands:
      Search:
            search all package managers
        run with: search, find, -Ss
      Update:
            bring all available packages up-to-date
        run with: update, upgrade, -Sy[u], install
      Install only:
            only install the given package, don't update
        run with: install-only, install only, only install
      Uninstall:
            remove along with all unneeded dependencies & configurations
        run with: uninstall, purge, remove, -R
      Delete:
            remove; leaving all dependencies and configurations inplace
        run with: delete
      Downgrade:
            revert to the previous version of the installed package
        run with: downgrade, revert
      List installed:
            list the installed packages, matching if a pattern is given
        run with: list-installed, list installed
      Info:
            display information about the package
        run with: info, about, show, -Sii, -Si
      List files:
            list all files that the package installed
        run with: list-files, -L, list files
      List dependencies of:
            list all the packages that depend on a package
        run with: require, list required, list required by
      List depends on:
            list all packages that are installed and depend on a package
        run with: depends, list dependencies, list dependencies of
  USAGE
  AvailableCommands = {
    "search"         => :search,
    "find"           => :search,
    "-Ss"            => :search,
    "upgrade"        => :update,
    "update"         => :update,
    "-Sy"            => :update,
    "-Syu"           => :update,
    "install-only"   => :install_only, # add special install command
    "-S"             => :install_only,
    "uninstall"      => :uninstall,
    "purge"          => :uninstall,
    "remove"         => :uninstall,
    "-R"             => :uninstall,
    "delete"         => :delete,
    "downgrade"      => :downgrade,
    "revert"         => :downgrade,
    "list-installed" => :list_installed,
    "info"           => :info,
    "about"          => :info,
    "show"           => :info,
    "-Sii"           => :info,
    "-Si"            => :info,
    "list-files"     => :list_files,
    "-L"             => :list_files,
    "require"        => :dependencies_of,
    "depends"        => :depends_on,
  }

  class CLI

    macro add_cmd(cmd)
      def run_{{cmd.id}}(*args : String)
        Config.package_managers.each &.{{cmd.id}}(*args)
      end
    end

    macro add_cmd_exit_on_success(cmd)
      def run_{{cmd.id}}(*args : String)
        Config.package_managers.each do |pm|
          break if pm.{{cmd.id}}(*pkgs).success?
        end
      end
    end

    # Run the application by passing a list of arguments to this method
    def self.run(args : Array(String))
      puts "got args #{args}"
      {% begin %}
      case args[1]
        {% for string, cmd in AvailableCommands %}
        when {{string}}
          {{cmd.id}} *args[2..-1]
        {% end %}
      # special cases
      when "list"
        case args[2]
        when "installed"
          list_installed *args[3..-1]
        when "files"
          list_files
        when "dependencies"
          dependencies_of *args[(args[3]==="of"? 4 : 3)..-1]
        when "required"
          depends_on *args[(args[3]==="by"? 4 : 3)..-1]
        else
          search
        end
      when "install"
        args[2] === "only"? install_only : install
      end
      {% end %}
    end

    add_cmd :search
    add_cmd :list_installed
    add_cmd :info
    add_cmd :list_files
    add_cmd :dependencies_of
    add_cmd :depends_on
    add_cmd :update
    add_cmd_exit_on_success :install
    add_cmd_exit_on_success :install_only
    add_cmd_exit_on_success :uninstall
    add_cmd_exit_on_success :delete
    add_cmd_exit_on_success :downgrade

  end
end
