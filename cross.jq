#!/usr/bin/jq -nRrf

# Usage:
#   ./cross.jq -L lib --arg word1 'lottery' --arg word2 'boat'
#   ./cross.jq -L lib --arg word1 'computer' --arg word2 'center'
#
# Output:
#  b
# lottery
#  a
#  t
# 
#   b
#   o
#   a
# lottery
# 
#    b
#    o
#    a
# lottery
# 

import "string" as str;

# Produces a stream of intersections between two words
def cross($w1; $w2):
    str::upto($w2; $w1) as $i |
    str::upto($w1[$i:1+$i]; $w2) as $j |
    [ (($w2[0:$j]/"")[] | (" "*$i) + .),
      $w1,
      (($w2[$j+1:]/"")[] | (" "*$i) + .) ]
;

def main:
    cross($word1; $word2) | .[], ""
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
