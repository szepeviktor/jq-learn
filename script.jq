#!/usr/bin/jq -MnRrf

# Usage: script.jq --arg string "mi" --arg target "mi mama me mima"

# Like Icon 'find'
def find(s; t):
    t | _strindices(s)[]
;

# Entry point
def main($s; $t):
    "Positions of \"" + $s + "\" inside \"" + $t + "\":",
    find($s; $t)
;

# Called with global variables
main($string; $target)

# vim:ai:sw=4:ts=4:et:syntax=python
