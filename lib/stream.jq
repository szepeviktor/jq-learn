########################################################################
# Stream functions
########################################################################

include "lib/control";

# Reimplementation of `first`
def cut(g):
    label $pipe | g | ., break $pipe
;

# Infinite regeneration of generator
def cycle(g):
    def R: g, R;
    R
;

# Missing builtin opposite of `limit`
def drop($n; g):
    if $n < 0 then g
    else foreach g as $item
            ($n;
            if . < 0 then . else .-1 end;
            when(. < 0; $item))
    end
; 

# Produce enumerated items from `g`
def enum(g):
   foreach g as $item
       (-1; .+1; [., $item])
;

#
def replicate($n; x):
#   [limit($n; repeat(x))]
    [range($n) | x]
;

# Reimplementation of `limit`
def take($n; g):
    if $n < 0
    then g
    else label $loop |
        foreach g as $item
            ($n; if . < 1
                 then break $loop
                 else .-1 end;
             $item)
    end
; 

# Not optimized `zip`!
#?def zip(g; h):
#?    [[g], [h]] | transpose[]
#?;

# Optimized for two generators
def zip(g; h):
    [[g], [h]] as $pair |
    ($pair | map(length) | max) as $longest |
    foreach range($longest) as $j
        (null; null; [$pair[0][$j], $pair[1][$j]])
;

# Zip two or more generators
def zipN:
    . as $in |
    (map(length) | max) as $longest |
    length as $N |
    foreach range($longest) as $j
        (null; reduce range($N) as $i
                    ([]; . + [$in[$i][$j]]))
;

# 3, 4...
def zip(a; b; c): [[a], [b], [c]] | zipN;
def zip(a; b; c; d): [[a], [b], [c], [d]] | zipN;

# vim:ai:sw=4:ts=4:et:syntax=python
