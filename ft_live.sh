#!/usr/bin/env sh

TOOLS=/home/fuzhao/caffe/build/tools  # TODO  Changing to your Caffbin

$TOOLS/caffe.bin train --gpu 2 --solver=src/FT/live/solver.prototxt --weights ./models/live/PT.caffemodel
