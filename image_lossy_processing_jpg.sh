
#! /bin/bash

set -e

mkdir -p /work/artifact
cd /images

/usr/local/bin/rust-parallel -r '(.*)\.(.*)' -p /usr/local/bin/gm mogrify -resize 1200x -strip -filter sinc {0} ::: $(find /images -maxdepth 1 -name "*.jpg" ! -name "*fs2.jpg"  ! -name "*fs2a.jpg" -type f -exec basename {} \; | awk '!seen[$0]++' | awk '{ printf("%s " , $0) }')

/usr/local/bin/rust-parallel -r '(.*)\.(.*)' -p /usr/local/bin/cjpeg -outfile {1}-fs2.jpg {0} ::: $(find /images -maxdepth 1 -name "*.jpg" ! -name "*fs2.jpg"  ! -name "*fs2a.jpg" -type f -exec basename {} \; | awk '!seen[$0]++' | awk '{ printf("%s " , $0) }')

/usr/local/bin/rust-parallel -r '(.*)\.(.*)' -p /usr/local/bin/guetzli --verbose {0} {1}a.jpg ::: $(find /images -maxdepth 1 -name "*fs2.jpg" ! -name "*fs2a.jpg" -type f -exec basename {} \; | awk '!seen[$0]++' | awk '{ printf("%s " , $0) }')

/usr/local/bin/rust-parallel -r '(.*)\.(.*)' -p /usr/local/bin/avifenc {0} {1}.avif ::: $(find /images -maxdepth 1 -name "*.jpg" ! -name "*fs2.jpg"  ! -name "*fs2a.jpg" -type f -exec basename {} \; | awk '!seen[$0]++' | awk '{ printf("%s " , $0) }')

/usr/local/bin/rust-parallel -r '(.*)\.(.*)' -p /usr/local/bin/cjxl {0} {1}.jxl ::: $(find /images -maxdepth 1 -name "*.jpg" ! -name "*fs2.jpg"  ! -name "*fs2a.jpg" -type f -exec basename {} \; | awk '!seen[$0]++' | awk '{ printf("%s " , $0) }')

tar vcJf ./images.tar.xz *.jpg *.avif *.jxl

mv ./images.tar.xz /work/artifact/
