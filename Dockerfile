FROM ubuntu:14.04.4

ENV TMOD_VERSION=v0.10.1.5

RUN mkdir /world /tmod && \
    touch /world/ServerLog.txt && \
    ln -s /world/ServerLog.txt /tmod/ServerLog.txt && \
    rm -rf /world

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list && \
    apt-get update && \
    apt-get install -y mono-complete \
    wget \
    unzip && \
    apt-get clean && \
    favorites_path="/root/My Games/Terraria" && mkdir -p "$favorites_path" && echo "{}" > "$favorites_path/favorites.json"

ADD https://github.com/blushiemagic/tModLoader/releases/download/$TMOD_VERSION/tModLoader.Linux.$TMOD_VERSION.zip /

RUN unzip tModLoader.Linux.$TMOD_VERSION.zip -d /tmod && \
    rm tModLoader.Linux.$TMOD_VERSION.zip && \
    chmod 777 /tmod/tModLoaderServer.exe

VOLUME ["/world", "/tmod/ServerPlugins"]

WORKDIR /tmod

ENTRYPOINT ["mono", "--server", "--gc=sgen", "-O=all", "tModLoaderServer.exe", "-configpath", "/world", "-worldpath", "/world", "-logpath", "/world"]
