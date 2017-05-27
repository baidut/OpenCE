# OpenCE
Contrast Enhancement Techniques

* HE-based
  * BPDHE `bpdhe`
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
* Dehaze-based
  * Dong 

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

A New Image Contrast Enhancement Algorithm using Exposure Fusion Framework

submitted to CAIP 2017 [project website](https://baidut.github.io/OpenCE/caip2017.html)

```matlab
I = imread('yellowlily.jpg');
J = ours_caip2017(I); 
subplot 121; imshow(I); title('Original Image');
subplot 122; imshow(J); title('Enhanced Result');
```

Currently we only provide the .p code, the source code will be open soon.



Please feel free to contact me (yingzhenqiang-at-gmail-dot-com) if you have any further questions or concerns.