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
RUN chmod 440 /etc/sudoers.d/nopasswd

WORKDIR /workspace
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY . .

RUN g++ -std=c++17 -pthread -o kubsh src/main.cpp -lreadline
RUN chmod +x kubsh
RUN mkdir -p /opt/users && chmod 777 /opt/users

CMD ["python3", "-m", "pytest", "-v"]
