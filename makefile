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
##   version - 1.0.0
##   created - 2025-06-08
##   modified - 2025-06-12
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - awk, curl, echo, espeak-ng, xmlstarlet zip
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jbovoha>
##   * <Bag report at https://github.com/qq542vev/jbovoha/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all mkfile FORCE espeak-ng espeak-ng_jicmu-gismu list release clean rebuild mk-template help version

.SILENT: mk-template help version

# Macro
# =====

VERSION = 1.0.0

MAKE_FILE = espeak-ng_jicmu-gismu.mk espeak-ng_cipra-gismu.mk
LIST_FILE = liste/jicmu-gismu.txt liste/cipra-gismu.txt
SPEAKER = espeak-ng
EXPORT_URL = https://github.com/qq542vev/jvs_ja/raw/refs/heads/zmiku/xml-export-en.html.xml
EXPORT_XPATH = /dictionary/direction/valsi[@word]
CURL = curl -sSfL -- '$(EXPORT_URL)'

# Build
# =====

all: $(SPEAKER)

mkfile: $(MAKE_FILE)

FORCE:

# espeak-ng
# ---------

espeak-ng: espeak-ng_jicmu-gismu espeak-ng_cipra-gismu

espeak-ng_jicmu-gismu: espeak-ng_jicmu-gismu.mk FORCE
	make -f '$(<)'

espeak-ng_jicmu-gismu.mk: liste/jicmu-gismu.txt
	make INOUT='<$(<) >$(@)' DIR='espeak-ng/$(<F:.txt=)' CMD='ESPEAK' mk-template

espeak-ng_cipra-gismu: espeak-ng_cipra-gismu.mk FORCE
	make -f '$(<)'

espeak-ng_cipra-gismu.mk: liste/cipra-gismu.txt
	make INOUT='<$(<) >$(@)' DIR='espeak-ng/$(<F:.txt=)' CMD='ESPEAK' mk-template

# List
# ----

list: $(LIST_FILE)

liste/jicmu-gismu.txt: liste
	$(CURL) | xmlstarlet sel -t -m '$(EXPORT_XPATH)[@type="gismu"]' -v '@word' -n >$(@)

liste/cipra-gismu.txt: liste
	$(CURL) | xmlstarlet sel -t -m '$(EXPORT_XPATH)[@type="experimental gismu"]' -v '@word' -n >$(@)

liste:
	mkdir -p -- '$(@)'

# Release
# =======

release: $(SPEAKER:=.zip)

espeak-ng.zip: espeak-ng
	zip -9FSro '$(@)' -- '$(<)'

# Clean
# =====

clean:
	rm -rf -- $(MAKE_FILE) $(SPEAKER) $(SPEAKER:=.zip)

rebuild: clean all

# Template
# ========

mk-template:
	awk -- ' \
		BEGIN { \
			if(!("ESPEAK" in ENVIRON)) { \
				ENVIRON["ESPEAK"] = "espeak-ng -s 120 -v jbo+f5 -w \"_TEPUHE_\" \"_SEPUHE_\""; \
			} \
			if("CMD" in ENVIRON) { \
				if(ENVIRON["CMD"] = "ESPEAK") { \
					cmd = ENVIRON[ENVIRON["CMD"]]; \
				} else { \
					cmd = ENVIRON["CMD"]; \
				} \
			} \
			dir = (("DIR" in ENVIRON) ? ENVIRON["DIR"] : "."); \
			ext = (("EXT" in ENVIRON) ? ENVIRON["EXT"] : ".wav"); \
			split("", valsi); \
		} \
		{ \
			valsi[NR] = $$0; \
		} \
		END { \
			print("#!/usr/bin/make -f"); \
			print(""); \
			print(".POSIX:"); \
			print(""); \
			print(".PHONY: all clean rebuild"); \
			print(""); \
			printf("DIR = %s\n", dir); \
			printf("EXT = %s\n", ext); \
			printf("FILES ="); \
			for(i = 1; i <= NR; i++) { \
				printf(" $$(DIR)/%s$$(EXT)", valsi[i]); \
			} \
			print(""); \
			print("all: $$(FILES)"); \
			for(i = 1; i <= NR; i++) { \
				print(""); \
				printf("$$(DIR)/%s$$(EXT): $$(DIR)\n", valsi[i]); \
				if(cmd) { \
					cmd_ = cmd; \
					gsub("_SEPUHE_", "$$(@F:$$(EXT)=)", cmd_); \
					gsub("_TEPUHE_", "$$(@)", cmd_); \
					printf("\t%s\n", cmd_); \
				} \
			} \
			print(""); \
			print("$$(DIR):"); \
			print("\tmkdir -p -- $$(@)"); \
			print(""); \
			print("clean:"); \
			print("\trm -f -- $$(FILES)"); \
			print(""); \
			print("rebuild: clean all"); \
		} \
	' - $(INOUT)

# Message
# =======

help:
	echo "zbasu lo lojbo valsi voksa vreji"
	echo
	echo "USAGE:"
	echo "  make [OPTION...] [MACRO=VALUE...] [TARGET...]"
	echo
	echo "MACRO:"
	echo "  ESPEAK jufra co minde la'o gy. eSpeak NG gy."
	echo
	echo "TARGET:"
	echo "  all     zbasu ro da"
	echo "  mkfile  zbasu ro la'o gy. makefile gy."
	echo "  espeak-ng"
	echo "          zbasu ro da sepi'o la'o gy. eSpeak NG gy."
	echo "  espeak-ng_jicmu-gismu"
	echo "          zbasu ro tu'a lo jicmu gismu sepi'o la'o gy. eSpeak NG gy."
	echo "  espeak-ng_cipra-gismu"
	echo "          zbasu ro tu'a lo cipra gismu sepi'o la'o gy. eSpeak NG gy."
	echo "  list    zbasu lo liste"
	echo "  clean   vimcu lo se zbasu"
	echo "  rebuild ba lo nu zukte la'o gy. clean gy. cu zukte la'o gy. all gy."
	echo "  help    jarco tu'a le sidju jufra"
	echo "  version jarco tu'a le ve farvi namcu"

version:
	echo '$(VERSION)'
