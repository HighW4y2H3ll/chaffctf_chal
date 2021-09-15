From debian:buster-slim

Run dpkg --add-architecture i386
Run apt-get update && apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g-dev:i386 wget curl tcpdump

#Debug
#Run apt-get install -y strace

Arg target

Run useradd ${target}
#Run groupadd pwn
Run useradd -s /usr/sbin/nologin pwn

Run mkdir -p /home/${target}
Run chown pwn:pwn /home/${target}
Run chmod 555 /home/${target}

Workdir /home/${target}
Copy ${target} ${target}
Copy flag flag
Copy bash /bin/bash
Copy sh /bin/sh

Run chown pwn:pwn flag
Run chown ${target}:pwn ${target}
Run chmod 440 flag
Run chmod 550 ${target}
Run chmod g+s ${target}

# setup tcpdump service
Copy tcpdump /etc/init.d/tcpdump
Run chmod +x /etc/init.d/tcpdump
Run update-rc.d tcpdump defaults

#Entrypoint ["/bin/sh"]
