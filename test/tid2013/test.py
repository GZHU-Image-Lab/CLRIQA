import numpy as np
import sys
import caffe
from scipy import stats
import cv2


caffe_root = '/home/XXX/caffe/build/tools'
test_file = '/home/XXX/Desktop/CLRIQA/data/tid2013/' + 'ft_test.txt'
MODEL_FILE = '/home/XXX/Desktop/CLRUBIQA--master/src/FT/tid2013/deploy.prototxt'
PRETRAINED_FILE = '/home/XXX/Desktop/CLRIQA/models/test_models/TID2013.caffemodel'

sys.path.insert(0, caffe_root + 'python')

caffe.set_device(0)
caffe.set_mode_gpu()


ft = 'fc8_m'  # The output of network


tp = 'FT_all' 

net = caffe.Net(MODEL_FILE, PRETRAINED_FILE, caffe.TEST)


filename = [line.rstrip('\n') for line in open(test_file)]

roidb = []
scores =[]
for i in filename:
    roidb.append(i.split()[0])
    scores.append(float(i.split()[1]))
scores = np.asarray(scores)


Num_Patch = 60
Num_Image = len(scores)
feat = np.zeros([Num_Image,Num_Patch])
pre = np.zeros(Num_Image)
med = np.zeros(Num_Image)

for i in range(Num_Image):
    directory = roidb[i]
    im = np.asarray(cv2.imread(directory))
    for j in range(Num_Patch):   
        x =  im.shape[0]
        y = im.shape[1]
        x_p = np.random.randint(x-224,size=1)[0]
        y_p = np.random.randint(y-224,size=1)[0] 
 
        temp = im[x_p:x_p+224,y_p:y_p+224,:].transpose([2,0,1])

        out = net.forward_all(data=np.asarray([temp]))

        feat[i,j] = out[ft][0]
        pre[i] += out[ft][0]
    pre[i] /= Num_Patch
    med [i] = np.median(feat[i,:])	    

srocc = stats.spearmanr(pre,scores)[0] 
lcc = stats.pearsonr(pre,scores)[0] 

print '% SROCC: {}'.format(srocc)
print '%   LCC: {}'.format(lcc)
