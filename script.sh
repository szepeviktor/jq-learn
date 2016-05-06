#!/usr/bin/jq -Rf

def find(s; t):
    t | _strindices(s)[]
;

def main($s; $t):
    first(find($s; $t))
;

########################################################################
#
########################################################################

input as $s |
input as $t |
main($s; $t)

# vim:ai:sw=4:ts=4:et:syntax=python
