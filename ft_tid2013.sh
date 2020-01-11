#!/usr/bin/env sh

TOOLS=/home/fuzhao/caffe/build/tools  # TODO  Changing to your Caffbin

$TOOLS/caffe.bin train --gpu 1 --solver=src/FT/tid2013/solver.prototxt --weights ./models/tid2013/PT.caffemodel
