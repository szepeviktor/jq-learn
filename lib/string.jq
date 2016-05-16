########################################################################
# Icon style functions
########################################################################

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

# vim:ai:sw=4:ts=4:et:syntax=python
