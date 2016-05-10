#!/usr/bin/jq -MnRrf

# Usage: script.jq --arg string "mi" --arg target "mi mama me mima"

#
def cut(g):
    label $x | g | ., break $x;

#
def find(needle; haystack):
    haystack | _strindices(needle)[]
;

#
def upto(cset; string):
    string
    | [_strindices((cset/"")[])]
    | flatten
    | unique[]
;

# not well ordered
def star($s):
    "", (($s/"")[]) + star($s)
;

# TCO?
#?def star($s):
#?   def r: "", (($s/"")[]) + r;
#?   r
#?;

# ordered
#?def star($s):
#?    "",
#?    star($s) as $a | (($s/"")[]) as $b
#?    | $a + $b
#?;

# Entry point
def main:
    "Positions of \"" + $string + "\" inside \"" + $target + "\":",
    find($string; $target)
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
