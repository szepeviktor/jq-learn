# Easy management of tests and examples

########################################################################
# Configuration
########################################################################

version_test := $(filter 4.0,$(firstword $(sort $(MAKE_VERSION) 4.0)))
ifndef version_test
$(error Using GNU Make version $(MAKE_VERSION); version >= 4.0 is needed)
endif

SHELL := /bin/bash

.DEFAULT_GOAL := all

.SUFFIXES:

.SILENT:

.ONESHELL:

.PHONY: all clean clobber check

########################################################################
# Variables
########################################################################

# Run tests
Run := /usr/bin/jq --run-tests

# Tests to check
Tests := $(wildcard tests/*.test)

# Targets simulating the tests are done
LogDir := .logs
Targets := $(subst tests/,$(LogDir)/,$(Tests:.test=.log))

########################################################################
# Rules
########################################################################

# Tests' output is saved in a log file
$(LogDir)/%.log: tests/%.test
	echo '>>>' $< '<<<' | tee $@
	$(Run) $< | tee --append $@ | grep -v '^Testing'
	grep -q '^\*\*\*' $@ && touch $< || true
	echo

# Hidden directory for logs
$(firstword $(Targets)): | $(LogDir)
$(LogDir): ; mkdir --parents $@

# Other dependencies
$(LogDir)/series.log: lib/series.jq lib/stream.jq lib/control.jq
$(LogDir)/sets.log:   lib/sets.jq
$(LogDir)/stream.log: lib/stream.jq lib/control.jq
$(LogDir)/string.log: lib/string.jq

# Default target
all: $(Targets)

########################################################################
# Utilities
########################################################################

clean:
	rm -f $(Targets)

clobber: clean
	rm -rf $(LogDir)

check: clean all

########################################################################
# Examples
########################################################################

.PHONY: cross script star

cross:
	./examples/cross.jq --arg word1 'computer' --arg word2 'center'

script:
	./examples/script.sh 'on' 'one motion is optional'

star:
	./examples/star.jq --arg alphabet '01' --argjson ordered true  | head -n 20 >/tmp/star1.tmp
	./examples/star.jq --arg alphabet '01' --argjson ordered false | head -n 20 >/tmp/star2.tmp
	echo -e '=======+===========\nORDERED|NOT ORDERED\n=======+==========='
	paste /tmp/star[12].tmp

# vim:ai:sw=4:ts=4:noet:syntax=make
