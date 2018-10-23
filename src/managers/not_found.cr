module Pkg

  class PackageManagerNotFound < Exception
    def initialize(pkg_manager : Symbol)
      super %<Package manager "#{pkg_manager.to_s}" not found.>
    end
  end

  class PackageNotFoundInManager < Exception
    def initialize(pkg_manager : Symbol, *pkg : String)
      super(
        %<Couldn't find package "#{pkg}" in #{pkg_manager.to_s}'s repositories.>
      )
    end
  end

  class FeatureNotImplementedByThisManager < Exception
    def initialize(feature : Symbol, pkg_manager : String)
      super %<Package manager #{pkg_manager} can't #{feature}.>
    end
  end

end
