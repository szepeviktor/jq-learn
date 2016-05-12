########################################################################
# Stream functions
########################################################################

# Reimplementation of `first`
def cut(g):
    label $pipe | g | ., break $pipe
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

# Produce enumerated items from `g`
def enum(g):
    foreach g as $item (-1; . + 1; [., $item])
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

# Not optimized `zip`!
#?def zip(g; h):
#?    [[g], [h]] | transpose[]
#?;

# Optimized for two generators
def zip(g; h):
    [[g], [h]] as $pair |
    foreach range($pair[0]|length) as $j
        (null; null; [$pair[0][$j], $pair[1][$j]])
;

# Zip two or more generators
def zipN:
    if . == []
    then empty
    else . as $in
        | (map(length) | max) as $max
        | length as $len
        | foreach range(0; $max) as $j
              (null; reduce range(0; $len) as $i
                         ([]; . + [ $in[$i][$j]]))
    end
;

# 3, 4...
def zip(a; b; c): [[a], [b], [c]] | zipN;
def zip(a; b; c; d): [[a], [b], [c], [d]] | zipN;


# vim:ai:sw=4:ts=4:et:syntax=python
