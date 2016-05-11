# Easy management of tests

.SILENT:

JQ=jq --run-tests

TESTS=\
	  empty.test\
	  goal.test\
	  mapping.test\
	  stream.test\

all: $(TESTS:.test=.log)

%.log: %.test
	$(JQ) $< | tee $@ | grep -v '^Testing'
	grep -q '^\*\*\*' $@ && touch $< || true

clean:
	rm -f *.log

build: clean all

# vim:ai:sw=4:ts=4:noet:syntax=make
