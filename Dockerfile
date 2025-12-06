FROM ubuntu:22.04


RUN apt-get update && apt-get install -y \
    g++ \
    python3 \
    python3-pip \
    libreadline-dev \
    fuse3 \
    sudo \
    passwd \
    adduser \
    git \
    && rm -rf /var/lib/apt/lists/*


RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd
RUN chmod 440 /etc/sudoers.d/nopasswd

WORKDIR /workspace

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

RUN g++ -std=c++11 -pthread -D_FILE_OFFSET_BITS=64 -o kubsh src/main.cpp -lreadline -lfuse3
RUN chmod +x kubsh

RUN mkdir -p /opt/users && chmod 777 /opt/users

CMD ["python3", "-m", "pytest", "-v", "--tb=short"]
