FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    g++ \
    python3 \
    python3-pip \
    libreadline-dev \
    sudo \
    adduser \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd

# КРИТИЧЕСКИ ВАЖНО: создаем /etc/passwd с пользователями
RUN echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd && \
    echo "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin" >> /etc/passwd && \
    echo "bin:x:2:2:bin:/bin:/usr/sbin/nologin" >> /etc/passwd && \
    echo "sys:x:3:3:sys:/dev:/usr/sbin/nologin" >> /etc/passwd && \
    echo "sync:x:4:65534:sync:/bin:/bin/sync" >> /etc/passwd && \
    echo "games:x:5:60:games:/usr/games:/usr/sbin/nologin" >> /etc/passwd && \
    echo "man:x:6:12:man:/var/cache/man:/usr/sbin/nologin" >> /etc/passwd && \
    echo "lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "mail:x:8:8:mail:/var/mail:/usr/sbin/nologin" >> /etc/passwd && \
    echo "news:x:9:9:news:/var/spool/news:/usr/sbin/nologin" >> /etc/passwd && \
    echo "uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin" >> /etc/passwd && \
    echo "proxy:x:13:13:proxy:/bin:/usr/sbin/nologin" >> /etc/passwd && \
    echo "www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin" >> /etc/passwd && \
    echo "backup:x:34:34:backup:/var/backups:/usr/sbin/nologin" >> /etc/passwd && \
    echo "list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin" >> /etc/passwd && \
    echo "irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin" >> /etc/passwd && \
    echo "nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin" >> /etc/passwd && \
    echo "systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "messagebus:x:103:106::/nonexistent:/usr/sbin/nologin" >> /etc/passwd && \
    echo "syslog:x:104:110::/home/syslog:/usr/sbin/nologin" >> /etc/passwd && \
    echo "_apt:x:105:65534::/nonexistent:/usr/sbin/nologin" >> /etc/passwd && \
    echo "tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false" >> /etc/passwd && \
    echo "uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin" >> /etc/passwd && \
    echo "landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin" >> /etc/passwd && \
    echo "pollinate:x:110:1::/var/cache/pollinate:/bin/false" >> /etc/passwd && \
    echo "sshd:x:111:65534::/run/sshd:/usr/sbin/nologin" >> /etc/passwd && \
    echo "systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin" >> /etc/passwd && \
    echo "lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false" >> /etc/passwd && \
    echo "testuser:x:1000:1000:Test User:/home/testuser:/bin/bash" >> /etc/passwd

WORKDIR /workspace
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY . .

RUN g++ -std=c++11 -pthread -o kubsh src/main.cpp -lreadline
RUN chmod +x kubsh

CMD ["python3", "-m", "pytest", "-v"]
