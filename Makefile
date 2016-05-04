#
#

.SILENT:

all: tests

tests:
	jq --run-tests mapping.test
