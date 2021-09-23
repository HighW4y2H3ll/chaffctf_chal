#!/usr/bin/python3.8

import os
import sys
import pty
import subprocess
import tempfile
import shlex

timeout = 30
target = sys.argv[1]
chal = target.split('_')[0]
tmpdir = tempfile.mkdtemp(dir=os.path.join("/data/chaffctf/challog", target))
docker_tmpdir = os.path.join(tmpdir, "tmp")
sessiondir = os.path.join(tmpdir, "session")
os.mkdir(docker_tmpdir)
os.mkdir(sessiondir)
tmplog = os.path.join(tmpdir, "session_log.txt")
docker_cmd = ["docker", "run", "--rm", "-it",
        "-m", "256m", "--cpus=2",
        "-e", "SSLKEYLOGFILE=/run/.url/.session",
        #"-u", ":".join([chal, chal]),
        "-v", ":".join([docker_tmpdir, "/tmp"]),
        "-v", ":".join([sessiondir, "/run/.url"]),
        target, "bash" , "-c",
        f"chmod 777 /run/.url && chmod 1777 /tmp && timeout -s 9 {str(timeout)} su -g {chal} {chal} -c bash"]

cmd = ["script", tmplog, "-q", "-c", shlex.join(docker_cmd) ]

pty.spawn(cmd)
print("Bye!")
#subprocess.call(" ".join(cmd), shell=True)
