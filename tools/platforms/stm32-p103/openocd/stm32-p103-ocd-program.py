#!/usr/bin/env python

# stm32-p103-ocd-program.py
#
# This script programs an the STM32 P103 Eval board from Olimex connected to
# the local machine using 'openocd'. This is just a wrapper to openocd and the
# telnet session used to issue the device halt, flash erase, and reprogram
# commands.
#
# Usage:
#   stm32-p103-ocd-program.py [main.bin.out]
#
# The "main.bin.out" file is produced by compiling a TinyOS binary
# using "make stm32-p103" and will be located in the build/stm32-p103
# directory. If not provided on the command line,
# build/stm32-p103/main.bin.out is used by default.
#
# Requirements:
#   - 'openocd' must be installed, on your PATH, and setuid root.
#   - Assumes that olimex-arm-usb-ocd.cfg is in
#   /usr/local/lib/openocd/interface/
#   - Assumes that stm32f10x_128k_eval.cfg is in
#   /usr/local/lib/openocd/interface/

import os,sys,time
import os.path
import signal
import subprocess
import tempfile
import re
import telnetlib
import sys

CHIP_TIMEOUT = 4 # How long to wait for JTAG, in seconds

def usage():
    print "Usage: %s [binfile]"%(sys.argv[0],)
    sys.exit(1)

expect_found = False
expect_timeout = False

def alarmHandler(signum, frame):
    expect_timeout = True

# Wait until expected pattern is received on the given filehandle.
def expect(fh, pat, timeout=10):
    r = re.compile(pat)

    expect_found = False
    expect_timeout = False

    if (timeout != -1):
        signal.signal(signal.SIGALRM, alarmHandler)
        signal.alarm(timeout)

    while (not expect_found and not expect_timeout):
        try:
            line = fh.readline()
        except:
            # Possibly due to alarm
            break
        matches = r.findall(line)
        if (len(matches) != 0):
            expect_found = True
            break

    signal.alarm(0)
    if (not expect_found):
        raise RuntimeError, "Did not receive expected pattern '%s'" % pat

def main(argv):
    tn = None

    if (len(argv) > 2): usage()

    if (len(sys.argv) < 2):
        binfile = "build/stm32-p103/main.bin.out"
    else:
        binfile = argv[1]

    # Check to make sure filename exists
    if os.path.isfile(binfile) == False:
        print '"%s" does not exist. Exiting.' % binfile
        sys.exit()

    tempfn = None
    openocd_proc = None
    telnet_proc = None

    # Create a temporary file for the binary we want to install.
    # (This way openocd can read the file from /tmp.)
    tempfd, tempfn = tempfile.mkstemp(prefix="stm32-p103-ocd-program")

    try:
        print "Programming stm32-p103 with binary: %s" % binfile

        # Kill off any openocd daemons running.
        os.system("killall -q openocd")

        os.close(tempfd)  # Don't need to keep temp file open

        # Copy binary to temp file and set permissions correctly
        os.system("/bin/cp %s %s" % (binfile, tempfn))
        os.system("/bin/chmod 755 %s" % tempfn)

        print "Starting OpenOCD..."
        openocd_cmd = "openocd -f /usr/local/lib/openocd/interface/olimex-arm-usb-ocd.cfg -f /usr/local/lib/openocd/board/stm32f10x_128k_eval.cfg".split()
        openocd_proc = subprocess.Popen(openocd_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        expect(openocd_proc.stderr, "Info : JTAG Tap/device matched")

        # Connect to openocd daemon
        print "Connecting to OpenOCD..."

        time.sleep(0.1)
        tn = telnetlib.Telnet('localhost', 4444)

        # Uncomment the following line for debugging output
        #tn.set_debuglevel(10)

        data = tn.read_until('>', CHIP_TIMEOUT)
        if data == '':
            print "Could not connect to OpenOCD."
            sys.exit()
        tn.write('reset\n')
        tn.read_until('xPSR:')

        print "Halting device..."
        tn.read_until('>')
        tn.write('halt\n')

        print "Erasing flash..."
        tn.read_until('>')
        tn.write("stm32x mass_erase 0\n")
        tn.read_until("stm32x mass erase complete")

        print "Writing image..."
        tn.read_until('>')
        #tn.write('flash write_image %s\n' % (tempfn))
        tn.write('flash write_bank 0 %s 0\n'%(tempfn, ))
        tn.read_until('wrote')

        print "Resuming device..."
        tn.read_until('>')
        tn.write('reset\n')
        tn.read_until('target halted due to breakpoint')
        tn.read_until('>')
        tn.write('resume\n')
        tn.read_until('>')

        tn.close()

    finally:
        # Do all cleanup here
        print "Doing cleanup..."
        if (tn != None):
            try:
                tn.close()
            except:
                # Ignore
                pass
        if (openocd_proc != None): os.kill(openocd_proc.pid, 2)
        if (tempfn != None): os.unlink(tempfn)

if __name__ == "__main__":
    main(sys.argv)

