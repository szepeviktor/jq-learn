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

########################################################################

def intersection(s):
# 1.
#    with_entries(select(.key as $k | s | has($k)))
# 2.
#    to_entries
#    | map(select(.key as $k | s | has($k)))
#    | from_entries
# 3.
    reduce (keys_unsorted[] as $k
            | [$k, .[$k]]   # key value pair
            | select(.[0] as $key | s | has($key))
            | {(.[0]): .[1]}
           ) as $x
    ({}; . + $x)
;

def difference(s):
    reduce (keys_unsorted[] as $k
            | [$k, .[$k]]   # key value pair
            | select(.[0] as $key | s | has($key) | not)
            | {(.[0]): .[1]}
           ) as $x
    ({}; . + $x)
;

def subset(s):
    . == intersection(s)
;

# vim:ai:sw=4:ts=4:et:syntax=python
