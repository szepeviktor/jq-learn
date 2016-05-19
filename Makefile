# Easy management of tests and examples

########################################################################
# Parameters (redefine as you like)
########################################################################

InstallPrefix := /usr/local

########################################################################
# Configuration
########################################################################

# We are using some of the newest GNU Make features... so require GNU Make
# version >= 3.82
version_test := $(filter 3.82,$(firstword $(sort $(MAKE_VERSION) 3.82)))
ifndef version_test
$(error Using GNU Make version $(MAKE_VERSION); version >= 3.82 is needed)
endif

# Make will not print the recipe used to remake files.
.SILENT:

# Eliminate use of the built-in implicit rules. Also clear out the default list
# of suffixes for suffix rules.
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the command
# line.
.DEFAULT_GOAL := all

# When a target is built all lines of the recipe will be given to a single
# invocation of the shell.
.ONESHELL:

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# When it is time to consider phony targets, make will run its recipe
# unconditionally, regardless of whether a file with that name exists or what
# its last-modification time is.
.PHONY: all build clean clobber check install uninstall

########################################################################
# Variables
########################################################################

# Call `jq` to run tests
Run := jq --run-tests

# Conversions
Y2J := bin/y2j
J2Y := bin/j2y

# Copy scripts
Install := install --verbose --compare --mode 555

# Tests to check
Tests := $(wildcard tests/*.test)

# Targets simulating the tests are done
LogDir := .logs
Targets := $(subst tests/,$(LogDir)/,$(Tests:.test=.log))

# Scripts
Tools := j2y y2j yq

########################################################################
# Rules
########################################################################

# Tests output is saved in a log file
$(LogDir)/%.log: tests/%.test
	echo '>>>' $< '<<<' | tee $@
	$(Run) $< | tee --append $@ | grep --invert-match '^Testing'
	grep --quiet '^\*\*\*' $@ && touch $< || true
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
	rm --force $(LogDir)/*.log

clobber: clean
	rm --recursive --force $(LogDir)

build check: clean all

install:
	sudo $(Install) $(addprefix bin/,$(Tools)) $(InstallPrefix)/bin

uninstall:
	sudo rm --force --verbose $(addprefix $(InstallPrefix)/bin/,$(Tools))

########################################################################
# Examples
########################################################################

.PHONY: cross script star yaml

cross:
	./examples/cross.jq --arg word1 'computer' --arg word2 'center'

script:
	./examples/script.sh 'on' 'one motion is optional'

star:
	./examples/star.jq --arg alphabet '01' --argjson ordered true  | head --lines 20 >/tmp/star1.tmp
	./examples/star.jq --arg alphabet '01' --argjson ordered false | head --lines 20 >/tmp/star2.tmp
	echo '=======+==========='
	echo 'ORDERED|NOT ORDERED'
	echo '=======+==========='
	paste /tmp/star[12].tmp

yaml:
	echo 'No news is good news...'
	jq --null-input --raw-output \
		--slurpfile j1 data/hardware.json \
		--slurpfile j2 <($(J2Y) data/hardware.json | $(Y2J)) \
		'if $$j1 == $$j2 then empty else "Failed conversion JSON <==> YAML" end'
	diff <(< data/store.json jq --sort-keys '.store.book[1]' | bin/j2y) \
		 <(< data/store.yaml bin/yq --sort-keys '.store.book[1]')

# vim:ai:sw=4:ts=4:noet:syntax=make
