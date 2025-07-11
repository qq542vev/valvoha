### File: Dockerfile
##
## zbasu lo doker zei morna
##
## Usage:
##
## ------ Text ------
## docker image build -f Dockerfile
## ------------------
##
## Metadata:
##
##   id - 9bdd592d-0bec-48a6-8a15-b10f4d5151aa
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.2
##   created - 2025-06-11
##   modified - 2025-07-02
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/reference/dockerfile/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/valvoha>
##   * <Bag report at https://github.com/qq542vev/valvoha/issues>

ARG BASE="docker.io/library/debian:12-slim"

FROM ${BASE}

ARG BASE
ARG TITLE="valvo'a"
ARG VERSION="1.0.2"
ARG WORKDIR="/work"

LABEL org.opencontainers.image.title="${TITLE}"
LABEL org.opencontainers.image.description="morna tezu'e lo nu zbasu jo se cipra tu'a le ${TITLE}"
LABEL org.opencontainers.image.authors="qq542vev <https://purl.org/meta/me/>"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url="https://github.com/qq542vev/valvoha"
LABEL org.opencontainers.image.license="GPL-3.0-only"
LABEL org.opencontainers.image.base.name="${BASE}"

ENV LANG="C"
ENV LC_ALL="C"
ENV TZ="UTC0"

WORKDIR ${WORKDIR}

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates curl ffmpeg espeak-ng jq make xmlstarlet zip && \
	apt-get clean && \
	rm -rf /var/lib/apt-get/lists/*
