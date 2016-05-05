# Easy management of tests

.SILENT:

tests: mapping empty goal

goal:
	jq --run-tests goal.test

mapping:
	jq --run-tests mapping.test

empty:
	jq --run-tests empty.test

# vim:ai:sw=4:ts=4:noet:syntax=make
