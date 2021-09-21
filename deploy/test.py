#!/usr/bin/python3

import os
import sys
import pty
import subprocess
import tempfile

timeout = 30
target = sys.argv[1]
chal = target.split('_')[0]
#tmpdir = tempfile.mkdtemp(dir=os.path.join("/data/chaffctf/challog", target, "tmps"))
#dumpdir = tempfile.mkdtemp(dir=os.path.join("/data/chaffctf/challog", target, "dumps"))

cmd = ["docker", "run", "--rm", "-it",
        #"-u", ":".join([chal, chal]),
        #"-v", ":".join([tmpdir, "/tmp"]),
        #"-v", ":".join([dumpdir, "/dump"]),
        "-v", ":".join(["/home/hzzzh/ctfsetup/chaffctf_chal/exps", "/exps"]),
        target, "bash" , "-c",
        f"timeout -s 9 {str(timeout)} su -g {chal} {chal} -c bash"]
pty.spawn(cmd)
print("Bye!")
#subprocess.call(" ".join(cmd), shell=True)
