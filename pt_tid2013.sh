#!/usr/bin/env sh

TOOLS=/home/fuzhao/caffe/build/tools  # TODO  Changing to your Caffbin

$TOOLS/caffe.bin train --gpu 3 --solver=src/PT/tid2013/solver.prototxt --weights ./models/VGG16.caffemodel
