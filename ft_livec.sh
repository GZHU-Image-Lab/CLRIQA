#!/usr/bin/env sh

TOOLS=/home/fuzhao/caffe/build/tools  # TODO  Changing to your Caffbin

$TOOLS/caffe.bin train --gpu 3 --solver=src/FT/livec/solver.prototxt --weights ./models/livec/PT.caffemodel
