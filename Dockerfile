FROM ubuntu:18.04

ENV PYTHONUNBUFFERED 1

# Turn off debconf messages during build
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Install system dependencies
# Docker says run apt-get update and install together,
# and then rm /var/lib/apt/lists to reduce image size.
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:alex-p/tesseract-ocr
RUN apt-get update && apt-get install -y tesseract-ocr-all
RUN apt-get update && apt-get install -y \
    python3-pil \
    python3-requests \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add requirements
COPY ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip install -r requirements.txt

# add app
COPY . /usr/src/app
