#!/usr/bin/jq -MnRrf

# Reimplementation of `first`
def cut(g):
    label $pipe | g | ., break $pipe
;

# Reimplementation of `limit`
def take($n; g):
    if $n < 0
    then g
    else label $loop |
        foreach g as $item
        ($n; if . < 1
             then break $loop
             else . - 1 end;
         $item)
    end
; 

# Missing builtin opposite of `limit`
def drop($n; g):
    if $n < 0
    then g
    else foreach g as $item
            ($n;
            if . < 0 then . else . - 1 end;
            if . < 0 then $item else empty end)
    end
; 

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
# Usage: script.jq --arg string "mi" --arg target "mi mama me mima"
def main:
    "Positions of \"" + $string + "\" inside \"" + $target + "\":",
    find($string; $target)
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
