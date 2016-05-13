########################################################################
# Infinite series
########################################################################

def fibonacci:
    def R:
        (.x + .y) as $f |
        $f, ({x: .y, y: $f} | R);
    {x: -1, y: 1} | R
;

def powers($n):
    def R:
        ., (. * $n | R);
    1 | R
;

def factorial:
    def R:
        (.n + 1) as $n |
        (.f * $n) as $f |
        .f, ({n: $n, f: $f} | R);
    {n: 0, f: 1} | R
;

# vim:ai:sw=4:ts=4:et:syntax=python
