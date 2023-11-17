FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_ID=1000
ARG USER_GECOS=LaTeX

ARG WGET=wget
ARG GIT=git
ARG SSH=openssh-client
ARG MAKE=make
ARG PANDOC=pandoc
ARG PYGMENTS=python3-pygments
ARG PYTHONIS=python-is-python3
ARG FIG2DEV=fig2dev
ARG JRE=default-jre-headless


RUN apt-get update && apt-get install --no-install-recommends -y \
  texlive-full \
  curl \
  unzip \
  # some auxiliary tools
  "$WGET" \
  "$GIT" \
  "$SSH" \
  "$MAKE" \
  # markup format conversion tool
  "$PANDOC" \
  # XFig utilities
  "$FIG2DEV" \
  # syntax highlighting package
  "$PYGMENTS" \
  # temporary fix for minted, see https://github.com/gpoore/minted/issues/277
  "$PYTHONIS" \
  # Java runtime environment (e.g. for arara)
  "$JRE" \
  # will be used to add a user
  adduser && \
  apt-get --purge remove -y $(dpkg-query -Wf '${binary:Package}\n' | grep -E '\-doc$') && \
  apt-get clean -y && rm -rf /var/lib/apt/lists/*

# TODO: test is pdfbox from Ubuntu package also works
# TODO: it should come with a compatible JDK/JRE
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir /opt/java && \
    curl https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_linux-x64_bin.tar.gz | tar -xz -C /opt/java/ && \
    curl https://dlcdn.apache.org/pdfbox/2.0.29/pdfbox-app-2.0.29.jar -o /opt/java/pdfbox-app-2.0.29.jar

RUN adduser \
  --home "$USER_HOME" \
  --uid $USER_ID \
  --gecos "$USER_GECOS" \
  --disabled-password \
  "$USER_NAME"

WORKDIR /app

EXPOSE 80
