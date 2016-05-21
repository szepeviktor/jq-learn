# Easy management of tests and examples

include make.d/config.make

########################################################################
# Parameters (redefine as you like)
########################################################################

InstallPrefix := /usr/local

########################################################################
# Targets and files
########################################################################

# Tests to check
Tests := $(wildcard tests/*.test)

# Sentinel targets simulating the tests are done
LogDir := .logs
Logs := $(subst tests/,$(LogDir)/,$(Tests:.test=.log))

# Scripts to manage JSON and YAML
Scripts := j2y y2j yq

########################################################################
# Rules
########################################################################

# Create auxiliar directories
include make.d/hidden.make

# Tests output is saved in a log file
$(LogDir)/%.log: tests/%.test
	echo '>>>' $< '<<<' | tee $@
	jq --run-tests $< | tee --append $@ | grep --invert-match '^Testing'
	grep --quiet '^\*\*\*' $@ && touch $< || true
	echo

# Other dependencies
$(LogDir)/series.log: lib/series.jq lib/stream.jq lib/control.jq
$(LogDir)/sets.log:   lib/sets.jq
$(LogDir)/stream.log: lib/stream.jq lib/control.jq
$(LogDir)/string.log: lib/string.jq

# Default target
all: $(Logs)

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build check install uninstall

clean:
	rm --force $(LogDir)/*.log

clobber: clean
	[[ -d $(LogDir) ]] && rmdir --parents $(LogDir) || true

build check: clean all

install:
	sudo install --verbose --compare --mode 555 \
		$(addprefix bin/,$(Scripts)) $(InstallPrefix)/bin

uninstall:
	sudo rm --force --verbose $(addprefix $(InstallPrefix)/bin/,$(Scripts))

########################################################################
# Examples
########################################################################

# Conversions
Y2J := bin/y2j
J2Y := bin/j2y
YQ  := bin/yq

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
		 <(< data/store.yaml $(YQ) --sort-keys '.store.book[1]')
	[[ $$($(YQ) -J -r .store.bicycle.color < data/store.yaml) == red ]] || echo 1>&2 Error using yq

# vim:ai:sw=4:ts=4:noet:syntax=make
