module Pkg

  class Arch

    property location
    def initialize
      if found = `which yaourt`
        location = found
      elsif found = `which pacaur`
        location = found
      elsif found = `which pacman`
        puts "\
          Warning: no AUR package manager found, falling back to standard \
          repos only!" unless Config.warnings_disabled
        location = found
      else
        raise PackageManagerNotFound( :"Arch User Repository" )
      end
    end

    def update(*pkg : String)
      run "-Syu", "--noconfirm", *pkg
    end
    def install_only(*pkg : String)
      run "-S", "--noconfirm", *pkg
    end
    def uninstall(*pkg : String)
      run "-Rsnu", "--noconfirm", *pkg
    end
    def delete(*pkg : String)
      run "-Rsu", "--noconfirm", *pkg
    end
    def list_installed
      line = ""
      Process.run location, args: "-Qk", &.output.each_char do |char|
        break if char == EOF
        if char == NEWLINE
          print line.split(':')[0] + NEWLINE
          line = ""
        end
        line += char unless char == NEWLINE
      end
    end
    def search(regex : RegExp)
      puts `#{location} -Ss "#{regex.to_s}"`
    end
    def search(*terms : String)
      puts `#{location} -Ss #{terms.join ' '}`
    end
    def info(*pkg : String)
      puts `#{location} -Sii #{pkg.join(' ')}`
    end

  end

end
