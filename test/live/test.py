import numpy as np
import sys
import caffe
from scipy import stats
import cv2



caffe_root = '/home/fuzhao/caffe/build/tools'
test_file = '../../data/live/train_data/' + 'ft_test.txt'
MODEL_FILE = '../../src/FT/live/deploy.prototxt'
PRETRAINED_FILE = '../../models/live/FT.caffemodel'
file_scores = open('../../results/live/score.txt', 'a')

sys.path.insert(0, caffe_root + 'python')

caffe.set_device(3)
caffe.set_mode_gpu()

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
	sp = 224
        x =  im.shape[0]
        y = im.shape[1]
        x_p = np.random.randint(x-sp,size=1)[0]
        y_p = np.random.randint(y-sp,size=1)[0] 
 
        temp = im[x_p:x_p+sp,y_p:y_p+sp,:].transpose([2,0,1])

        out = net.forward_all(data=np.asarray([temp]))

        feat[i,j] = out['fc8_f'][0]
        pre[i] += out['fc8_f'][0]
    pre[i] /= Num_Patch
    med [i] = np.median(feat[i,:])
    file_scores.write(roidb[i] + '      ' + str(scores[i]) + '      ' + str(pre[i]) + '\n')
	    

srocc = stats.spearmanr(pre,scores)[0] 
lcc = stats.pearsonr(pre,scores)[0] 
print '% SROCC of mean: {}'.format(srocc)
print '%   LCC of mean : {}'.format(lcc)
file_scores.write('SROCC of mean = ' + '%6.5f\n' % ( srocc ) )
file_scores.write('PLCC of mean = ' + '%6.5f\n' % ( lcc ) )

srocc = stats.spearmanr(med,scores)[0] 
lcc = stats.pearsonr(med,scores)[0] 
print '% SROCC of median: {}'.format(srocc)
print '%   LCC of median: {}'.format(lcc)

file_scores.write('SROCC of median = ' + '%6.5f\n' % ( srocc ) )
file_scores.write('PLCC of median = ' + '%6.5f\n' % ( lcc ) )

