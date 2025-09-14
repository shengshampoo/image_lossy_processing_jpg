FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

RUN apk add --no-cache \
  bash curl xz tar 

RUN curl --create-dirs --output /images/4.jpg https://www.gstatic.com/webp/gallery/4.jpg

ENV XZ_OPT=-e9
COPY images images
COPY rust-parallel /usr/local/bin/rust-parallel
COPY cjpeg /usr/local/bin/cjpeg
COPY guetzli /usr/local/bin/guetzli
COPY image_lossy_processing_jpg.sh image_lossy_processing_jpg.sh
RUN chmod +x ./image_lossy_processing_jpg.sh
RUN chmod +x /usr/local/bin/*
RUN bash ./image_lossy_processing_jpg.sh
