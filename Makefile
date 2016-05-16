# Easy management of tests

.SILENT:

.PHONY: all clean build tests
.PHONY: cross script

########################################################################
# Macros
########################################################################

JQ := /usr/bin/jq --run-tests

TESTS := $(wildcard tests/*.test)

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

tests/series.log: lib/series.jq lib/stream.jq lib/control.jq
tests/stream.log: lib/stream.jq lib/control.jq
tests/string.log: lib/icon.jq
tests/sets.log: lib/icon.jq

########################################################################
# Utilities
########################################################################

clean:
	rm -f tests/*.log

build tests: clean all

########################################################################
# Examples
########################################################################

cross:
	./examples/cross.jq --arg word1 'computer' --arg word2 'center'

script:
	./examples/script.sh 'on' 'one motion is optional'

# vim:ai:sw=4:ts=4:noet:syntax=make
