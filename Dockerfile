FROM ubuntu:latest
MAINTAINER lianghong <feilianghong@gmail.com>

RUN apt-get update && apt-get upgrade -y \
    gcc \
    python3.6 \
    python3-pip \
    python3.6-dev \
    nginx \
&& rm -rf /var/lib/apt/lists/*

# copy over our requirements.txt file
COPY requirements.txt /tmp/
# upgrade pip and install required python packages
RUN pip3 install -U pip
RUN python3 -m pip install -r /tmp/requirements.txt

# Setup flask application
RUN mkdir -p /deploy/app
COPY gunicorn_config.py /deploy/gunicorn_config.py
COPY app /deploy/app

WORKDIR /deploy/app
RUN mkdir -p /root/.keras/models
COPY models /root/.keras/models

#nginx & circused setting
COPY nginx.conf /etc/nginx/nginx.conf
COPY circus.conf /etc/circus.conf

EXPOSE 8000/tcp 5555/tcp

WORKDIR /deploy/app
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
CMD ["/usr/local/bin/gunicorn", "--config", "/deploy/gunicorn_config.py", "main:app"]
CMD ["/usr/local/bin/circusd","/etc/circus.conf"]
