FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine320
#RUN whoami
#USER root

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Metatrader Docker:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tct"

ENV TITLE=Metatrader5
ENV WINEPREFIX="/root/.wine"

RUN apk update && apk upgrade
RUN apk add wine

COPY /Metatrader /Metatrader
COPY wine-mono-9.2.0-x86.msi /root/.wine/drive_c/mono.msi
RUN chmod +x /Metatrader/start.sh
COPY /root /

EXPOSE 3000 8001

#USER abc
#ENTRYPOINT ["sh", "/Metatrader/start.sh"]
#ENTRYPOINT ["sh", "/init"]
