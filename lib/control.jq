########################################################################
# Control functions
########################################################################

# 
def iterate(f):
    def R: ., (f | R);
    . | R
;

# 
# ⧮ ⧯ ⧰ ⧱ ⧲ ⧳
def stop:
    error("⧳")
;

def run(x):
    try x
    catch if . == "⧳" then empty else error end
;

#
# def throw, raise ???

# 
def when(c; x):
    if c then x else empty end
;

def unless(c; x):
    if c then empty else x end
;

# vim:ai:sw=4:ts=4:et:syntax=python
