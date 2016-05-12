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

def zip(g; h):
    [[g], [h]] as $pair |
    $pair[0]|length as $len |
    if $len != ($pair[1]|length) then error("zip: length not equal") else null end |
    # finally do it
    foreach range($len) as $j
        (.; .; [$pair[0][$j], $pair[1][$j]])
;

# vim:ai:sw=4:ts=4:et:syntax=python
