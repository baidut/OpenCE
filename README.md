# OpenCE
Contrast Enhancement Techniques

## Methods

### Lowlight Image Enhancement

* HE-based
  * BPDHE `bpdhe`
  * DHE  A Dynamic Histogram Equalization for Image Contrast Enhancement IEEE TCE 2007
  * DHECI
  * CLAHE (Contrast-limited adaptive histogram equalization) `clahe` `clahe_lab `
  * WAHE (Weighted Approximated Histogram Equalization)
  * CVC (Contextual and Variational Contrast enhancement) [PDF](http://ieeexplore.ieee.org/abstract/document/5773086/) 
  * LDR (Layered Difference Representation) [website](http://mcl.korea.ac.kr/cwlee_tip2013/) (CVC, WAHE)
* Retinex-based
  * AMSR
  * LIME [website](http://cs.tju.edu.cn/orgs/vision/~xguo/LIME.htm)
  * NPE  [website](http://blog.sina.com.cn/s/blog_a0a06f190101cvon.html)
  * SRIE (Simultaneous Reflection and Illumination Estimation) [CVPR2016](http://www.cv-foundation.org/openaccess/content_cvpr_2016/html/Fu_A_Weighted_Variational_CVPR_2016_paper.html) [website](http://smartdsp.xmu.edu.cn/cvpr2016.html)
  * MF (Multi-deviation Fusion method) [website](http://smartdsp.xmu.edu.cn/weak-illumination.html)
  * `others/robustRetinex.m` Structure-Revealing Low-Light Image Enhancement Via Robust Retinex Model (TIP 2018) [website](https://github.com/martinli0822/Low-light-image-enhancement)
* Dehaze-based
  * Dong 
* Camera-Response-Model-based
  * [Ying_2017_ICCV.m](https://github.com/baidut/OpenCE/blob/master/ours/Ying_2017_ICCV.m)
* Fusion-based
  * [Ying_2017_CAIP.m ](https://github.com/baidut/OpenCE/blob/master/ours/Ying_2017_CAIP.m)   [python version](https://github.com/AndyHuang1995/New-Image-Contrast-Enhancement)
* Deep-learning-based
  * Learning a Deep Single Image Contrast Enhancer from Multi-Exposure Images *TIP 2018* [website](https://github.com/csjcai/SICE)
* Others
  * `others/jed.m` JED "[Joint Enhancement and Denoising Method via Sequential Decomposition](http://www.icst.pku.edu.cn/course/icb/Projects/JED.html)" , *ISCAS 2018* [website](https://github.com/tonghelen/JED-Method)

### Related Work

- [Fast Image Processing with Fully-Convolutional Networks (ICCV 2017)](http://www.cqf.io/papers/Fast_Image_Processing_ICCV2017.pdf) (<https://github.com/CQFIO/FastImageProcessing>)
- [Deep Bilateral Learning for Real-Time Image Enhancements (Siggraph 2017)](https://groups.csail.mit.edu/graphics/hdrnet/data/hdrnet.pdf) (<https://github.com/mgharbi/hdrnet>)

## Test Images

- 500 from [Berkeley Segmentation Data Set and Benchmarks 500 (BSDS500)](http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html#bsds500)
- 24 from [Kodak Lossless True Color Image Suite](http://r0k.us/graphics/kodak/)
- 7 of 4.2.0x from [The USCI-SIPI Image Database, Volume 3: Miscellaneous](http://sipi.usc.edu/database/database.php?volume=misc)
- 69 captured images from commercial digital cameras: [Download (15.3 MB)](http://mcl.korea.ac.kr/projects/LDR/LDR_TEST_IMAGES_DICM.zip)
- 4 synthetic images: [Download (445 kB)](http://mcl.korea.ac.kr/projects/LDR/LDR_TEST_IMAGES_SYNTHETIC.zip)



## Metrics

- entropy (DE)
- EME
- AB
- PixDist
- LOE

## Publications

Source code can be found at `ours` folder:

1. A New Image Contrast Enhancement Algorithm using Exposure Fusion Framework (accepted by CAIP 2017，journal version submitted to IEEE Transactions on Cybernetics)  [project website](https://baidut.github.io/OpenCE/caip2017.html)


2. A New Low-Light Image Enhancement Algorithm using Camera Response Model (accepted by ICCV Workshop 2017)

## Citations

```
@inproceedings{fu2016srie,
  title={A weighted variational model for simultaneous reflectance and illumination estimation},
  author={Fu, Xueyang and Zeng, Delu and Huang, Yue and Zhang, Xiao-Ping and Ding, Xinghao},
  booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
  pages={2782--2790},
  year={2016}
}
@article{celik2011cvc,
  title={Contextual and variational contrast enhancement},
  author={Celik, Turgay and Tjahjadi, Tardi},
  journal={IEEE Transactions on Image Processing},
  volume={20},
  number={12},
  pages={3431--3441},
  year={2011},
  publisher={IEEE}
}
@inproceedings{lee2012ldr,
  title={Contrast enhancement based on layered difference representation},
  author={Lee, Chulwoo and Lee, Chul and Kim, Chang-Su},
  booktitle={Image Processing (ICIP), 2012 19th IEEE International Conference on},
  pages={965--968},
  year={2012},
  organization={IEEE}
}
@article{arici2009wahe,
  title={A histogram modification framework and its application for image contrast enhancement},
  author={Arici, Tarik and Dikbas, Salih and Altunbasak, Yucel},
  journal={IEEE Transactions on image processing},
  volume={18},
  number={9},
  pages={1921--1935},
  year={2009},
  publisher={IEEE}
}
@article{fu2016mf,
  title={A fusion-based enhancing method for weakly illuminated images},
  author={Fu, Xueyang and Zeng, Delu and Huang, Yue and Liao, Yinghao and Ding, Xinghao and Paisley, John},
  journal={Signal Processing},
  volume={129},
  pages={82--96},
  year={2016},
  publisher={Elsevier}
}
@article{ibrahim2007bpdhe,
  title={Brightness preserving dynamic histogram equalization for image contrast enhancement},
  author={Ibrahim, Haidi and Kong, Nicholas Sia Pik},
  journal={IEEE Transactions on Consumer Electronics},
  volume={53},
  number={4},
  pages={1752--1758},
  year={2007},
  publisher={IEEE}
}
@inproceedings{lee2013amsr,
  title={Adaptive multiscale retinex for image contrast enhancement},
  author={Lee, Chang-Hsing and Shih, Jau-Ling and Lien, Cheng-Chang and Han, Chin-Chuan},
  booktitle={Signal-Image Technology \& Internet-Based Systems (SITIS), 2013 International Conference on},
  pages={43--50},
  year={2013},
  organization={IEEE}
}
@inproceedings{dong2011fast,
  title={Fast efficient algorithm for enhancement of low lighting video},
  author={Dong, Xuan and Wang, Guan and Pang, Yi and Li, Weixin and Wen, Jiangtao and Meng, Wei and Lu, Yao},
  booktitle={2011 IEEE International Conference on Multimedia and Expo},
  pages={1--6},
  year={2011},
  organization={IEEE}
}
@inproceedings{nakai2013dheci,
  title={Color image contrast enhacement method based on differential intensity/saturation gray-levels histograms},
  author={Nakai, Keita and Hoshi, Yoshikatsu and Taguchi, Akira},
  booktitle={Intelligent Signal Processing and Communications Systems (ISPACS), 2013 International Symposium on},
  pages={445--449},
  year={2013},
  organization={IEEE}
}
@article{Cai2018deep,
title={Learning a Deep Single Image Contrast Enhancer from Multi-Exposure Images}, 
author={Cai, Jianrui and Gu, Shuhang and Zhang, Lei},
journal={IEEE Transactions on Image Processing},
volume={27}, 
number={4}, 
pages={2049-2062}, 
year={2018}, 
publisher={IEEE}
}
```

**Please feel free to contact me (yingzhenqiang-at-gmail-dot-com) if you have any further questions or concerns.** 