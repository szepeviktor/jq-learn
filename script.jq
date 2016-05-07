#!/usr/bin/jq -MnRrf

# Usage: script.jq --arg string "mi" --arg target "mi mama me mima"

# Like Icon 'find'
def find(needle; haystack):
    haystack
    | _strindices(needle)[]
;

# Like Icon 'upto'
def upto(cset; string):
    string
    | [_strindices(cset | split("")[])]
    | flatten
    | unique[]
;

# Entry point
def main:
    "Positions of \"" + $string + "\" inside \"" + $target + "\":",
    find($string; $target)
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
