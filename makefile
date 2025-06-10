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
##   modified - 2025-06-11
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - awk, curl, echo, espeak-ng, xmlstarlet
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/voksa>
##   * <Bag report at https://github.com/qq542vev/voksa/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all mkfile FORCE update espeak-ng espeak-ng_jicmu-gismu mk-template help version

.SILENT: mk-template help version

# Macro
# =====

VERSION = 1.0.0

MAKEFILE = espeak-ng_jicmu-gismu.mk espeak-ng_cipra-gismu.mk
LISTFILE = liste/jicmu-gismu.txt liste/cipra-gismu.txt
EXPORT_URL = https://github.com/qq542vev/jvs_ja/raw/refs/heads/zmiku/xml-export-en.html.xml
EXPORT_XPATH = /dictionary/direction/valsi[@word]

# Build
# =====

all: espeak-ng

mkfile: $(MAKEFILE)

FORCE:

# liste
# =====

update: $(LISTFILE)

liste/jicmu-gismu.txt: liste FORCE
	curl -sSfL -- '$(EXPORT_URL)' | xmlstarlet sel --net -t -m '$(EXPORT_XPATH)[@type="gismu"]' -v '@word' -n >$(@)

liste/cipra-gismu.txt: liste FORCE
	curl -sSfL -- '$(EXPORT_URL)' | xmlstarlet sel --net -t -m '$(EXPORT_XPATH)[@type="experimental gismu"]' -v '@word' -n >$(@)

liste:
	mkdir -p -- '$(@)'

# espeak-ng
# ---------

espeak-ng: espeak-ng_jicmu-gismu espeak-ng_cipra-gismu

espeak-ng_jicmu-gismu: espeak-ng_jicmu-gismu.mk FORCE
	make -f '$(<)'

espeak-ng_jicmu-gismu.mk: liste/jicmu-gismu.txt
	make INOUT='<liste/jicmu-gismu.txt >$(@)' DIR='espeak-ng/jicmu-gismu' CMD='ESPEAK' mk-template

espeak-ng_cipra-gismu: espeak-ng_cipra-gismu.mk FORCE
	make -f '$(<)'

espeak-ng_cipra-gismu.mk: liste/cipra-gismu.txt
	make INOUT='<liste/cipra-gismu.txt >$(@)' DIR='espeak-ng/cipra-gismu' CMD='ESPEAK' mk-template

# Clean
# =====

clean:
	rm -rf -- $(MAKEFILE) espeak-ng

rebuild: clean all

# Template
# ========

mk-template:
	awk -- ' \
		BEGIN { \
			if(!("ESPEAK" in ENVIRON)) { \
				ENVIRON["ESPEAK"] = "espeak-ng -s 12 -v jbo+f5 -w \"_TEPUHE_\" \"_SEPUHE_\""; \
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
	echo "  ESPEAK jufra co minde la espeak.ng."
	echo
	echo "TARGET:"
	echo "  all     zbasu ro da"
	echo "  mkfile  zbasu ro la makefiles."
	echo "  espeak-ng"
	echo "          zbasu ro da sepi'o la espeak.ng"
	echo "  espeak-ng_jicmu-gismu"
	echo "          zbasu ro tu'a lo jicmu gismu sepi'o la espeak.ng"
	echo "  espeak-ng_cipra-gismu"
	echo "          zbasu ro tu'a lo cipra gismu sepi'o la espeak.ng"
	echo "  update  cnino gasnu lo liste"
	echo "  clean   vimcu lo se zbasu"
	echo "  rebuild ba lo nu zukte la clean cu zukte la all"
	echo "  help    jarco tu'a le sidju jufra"
	echo "  version jarco tu'a le ve farvi namcu"

version:
	echo '$(VERSION)'
