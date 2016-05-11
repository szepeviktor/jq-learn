# Called from `script.sh`

import "string" as str;

# Entry point
def main:
    "Positions of \"" + $string + "\" inside \"" + $target + "\":",
    str::find($string; $target)
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
