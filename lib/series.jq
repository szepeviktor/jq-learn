########################################################################
# Infinite series
########################################################################

def iterate(f):
    def R: ., (f | R);
    . | R
;

def factorial:
#   def R:
#       (.n + 1) as $n |
#       (.f * $n) as $f |
#       .f, ({n: $n, f: $f} | R);
#   {n: 0, f: 1} | R
#
    {n: 0, f: 1}
    | iterate({n: (.n+1), f: (.f*(.n+1))})
    | .f
;

def fibonacci:
#   def R:
#       (.x + .y) as $f |
#       $f, ({x: .y, y: $f} | R);
#   {x: -1, y: 1} | R
#
    {x: -1, y: 1}
    | iterate({x: .y, y: (.x+.y)})
    | (.x+.y)
;

def from(n):
#   def R: ., (. + 1 | R);
#   n | R
#
    n | iterate(.+1)
;

def fromBy(n; $i):
#   def R: ., (. + $i | R);
#   n | R
#
    n | iterate(.+$i)
;

def powers($n):
#   def R: ., (. * $n | R);
#   1 | R
#
    1 | iterate(.*$n)
;

# vim:ai:sw=4:ts=4:et:syntax=python
