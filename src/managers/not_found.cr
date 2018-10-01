module Pkg

  class PackageManagerNotFound < Exception
    def initialize(pkg_manager : Symbol)
      super %<Package manager "#{pkg_manager.to_s}" not found.>
    end
  end

end
