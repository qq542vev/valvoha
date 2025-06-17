#!/usr/bin/make -f

### File: makefile
##
## zbasu lo lojbo valsi voksa vreji
##
## Usage:
##
## ------ Text ------
## make -f makefile
## ------------------
##
## Metadata:
##
##   id - 40bb79f8-5326-4164-83d3-496a50a44418
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 2.0.0
##   created - 2025-06-08
##   modified - 2025-06-15
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - awk, curl, echo, espeak-ng, ffmpeg, jq, xmlstarlet zip
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jbovoha>
##   * <Bag report at https://github.com/qq542vev/jbovoha/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all espeak-ng $(ESPEAK_TGT) la-vitci-voksa $(VITVOHA_TGT) list release clean rebuild help version

.SILENT: help version

# Macro
# =====

VERSION = 2.0.0

TYPE = jicmu-gismu cipra-gismu
ESPEAK_TGT = $(TYPE:%=espeak-ng_%)
VITVOHA_TGT = $(TYPE:%=la-vitci-voksa_%)

SPEAKER = espeak-ng la-vitci-voksa
EXPORT_XPATH = /dictionary/direction/valsi[@word]
EXPORT_VLASTE = curl -sSfL -- 'https://github.com/qq542vev/jvs_ja/raw/refs/heads/zmiku/xml-export-en.html.xml'
MKDIR = mkdir -p -- '$(@D)'

JICMU_GISMU != cat -- 'liste/jicmu-gismu.txt'
CIPRA_GISMU != cat -- 'liste/cipra-gismu.txt'

ESPEAK = espeak-ng -p 60 -s 120 -v jbo+f5 -w "$(@)" "$(@F:.wav=)"
LA_VITCI_VOKSA = \
	curl() { command curl -sSfL "$${@}" && sleep 1; } && \
	url='https://lojban-text-to-speech.hf.space/call/cupra' && \
	id=$$( \
		curl \
			-X 'POST' -H 'Content-Type: application/json' \
			-d '{"data": ["$(@F:.wav=)", "Lojban", 0, 0, 0, "Nix-Deterministic", "wav"]}' \
			-- "$${url}" | \
		jq -r '.event_id' \
	) && \
	audio=$$( \
		curl -- "$${url}/$${id}" | \
		awk -- 'match($$0, "^data: *") { print(substr($$0, RLENGTH + 1)); exit; }' | \
		jq -r 'to_entries | .[1].value.url' \
	) && \
	curl -- "$${audio}" | ffmpeg -i - -filter:a 'atempo=0.65' -hide_banner -y -- '${@}'

# Build
# =====

all: $(SPEAKER)

# espeak-ng
# ---------

espeak-ng: $(ESPEAK_TGT)

espeak-ng_jicmu-gismu: liste/jicmu-gismu.txt $(JICMU_GISMU:%=espeak-ng/jicmu-gismu/%.wav)

espeak-ng_cipra-gismu: liste/cipra-gismu.txt $(CIPRA_GISMU:%=espeak-ng/cipra-gismu/%.wav)

$(JICMU_GISMU:%=espeak-ng/jicmu-gismu/%.wav) $(CIPRA_GISMU:%=espeak-ng/cipra-gismu/%.wav):
	$(MKDIR)
	$(ESPEAK)

# la vitci voksa
# ------------------

la-vitci-voksa: $(VITVOHA_TGT)

la-vitci-voksa_jicmu-gismu: liste/jicmu-gismu.txt $(JICMU_GISMU:%=la-vitci-voksa/jicmu-gismu/%.wav)

la-vitci-voksa_cipra-gismu: liste/cipra-gismu.txt $(CIPRA_GISMU:%=la-vitci-voksa/cipra-gismu/%.wav)

$(JICMU_GISMU:%=la-vitci-voksa/jicmu-gismu/%.wav) $(CIPRA_GISMU:%=la-vitci-voksa/cipra-gismu/%.wav):
	$(MKDIR)
	$(LA_VITCI_VOKSA)

# List
# ----

list: $(TYPE:%=liste/%.txt)

liste/jicmu-gismu.txt:
	$(MKDIR)
	$(EXPORT_VLASTE) | xmlstarlet sel -t -m '$(EXPORT_XPATH)[@type="gismu"]' -v '@word' -n >'$(@)'

liste/cipra-gismu.txt:
	$(MKDIR)
	$(EXPORT_VLASTE) | xmlstarlet sel -t -m '$(EXPORT_XPATH)[@type="experimental gismu"]' -v '@word' -n >'$(@)'

# Release
# =======

release: $(SPEAKER:=.zip)

espeak-ng.zip: espeak-ng
	zip -9FSro '$(@)' -- '$(<)'

la-vitci-voksa.zip: la-vitci-voksa
	zip -9FSro '$(@)' -- '$(<)'

# Document
# ========

LICENSE.txt:
	curl -sSfLo '$(@)' -- 'https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt'

# Clean
# =====

clean:
	rm -rf -- $(SPEAKER) $(SPEAKER:=.zip)

rebuild: clean all

# Message
# =======

help:
	echo "zbasu lo lojbo valsi voksa vreji"
	echo
	echo "USAGE:"
	echo "  make [OPTION...] [MACRO=VALUE...] [TARGET...]"
	echo
	echo "MACRO:"
	echo "  ESPEAK         jufra co minde la'o gy. eSpeak NG gy."
	echo "  LA_VITCI_VOKSA jufra co minde la vitci voks."
	echo
	echo "TARGET:"
	echo "  all     zbasu ro da"
	echo "  espeak-ng"
	echo "          zbasu ro da sepi'o la'o gy. eSpeak NG gy."
	echo "  espeak-ng_jicmu-gismu"
	echo "          zbasu ro tu'a lo jicmu gismu sepi'o la'o gy. eSpeak NG gy."
	echo "  espeak-ng_cipra-gismu"
	echo "          zbasu ro tu'a lo cipra gismu sepi'o la'o gy. eSpeak NG gy."
	echo "  la-vitci-voksa"
	echo "          zbasu ro da sepi'o la vitci voks."
	echo "  la-vitci-voksa_jicmu-gismu"
	echo "          zbasu ro tu'a lo jicmu gismu sepi'o la vitci voks."
	echo "  la-vitci-voksa_cipra-gismu"
	echo "          zbasu ro tu'a lo cipra gismu sepi'o la vitci voks."
	echo "  list    zbasu lo liste"
	echo "  clean   vimcu lo se zbasu"
	echo "  rebuild ba lo nu zukte la'o gy. clean gy. cu zukte la'o gy. all gy."
	echo "  help    jarco tu'a le sidju jufra"
	echo "  version jarco tu'a le ve farvi namcu"

version:
	echo '$(VERSION)'
