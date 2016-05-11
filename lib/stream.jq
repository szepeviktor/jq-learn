########################################################################
# Stream functions
########################################################################

# Reimplementation of `first`
def cut(g):
    label $pipe | g | ., break $pipe
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


# vim:ai:sw=4:ts=4:et:syntax=python
