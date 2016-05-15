# Easy management of tests

.SILENT:

########################################################################
# Macros
########################################################################

JQ := /usr/bin/jq --run-tests

TESTS := $(wildcard *.test)

########################################################################
# Patterns
########################################################################

%.log: %.test
	@echo '>>>' $< '<<<' | tee $@
	$(JQ) $< | tee --append $@ | grep -v '^Testing'
	-grep -q '^\*\*\*' $@ && touch $<
	@echo

########################################################################
# Rules
########################################################################

all: $(TESTS:.test=.log)

series.log: lib/series.jq lib/stream.jq lib/control.jq
stream.log: lib/stream.jq lib/control.jq
string.log: lib/icon.jq

########################################################################
# Utilities
########################################################################

clean:
	rm -f $(TESTS:.test=.log)

build: clean all

tests: build

# vim:ai:sw=4:ts=4:noet:syntax=make
