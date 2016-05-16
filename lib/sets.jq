########################################################################
#  Objects as sets
########################################################################

# Build a character set
def cset(s):
    reduce (s/"")[] as $c ({}; . += {($c): true})
;

# Build a set from an array
def set(a):
    reduce a[] as $x ({}; . += {($x|tostring): true})
;

# Equivalent to `with_entries` without constructing intermediate lists
def mapobj(f):
    reduce (keys_unsorted[] as $k
            | {key: $k, value: .[$k]}
            | f
            | {(.key): .value}
           ) as $x
    ({}; . + $x)
;

def intersection(s):
# 1.
#    with_entries(select(.key as $k | s | has($k)))
# 2.
#    to_entries
#    | map(select(.key as $k | s | has($k)))
#    | from_entries
# 3.
#   reduce (keys_unsorted[] as $k
#           | [$k, .[$k]]   # key value pair
#           | select(.[0] as $key | s | has($key))
#           | {(.[0]): .[1]}
#          ) as $x
#   ({}; . + $x)
# 4.
    mapobj(select(.key as $key | s | has($key)))
;

def difference(s):
    mapobj(select(.key as $key | s | has($key) | not))
;

def subset(s):
    . == intersection(s)
;

# vim:ai:sw=4:ts=4:et:syntax=python
