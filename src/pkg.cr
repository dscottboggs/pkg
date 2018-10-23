require "./config"
require "./interface/commands"

# TODO: Write documentation for `Pkg`
module Pkg
  VERSION = "0.1.0"

  macro not(arg)
    !{{arg}}
  end

  Config.package_managers = Config.read.not_nil!["package manager priority"].as(Array(String))
  CLI.run ARGV
end
