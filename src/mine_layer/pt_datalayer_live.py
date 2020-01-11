import cv2
import caffe
import numpy as np
import multiprocessing as mtp
import pdb
import os.path as osp

class DataLayer(caffe.Layer):
    def setup(self, bottom, top):

        self._name_to_top_map = {}
        self._name_to_top_map['data'] = 0
        self._name_to_top_map['label'] = 1
        self.workers= mtp.Pool(10)
        params = eval(self.param_str)
        check_params(params)
        self.batch_size = params['batch_size']
        self.pascal_root = params['pascal_root']
        self.dataset_name = params['dataset_name']
        self.train_data = params['train_data']
        list_file = params['split'] + '.txt'
        filename = [line.rstrip('\n') for line in open(
            osp.join(self.pascal_root,self.dataset_name,self.train_data,list_file))]
        self._roidb = []
        self.scores =[]
        self.data = []
        for i in filename:
            self._roidb.append(i.split()[0])
            self.scores.append(float(i.split()[1]))
            self.data.append(i)
        self._perm = None
        self._cur = 0
        self.num =0
       
       
        top[0].reshape(
            self.batch_size, 3, params['im_shape'][0], params['im_shape'][1])
       
        top[1].reshape(self.batch_size, 1)    

    def _get_next_minibatch_inds(self):
        """Return the roidb indices for the next minibatch."""
        db_inds = []
        dis = 4     
        batch = 1   
        level = 6   
        dis_mini = 4 
        shuff = np.random.permutation(range(dis))
        Num = len(self.scores)/dis/level
        for k in shuff[:dis_mini]:
            for i in range(level):
                temp = self.num
                for j in range(batch):
                    db_inds.append(len(self.scores)/dis*k+i*Num+temp)    
                    temp = temp +1
        self.num = self.num+batch
        if Num-self.num<batch:
            self.num=0
        db_inds = np.asarray(db_inds)

        return db_inds



    def get_minibatch(self,minibatch_db):
        """Given a roidb, construct a minibatch sampled from it."""
      
        jobs =self.workers.map(preprocess,minibatch_db)
        index = 0
        images_train = np.zeros([self.batch_size,3,224,224],np.float32)
        for index_job in range(len(jobs)):
            images_train[index,:,:,:] = jobs[index_job]
            index += 1 
                       
        blobs = {'data': images_train}
        return blobs

    def forward(self, bottom, top):
        """Get blobs and copy them into this layer's top blob vector."""
        

        db_inds = self._get_next_minibatch_inds()
        minibatch_db = []
        for i in range(len(db_inds)):
            minibatch_db.append(self._roidb[int(db_inds[i])])
        scores = []
        for i in range(len(db_inds)):
            scores.append(self.scores[int(db_inds[i])])
        blobs = self.get_minibatch(minibatch_db)
        blobs ['label'] =np.asarray(scores)
        for blob_name, blob in blobs.iteritems():
            top_ind = self._name_to_top_map[blob_name]
            top[top_ind].reshape(*(blob.shape))
            top[top_ind].data[...] = blob.astype(np.float32, copy=False)

    def backward(self, top, propagate_down, bottom):
        """This layer does not propagate gradients."""
        pass

    def reshape(self, bottom, top):
        """Reshaping happens during the call to forward."""
        pass

def preprocess(data):

    sp = 224
    im = np.asarray(cv2.imread(data))
    x =  im.shape[0]
    y = im.shape[1]
    x_p = np.random.randint(x-sp,size=1)[0]
    y_p = np.random.randint(y-sp,size=1)[0]   
    images = im[x_p:x_p+sp,y_p:y_p+sp,:].transpose([2,0,1])
    return images

def check_params(params):
    """
    A utility function to check the parameters for the data layers.
    """
    assert 'split' in params.keys(
    ), 'Params must include split (train, val, or test).'

    required = ['batch_size', 'pascal_root', 'im_shape']
    for r in required:
        assert r in params.keys(), 'Params must include {}'.format(r)
