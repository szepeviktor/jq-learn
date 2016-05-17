# Easy management of tests

.SILENT:
.ONESHELL:

.PHONY: all clean clobber build tests

########################################################################
# Macros
########################################################################

# Run tests
RUN := /usr/bin/jq --run-tests

# Tests to check
TESTS := $(wildcard tests/*.test)

# Targets simulating the tests are done
LOGDIR := .logs
TARGETS := $(subst tests/,$(LOGDIR)/,$(TESTS:.test=.log))

########################################################################
# Patterns
########################################################################

# Tests' output is saved in a log file
$(LOGDIR)/%.log: tests/%.test
	@echo '>>>' $< '<<<' | tee $@
	$(RUN) $< | tee --append $@ | grep -v '^Testing'
	grep -q '^\*\*\*' $@ && touch $< || true
	@echo

########################################################################
# Rules
########################################################################

all: $(TARGETS)

$(TARGETS): | $(LOGDIR)
$(LOGDIR): ; mkdir -p $@

$(LOGDIR)/series.log: lib/series.jq lib/stream.jq lib/control.jq
$(LOGDIR)/sets.log:   lib/sets.jq
$(LOGDIR)/stream.log: lib/stream.jq lib/control.jq
$(LOGDIR)/string.log: lib/string.jq

########################################################################
# Utilities
########################################################################

clean:
	rm -f $(TARGETS)

clobber: clean
	rm -rf $(LOGDIR)

build tests: clean all

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
	echo -e 'ORDERED\tNOT ORDERED\n==================='
	paste /tmp/star[12].tmp

# vim:ai:sw=4:ts=4:noet:syntax=make
