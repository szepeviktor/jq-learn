########################################################################
# Icon style functions
########################################################################

# Build a character set
def cset(s):
    reduce (s/"")[] as $c ({}; . += {($c): true})
;

# Produces a stream on positions of `needle` inside `haystack`
def find(needle; haystack):
    haystack | _strindices(needle)[]
;

# Produces a stream of positions of `cset` characters inside `string`
def upto(cset; string):
    string
    | [_strindices((cset/"")[])]
    | flatten
    | unique[]
;

# Build a set from an array
def set(a):
    reduce a[] as $x ({}; . += {($x|tostring): true})
;

# Generate the infinite language of characters in `$s`
def star(s):
    # Not "well ordered"
    "", ((s/"")[]) + star(s)
;

# TCO?
#?def star(s):
#?   def R: "", ((s/"")[]) + R;
#?   R
#?;

# "Well" ordered
def star_wo(s):
    "",
    star_wo(s) as $a | (s/"")[] as $b
    | $a + $b
;

# vim:ai:sw=4:ts=4:et:syntax=python
