require "./managers/*"
require "yaml"

module Pkg

  DebianPackageManagers = [
    "debian", "ubuntu", "aptitude", "apt", "apt-get", "dpkg"
  ]

  ArchLinuxPackageManagers = [
    "pacman", "arch", "arch-linux", "manjaro", "antergos", "pacaur", "yaourt",
    "yay", "aurman", "pikaur", "pakku"
  ]

  ConfigFileLocations = [
    ENV["XDG_CONFIG_HOME"]? || "",
    ( ENV["HOME"]? || "~" ) + "/.config",
    "/etc"
  ]

  class Config
    @@package_managers = Array(Pkg::Manager).new
    @@raw_config : YAML::Any?
    def self.warnings_disabled
      @@raw_config.not_nil!["warnings disabled"]?.nil?
    end
    def self.package_managers=(mgrs : Array(String))
      @@package_managers = mgrs.map do |mgr|
        case
        when ArchLinuxPackageManagers.includes? mgr
          Arch.new
        when DebianPackageManagers.includes? mgr
          Debian.new
        when mgr === "snap"
          Snap.new
        else
          raise "Unrecognized package manager #{mgr}!"
        end
      end
    end
    def self.package_managers
      @@package_managers
    end

    def self.read
      file = ""
      ConfigFileLocations.each do |f|
        file = File.join(f, "pkg-conf.yml")
        if File.exists? file
          return @@raw_config = File.open( file ){ |f| YAML.parse f }
        end
      end
    end
  end

end
