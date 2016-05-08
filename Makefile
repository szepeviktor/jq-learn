# Easy management of tests

.SILENT:

JQ=jq --run-tests

tests: mapping empty goal

goal:
	$(JQ) goal.test

mapping:
	$(JQ) mapping.test

empty:
	$(JQ) empty.test

# vim:ai:sw=4:ts=4:noet:syntax=make
