########################################################################
# String functions
########################################################################

# Produces a stream on `needle` positions inside `haystack`
def find(needle; haystack):
    haystack | _strindices(needle)[]
;

# Produces a stream on `cset` charactes positions inside `string`
def upto(cset; string):
    string
    | [_strindices((cset/"")[])]
    | flatten
    | unique[]
;

# Generate the infinite language of characters in `$s`
def star($s):
    # Not "well" ordered
    "", (($s/"")[]) + star($s)
;

# TCO?
#?def star($s):
#?   def r: "", (($s/"")[]) + r;
#?   r
#?;

# "Well" ordered
def star_wo($s):
    "",
    star_wo($s) as $a | (($s/"")[]) as $b
    | $a + $b
;

# vim:ai:sw=4:ts=4:et:syntax=python
