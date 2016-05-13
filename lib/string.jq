########################################################################
# String functions
########################################################################

# Produces a stream on `needle` positions inside `haystack`
def find(needle; haystack):
    haystack | _strindices(needle)[]
;

# Generate the infinite language of characters in `$s`
def star($s):
    # Not "well" ordered
    "", (($s/"")[]) + star($s)
;

# TCO?
#?def star($s):
#?   def R: "", (($s/"")[]) + R;
#?   R
#?;

# "Well" ordered
def star_wo($s):
    "",
    star_wo($s) as $a | ($s/"")[] as $b
    | $a + $b
;

# Produces a stream on `cset` charactes positions inside `string`
def upto(cset; string):
    string
    | [_strindices((cset/"")[])]
    | flatten
    | unique[]
;

# vim:ai:sw=4:ts=4:et:syntax=python
