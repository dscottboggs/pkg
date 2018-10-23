require "./not_found"
require "./manager"

module Pkg

  class Arch < Manager

    property location
    def initialize
      {% begin %}
      case
      {% for aur in ["yaourt", "yay", "aurman", "pacaur", "pikaur", "pakku"] %}
      when found = which {{aur}}
        location = found
      {% end %}
      when found = which "pacman"
        puts "\
          Warning: no AUR package manager found, falling back to standard \
          repos only!" unless Config.warnings_disabled
        location = found
      else
        raise PackageManagerNotFound.new :arch
      end
      {% end %}
    end

    def update(*pkg : String)
      check_run "-Syu", "--noconfirm", *pkg
    end
    def install_only(*pkg : String)
      check_run "-S", "--noconfirm", *pkg
    end
    def uninstall(*pkg : String)
      check_run "-Rsnu", "--noconfirm", *pkg
    end
    def delete(*pkg : String)
      check_run "-Rsu", "--noconfirm", *pkg
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
      run %{-Ss "#{regex.to_s}"}, normally: true
    end
    def search(*terms : String)
      run "-Ss #{terms.join ' '}", normally: true
    end
    def info(*pkg : String)
      run "-Sii #{pkg.join(' ')}", normally: true
    end
    def list_files(*pkg : String)
      run "-Ql #{pkg.join ' '}", normally: true
    end
    def dependencies_of(*pkg : String)
      pkg.each do |this_package|
        result = `#{location} -Qi #{this_package}`.lines chomp: true
        output_string = "Package #{this_package} depends on: "
        line_found = false
        result.each do |line|
          if line.startswith? "Depends On"
            output_string += line
            line_found = true
          end
          if line_found
            break unless line.startswith /\w+/
            output_string += line
          end
        end
      end
    end
    def depends_on(*pkg : String)
      pkg.each do |this_package|
        result = `#{location} -Qi #{this_package}`.lines chomp: true
        output_string = "Package #{this_package} is required by: "
        line_found = false
        result.each do |line|
          if line.startswith? "Required By"
            output_string += line
            line_found = true
          end
          if line_found
            break unless line.startswith /\w+/
            output_string += line
          end
        end
      end
    end

  end

end
