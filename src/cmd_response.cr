module Pkg

  # CommandResponse provides a readable API for determining success of a command
  class CommandResponse
    def initialize(@success : Bool=false)
    end
    def succeeded? : Bool
      @success
    end
    def success
      @success = true
    end
    def self.success
      CommandResponse.new.success
    end
    def self.failure
      CommandResponse.new
    end

  end
end
