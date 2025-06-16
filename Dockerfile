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
##   version - 1.0.0
##   created - 2025-06-11
##   modified - 2025-06-12
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jbovoha>
##   * <Bag report at https://github.com/qq542vev/jbovoha/issues>

ARG BASE="docker.io/library/debian:12-slim"

FROM ${BASE}

ARG BASE
ARG TITLE="lojbo valsi voksa vreji"
ARG VERSION="1.0.0"
ARG WORKDIR="/work"

LABEL org.opencontainers.image.title="${TITLE}"
LABEL org.opencontainers.image.description="${TITLE}のビルド・テスト用のイメージ。"
LABEL org.opencontainers.image.authors="qq542vev <https://purl.org/meta/me/>"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url="https://github.com/qq542vev/voksa"
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
