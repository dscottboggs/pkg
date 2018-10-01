module Pkg
  EOF = '\x00'
  NEWLINE = '\n'

  class Command
    property arguments : [] of String
    def initialize( *arguments : String )
      command = arguments[0]
      arguments = arguments[1..-1]
    end
    def stream
      Process.run command, args: arguments do |proc|
        line = ""
        proc.output.each_char do |char|
        	break if char == EOF
          if char == NEWLINE
          	print line + "\r"
          	line = ""
        	end
          line += char unless char == NEWLINE
        end
      end
    end
    def grep( re : RegExp )
      Process.run command, args: arguments do |proc|
        line = ""
        proc.output.each_char do |char|
        	break if char == EOF
          if char == NEWLINE
          	print (line + "\r") unless re.match(line).nil?
          	line = ""
        	end
          line += char unless char == NEWLINE
        end
      end
    end
  end

end
