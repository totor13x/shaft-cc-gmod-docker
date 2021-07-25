FROM debian:9

ARG PLAYERS=16
ARG GAMEMODE=sandbox
ARG MAP=gm_construct
ARG PORT=27015
ARG TICKRATE=66

LABEL MAINTAINER="Based on Dockerfile _AMD_ (me@amd-nick.me)"

# Prepare Gmod server and CSS content
# ===================================

RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get -y --no-install-recommends install wget lib32gcc1 lib32tinfo5 lib32stdc++6 ca-certificates
#                                                 	   for steamcmd          for gmod     for steamcmd under !root


# Cleanup
# ===================================
RUN ulimit -n 2048
RUN apt-get clean \
	&& rm -rf /tmp/* /var/lib/apt/lists/*


# Security
# ===================================

RUN groupadd -g 999 steam \
	&& useradd -r -m -d /gmodserv -u 999 -g steam steam

RUN mkdir -p /gmodserv/steamcmd /gmodserv/content/css/steamapps \
	&& chown -vR steam:steam /gmodserv

RUN mkdir -p /gmodserv/garrysmod/data
RUN mkdir -p /gmodserv/steamapps
RUN mkdir -p /gmodserv/garrysmod/cache/srcds
RUN echo '' > /gmodserv/garrysmod/sv.db

RUN chown -R steam:steam /gmodserv

VOLUME ["/gmodserv/garrysmod/data", "/gmodserv/garrysmod/cache/srcds"]

USER steam
ENV HOME /gmodserv


# SteamCMD + GMOD + CSS
# ===================================

WORKDIR /gmodserv/steamcmd

RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
	&& tar -xvzf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz

RUN ./steamcmd.sh \
	+login anonymous \
	+force_install_dir /gmodserv/content/css \
	+app_update 232330 -validate \
	+force_install_dir /gmodserv \
	+app_update 4020 -validate \
	+quit

RUN echo '"mountcfg" {"cstrike" "/gmodserv/content/css/cstrike"}' > /gmodserv/garrysmod/cfg/mount.cfg



# Run server
# ===================================

WORKDIR /gmodserv
ENTRYPOINT ["./srcds_run", "-game garrysmod", "-console", "-strictportbind"]
CMD ["-port ${PORT}", "-tickrate ${TICKRATE}", "-maxplayers ${PLAYERS}", "+map ${MAP}"]

