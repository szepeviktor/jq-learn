# Called from `script.sh`

import "icon" as icon;

# Entry point
def main:
    "Positions of \"" + $string + "\" inside \"" + $target + "\":",
   icon::find($string; $target)
;

main

# vim:ai:sw=4:ts=4:et:syntax=python
