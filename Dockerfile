FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

RUN apk add --no-cache \
  bash curl xz tar libwebp-tools

# image from Digital Photography Review Galleries
# https://www.dpreview.com/sample-galleries
RUN curl --create-dirs --output /images/3827339379.jpg https://s3.amazonaws.com/files.prod.dpreview.com/sample_galleries/8491664854/3827339379.jpg && \
    curl --create-dirs --output /images/8742462568.jpg https://s3.amazonaws.com/files.prod.dpreview.com/sample_galleries/8491664854/8742462568.jpg && \
    curl --create-dirs --output /images/8925362357.jpg https://s3.amazonaws.com/files.prod.dpreview.com/sample_galleries/8491664854/8925362357.jpg

ENV XZ_OPT=-e9
COPY images images
COPY avifenc cjpeg cjxl gm guetzli image_lossy_processing_jpg.sh rust-parallel /usr/local/bin/
RUN chmod +x /usr/local/bin/* && bash /usr/local/bin/image_lossy_processing_jpg.sh
