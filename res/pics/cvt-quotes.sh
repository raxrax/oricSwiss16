#!/bin/sh

rm -rf output output-bw output-dither pic_*.s 
[ x"$1" == "x-c" ] && exit 0

OSDK=${HOME}/work/projects/8Bit/devtools/osdk

mkdir -p output output-bw output-dither

# dither|bw
use=dither

size="240x200"
gravity="center"
bgcolor="black"
bgcolor2="black"

for i in orig-wozsquotes/*.jpg
do 
  convert $i -strip \
  +dither  -colors 2  -colorspace gray -normalize \
  +repage \
  output-bw/$(basename ${i/.jpg/.png})
  convert $i -strip \
  -colors 2 -colorspace gray +dither -normalize \
  +repage \
  output-dither/$(basename ${i/.jpg/.png})
done
cp -f output-bw/4.png output-bw/0.png
cp -f output-dither/4.png output-dither/0.png

pcopt="-f0 -o2"
pcopt2="-f0 -o0"
for i in output-${use}/*.png
do
 ${OSDK}/bin/pictconv ${pcopt} $i output/$(basename ${i/.png/.raw})
 ${OSDK}/bin/pictconv ${pcopt2} $i output/$(basename ${i/.png/.tap})
done

g++ -o fhpack fhpack.cpp
for i in output/*.raw
do
 ./fhpack -c -h -9 $i ${i/.raw/.lz4}
 ${OSDK}/bin/bin2txt -s1 -f2 -h1 -n16 \
 ${i/.raw/.lz4} "pic_$(basename ${i/.raw/.s})" "_pic_$(basename ${i/.raw/})" >/dev/null
 chmod 0644 "pic_$(basename ${i/.raw/.s})"
done
rm -rf fhpack output-bw output-dither
