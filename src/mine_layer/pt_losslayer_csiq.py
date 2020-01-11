import caffe
import numpy as np
import pdb

class MyLossLayer(caffe.Layer):
    """Controallable list-wise loss function."""

    def setup(self, bottom, top):
        print '*********************** SETTING UP'
        pass

    def forward(self, bottom, top):
        """The parameters here have the same meaning as data_layer"""

        batch = 1
        level = 6
        dis = 5
        SepSize = batch*level
        self.dis = []

        for k in range(dis):

            self.margin = (1-bottom[1].data[k*SepSize]) / level

            for i in range(SepSize*k,SepSize*(k+1)-batch):
                for j in range(SepSize*k + int((i-SepSize*k)/batch+1)*batch,SepSize*(k+1)):
                    self.dis.append(self.margin - (bottom[0].data[j]-bottom[0].data[i]) )
          
	    upper_loss = 0
	    upper_loss +=  np.sqrt(np.square(bottom[0].data[k*level] - bottom[1].data[k*level]))
	    
	    self.lower_dis = []
	    self.lower_dis.append(bottom[0].data[k*level+5] - 1)

	self.lower_dis = np.asarray(self.lower_dis)
	self.lower_dis = np.sum(np.maximum(0,self.lower_dis))
          
        self.dis = np.asarray(self.dis)        
        self.loss = np.maximum(0,self.dis)

        top[0].data[...] = upper_loss/dis + np.sum(self.loss)/bottom[0].num + self.lower_dis/dis






    def backward(self, top, propagate_down, bottom):
        """The parameters here have the same meaning as data_layer"""
        batch=1
        index = 0
        level = 6
        dis = 5
        SepSize = batch*level
        self.ref= np.zeros(bottom[0].num,dtype=np.float32)

        for k in range(dis):
            for i in range(SepSize*k,SepSize*(k+1)-batch):
                for j in range(SepSize*k + int((i-SepSize*k)/batch+1)*batch,SepSize*(k+1)):
                    if self.loss[index]>0:
                        self.ref[j] += -0.1
                        self.ref[i] += +0.1
                    index +=1

        for k in range(dis):
		index = k*SepSize
		self.ref[index] = (bottom[0].data[index] - bottom[1].data[index])*level


        for k in range(dis):
		if (bottom[0].data[(k+1)*SepSize-1] > 1):
			self.ref[(k+1)*SepSize-1] += (bottom[0].data[(k+1)*SepSize-1]-1)*level
	
	bottom[0].diff[...]= np.reshape(self.ref,(bottom[0].num,1))/bottom[0].num

                 
    def reshape(self, bottom, top):
        """Reshaping happens during the call to forward."""
        top[0].reshape(1)
 
