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

# When it is time to consider phony targets, make will run its recipe
# unconditionally, regardless of whether a file with that name exists or what
# its last-modification time is.
.PHONY: all

# When a target is built all lines of the recipe will be given to a single
# invocation of the shell.
.ONESHELL:

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# vim:ai:sw=4:ts=4:noet:syntax=make
