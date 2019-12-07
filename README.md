# Introduction

The paper is under review, this source code is testing demo of the following technical report:

    @article{CLRIQA,
      author    = {Fu-Zhao {Ou} and
                   Yuan-Gen {Wang} and
                   Jin {Li} and
                   Guopu {Zhu} and
                   Sam {Kwong}},
      title     = {Controllable List-wise Ranking for Universal No-reference Image Quality Assessment},
      journal   = {arXiv preprint arXiv:1911.10566},
      year      = {2019},
    }

Abstract: No-reference image quality assessment (NR-IQA) has received increasing attention in the IQA community since reference image is not always available. Real-world images generally suffer from various types of distortion. Unfortunately, existing NR-IQA methods do not work with all types of distortion. It is a challenging task to develop universal NR-IQA that has the ability of evaluating all types of distorted images. In this paper, we propose a universal NR-IQA method based on controllable list-wise ranking (CLRIQA). First, to extend the authentically distorted image dataset, we present an imaging heuristic approach, in which the over-underexposure is formulated as an inverse of Weber-Fechner law, and fusion strategy and probabilistic compression are adopted, to generate the degraded real-world images. These degraded images are label-free yet associated with quality ranking information. We then design a controllable list-wise ranking function by limiting rank range and introducing an adaptive margin to tune rank interval. Finally, the extended dataset and controllable list-wise ranking function are used to pre-train a CNN. Moreover, in order to obtain an accurate prediction model, we take advantage of the original dataset to further fine-tune the pre-trained network. Experiments evaluated on four benchmark datasets (i.e. LIVE, CSIQ, TID2013, and LIVE-C) show that the proposed CLRIQA improves the state of the art by over 8% in terms of overall performance.

# Usage

All of testing operations are run in Caffe framework.
Our trained CNN models can be downloaded at https://pan.baidu.com/s/1yhgBTcxjeadnSCL5pEGiPw.

# License

We utilize the Caffe framework. Please check their licence files for details. Moreover, this source code is made available for research purpose only. 
