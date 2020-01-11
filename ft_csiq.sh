#!/usr/bin/env sh

TOOLS=/home/fuzhao/caffe/build/tools  # TODO  Changing to your Caffbin

$TOOLS/caffe.bin train --gpu 3 --solver=src/FT/csiq/solver.prototxt --weights ./models/csiq/PT.caffemodel
