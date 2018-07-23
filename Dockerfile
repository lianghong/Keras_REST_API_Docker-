FROM amazonlinux:latest
MAINTAINER lianghong <feilianghong@gmail.com>

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN yum update -y && yum install -y \
    gcc \
    python36 \
    python36-devel \
    nginx

# copy over our requirements.txt file
COPY requirements.txt /tmp/
# upgrade pip and install required python packages
RUN pip-3.6 install -U pip
RUN pip3 install -r /tmp/requirements.txt
RUN touch /etc/sysconfig/network

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
CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/bin/gunicorn", "--config", "/deploy/gunicorn_config.py", "main:app"]
CMD ["circusd","/etc/circus.conf"]

