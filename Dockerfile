FROM python:3.13-slim

WORKDIR /opt

RUN apt update  \
    && apt install -y --no-install-recommends make g++ libreadline-dev libfuse3-dev cmake \
    && rm -rf /var/lib/apt

COPY requirements.txt .

RUN pip install -r requirements.txt \
  && find / -name "*.pyc" -exec rm -f {} \; \
  && rm -rf /root/.cache/

COPY . .

RUN mkdir -p build && cd build && cmake .. && make && cp kubsh ../
RUN chmod +x kubsh

CMD ["python", "-m", "pytest", "-v"]
