import caffe
import numpy as np
import pdb
import os.path as osp
import math

class MyLossLayer(caffe.Layer):
    """Controllable list-wise ranking function."""

    def setup(self, bottom, top):
        



        print '*********************** SETTING UP'
        pass

    def forward(self, bottom, top):
	
	"""The forward """
        batch = 1
        level = 6
        dis = 7
        SepSize = batch * level
        self.dis = []

        for k in range(dis):
	    self.margin = bottom[1].data[k*SepSize] / level
            for i in range(SepSize*k,SepSize*(k+1)-batch):
                for j in range(SepSize*k + int((i-SepSize*k)/batch+1)*batch,SepSize*(k+1)):
                    self.dis.append(self.margin - (bottom[0].data[i]-bottom[0].data[j]) )
                    self.Num +=1


        self.dis = np.asarray(self.dis)
        self.loss = np.maximum(0,self.dis)

	if (bottom[0].data[SepSize-1] < 0 ):
		top[0].data[...] = np.sqrt(np.square(bottom[0].data[0] - bottom[1].data[0]))/100 + np.sum(self.loss)/18 + np.sqrt(np.square(bottom[0].data[SepSize-1] - 0))/100

	else:
		top[0].data[...] =  np.sqrt(np.square(bottom[0].data[0] - bottom[1].data[0]))/100 + np.sum(self.loss)/18




		

    def backward(self, top, propagate_down, bottom):
        """The parameters here have the same meaning as data_layer"""

        batch=1
        index = 0
        level = 6
        dis = 7
        SepSize = batch * level
        self.ref= np.zeros(bottom[0].num,dtype=np.float32)

        for k in range(dis):
            for i in range(SepSize*k,SepSize*(k+1)-batch):
                for j in range(SepSize*k + int((i-SepSize*k)/batch+1)*batch,SepSize*(k+1)):

		    if self.loss[index]>0:
                        self.ref[i] += -1
                        self.ref[j] += +1
                    index +=1

        for k in range(dis):
		index = k*SepSize
		self.ref[index] = (bottom[0].data[index] - bottom[1].data[index])*bottom[0].num /100

        for k in range(dis):
		if (bottom[0].data[(k+1)*SepSize-1] < 0):
			self.ref[(k+1)*SepSize-1] += bottom[0].data[(k+1)*SepSize-1]*bottom[0].num /100

	bottom[0].diff[...]= np.reshape(self.ref,(bottom[0].num,1))/bottom[0].num


                
    def reshape(self, bottom, top):
        """Reshaping happens during the call to forward."""

        top[0].reshape(1)
 
