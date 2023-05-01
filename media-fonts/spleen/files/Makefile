BDF2SFD    = bdf2sfd
FONTFORGE  = fontforge
FONTTOSFNT = fonttosfnt

.PHONY: all
all:	otf otb

SPLEEN := $(wildcard *.bdf)

.PHONY: otb otf
otb:	$(SPLEEN:%.bdf=%.otb)
otf:	$(SPLEEN:%.bdf=%.otf)

%.sfd : %.bdf
	$(BDF2SFD) -f "Spleen $(subst spleen-,,$(basename $@))" \
		   -p "Spleen$(subst spleen-,,$(basename $@))" $^ >tmp-$@
	$(FONTFORGE) -lang ff -c 'Open("tmp-$@"); SelectAll(); RemoveOverlap(); Simplify(-1, 1); Save("$@")'
	$(RM) tmp-$@

%.otb : %.bdf
	sed '/^FAMILY_NAME /s/ .*$$/ "Spleen '"$(subst spleen-,,$(basename $@))"'"/' <$^ | \
		$(FONTTOSFNT) -b -c -o $@

%.otf : %.sfd
	$(FONTFORGE) -lang ff -c 'Open("$^"); Generate("$@")'

.PHONY: clean
clean:
	 $(RM) *.sfd *.otb *.otf
