require "docker"

docker = Docker.client
ProjectURL = "https://github.com/dscottboggs/pkg.git"
CrystalVersionString = "crystal-0.26.1-1-linux-x86_64"
LatestCrystal = "\
  https://github.com/crystal-lang/crystal/releases/download/0.26.1/\
  #{CrystalVersionString}.tar.gz"

def dockerfile(base_image : String) : String
  <<-DOCKERFILE
    FROM #{base_image}:latest
    RUN wget #{LatestCrystal}
    RUN tar xf #{CrystalVersionString}.tar.gz
    RUN ln -s $PWD/#{CrystalVersionString}/crystal /usr/bin/crystal
    RUN ln -s $PWD/#{CrystalVersionString}/shards /usr/bin/shards
    RUN git clone --depth1 #{ProjectURL} /pkg
    WORKDIR /pkg
    CMD crystal spec
  DOCKERFILE
end
