# Easy management of tests

.SILENT:

########################################################################
# Macros
########################################################################

JQ=jq --run-tests

TESTS=\
	  empty.test\
	  goal.test\
	  mapping.test\
	  stream.test\
	  string.test\

########################################################################
# Rules
########################################################################

all: $(TESTS:.test=.log)

%.log: %.test
	$(JQ) $< | tee $@ | grep -v '^Testing'
	grep -q '^\*\*\*' $@ && touch $< || true

stream.log: lib/stream.jq
string.log: lib/string.jq

########################################################################
# Utilities
########################################################################

clean:
	rm -f *.log

build: clean all

tests: build

# vim:ai:sw=4:ts=4:noet:syntax=make
