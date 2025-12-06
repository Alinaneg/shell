FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    g++ \
    python3 \
    python3-pip \
    libreadline-dev \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd
RUN echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd && \
    echo "testuser:x:1000:1000:Test User:/home/testuser:/bin/bash" >> /etc/passwd && \
    echo "bashuser:x:1001:1001:Bash User:/home/bashuser:/bin/bash" >> /etc/passwd

WORKDIR /workspace
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY . .

RUN g++ -std=c++11 -pthread -o kubsh src/main.cpp -lreadline
RUN chmod +x kubsh


RUN mkdir -p /opt/users                   
RUN mkdir -p /workspace                

RUN ln -sf /opt/users /workspace/users

RUN echo "=== Проверка симлинка ===" && \
    echo "Содержимое /workspace:" && \
    ls -la /workspace/ && \
    echo "" && \
    echo "Куда ведёт симлинк:" && \
    readlink -f /workspace/users

CMD ["python3", "-m", "pytest", "-v", "--tb=short"]
