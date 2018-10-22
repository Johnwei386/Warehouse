from __future__ import print_function

import matplotlib
import numpy as np
from scipy.ndimage import uniform_filter

def extract_features(imgs, feature_fns, verbose=False):
  """
  Given pixel data for images and several feature functions that can operate on
  single images, apply all feature functions to all images, concatenating(级联) the
  feature vectors for each image and storing the features for all images in
  a single matrix.

  Inputs:
  - imgs: N x H X W X C array of pixel data for N images.
  - feature_fns: List of k feature functions. The ith feature function should
    take as input an H x W x D array and return a (one-dimensional) array of
    length F_i.
  - verbose: Boolean; if true, print progress.

  Returns:
  An array of shape (N, F_1 + ... + F_k) where each column is the concatenation
  of all features for a single image.
  """
  num_images = imgs.shape[0]
  if num_images == 0:
    return np.array([])

  # Use the first image to determine feature dimensions
  # 处理第1张图片数据
  feature_dims = []
  first_image_features = []
  for feature_fn in feature_fns:
    # 32x32x3=3072,图像特征提取函数返回一个1维数组
    feats = feature_fn(imgs[0].squeeze())
    # 不满足断言测试条件时,返回错误
    assert len(feats.shape) == 1, 'Feature functions must be one-dimensional'
    # 所有元素的个数,对图片而言就是所有像素点的个数
    feature_dims.append(feats.size)
    first_image_features.append(feats)

  # Now that we know the dimensions of the features, we can allocate a single
  # big array to store all features as columns.
  # nx3072,n为特征函数的数目
  total_feature_dim = sum(feature_dims)
  # 初始化构建图像特征数组,nx(f_1+f2+...+f_n)
  imgs_features = np.zeros((num_images, total_feature_dim))
  # 按列堆叠第1张图片的所有特征到图像特征数组
  imgs_features[0] = np.hstack(first_image_features).T

  # Extract features for the rest of the images.
  for i in range(1, num_images):
    idx = 0 # 
    for feature_fn, feature_dim in zip(feature_fns, feature_dims):
      # 下一个特征的起始索引位置
      next_idx = idx + feature_dim 
      imgs_features[i, idx:next_idx] = feature_fn(imgs[i].squeeze())
      idx = next_idx
    if verbose and i % 1000 == 0:
      print('Done extracting features for %d / %d images' % (i, num_images))

  return imgs_features


def rgb2gray(rgb):
  """Convert RGB image to grayscale

    Parameters:
      rgb : RGB image

    Returns:
      gray : grayscale image
  
  """
  # 每个通道缩放相关比例后相加,返回1张2维灰度图片
  return np.dot(rgb[...,:3], [0.299, 0.587, 0.144])


def hog_feature(im):
  """Compute Histogram of Gradient (HOG) feature for an image
     提取图像纹理特征
  
       Modified from skimage.feature.hog
       http://pydoc.net/Python/scikits-image/0.4.2/skimage.feature.hog
     
     Reference:
       Histograms of Oriented Gradients for Human Detection
       Navneet Dalal and Bill Triggs, CVPR 2005
     
    Parameters:
      im : an input grayscale or rgb image
      
    Returns:
      feat: Histogram of Gradient (HOG) feature
    
  """
  
  # convert rgb to grayscale if needed
  # 检验维度,3维图片,转换为灰度图片
  if im.ndim == 3:
    image = rgb2gray(im)
  else:
    image = np.at_least_2d(im)

  # image.shape = 32x32
  sx, sy = image.shape # image size
  orientations = 9 # number of gradient bins
  cx, cy = (8, 8) # pixels per cell

  gx = np.zeros(image.shape)
  gy = np.zeros(image.shape)
  # diff,沿轴计算i+1号元素和i元素的差值,n计算次数,默认最后一个轴
  gx[:, :-1] = np.diff(image, n=1, axis=1) # compute gradient on x-direction(行)
  gy[:-1, :] = np.diff(image, n=1, axis=0) # compute gradient on y-direction(列)
  grad_mag = np.sqrt(gx ** 2 + gy ** 2) # gradient magnitude(幅度)
  # 对y/x求反正切函数返回一个弧度制的数组,取值在[-pi,pi]之间,32x32
  # y轴在第1位
  grad_ori = np.arctan2(gy, (gx + 1e-15)) * (180 / np.pi) + 90 # gradient orientation

  n_cellsx = int(np.floor(sx / cx))  # number of cells in x
  n_cellsy = int(np.floor(sy / cy))  # number of cells in y
  # compute orientations integral images
  orientation_histogram = np.zeros((n_cellsx, n_cellsy, orientations))
  for i in range(orientations):
    # create new integral image for this orientation
    # isolate orientations in this range,过滤噪声
    temp_ori = np.where(grad_ori < 180 / orientations * (i + 1),
                        grad_ori, 0)
    temp_ori = np.where(grad_ori >= 180 / orientations * i,
                        temp_ori, 0)
    # select magnitudes for those orientations
    cond2 = temp_ori > 0
    temp_mag = np.where(cond2, grad_mag, 0) # 32x32
    # [::-1]表示以-1为间隔,4::8表示从第4号索引开始,以8为间隔来索引数组
    # 32x32图片,行轴和列轴以8个像素为间隔均匀滤波
    # 对某个i,[:,:,i].shape=4
    orientation_histogram[:,:,i] = uniform_filter(temp_mag, size=(cx, cy))[int(cx/2)::cx, int(cy/2)::cy].T
     
  return orientation_histogram.ravel() #扁平化数组,这里扁平化为4x4x9=144个元素


def color_histogram_hsv(im, nbin=10, xmin=0, xmax=255, normalized=True):
  """
  Compute color histogram for an image using hue.

  Inputs:
  - im: H x W x C array of pixel data for an RGB image.
  - nbin: Number of histogram bins. (default: 10)
  - xmin: Minimum pixel value (default: 0)
  - xmax: Maximum pixel value (default: 255)
  - normalized: Whether to normalize the histogram (default: True)

  Returns:
    1D vector of length nbin giving the color histogram over the hue of the
    input image.
  """
  ndim = im.ndim
  # 返回n个在[s,e]之间指定间隔的数字
  bins = np.linspace(xmin, xmax, nbin+1)
  # 将图像rgb值转换为hsv值(色调,饱和度,亮度),rgb_to_hsv输入输出数组的值在[0,1]之间,
  # 因此对原始图片的像素值/255,对返回值x255
  hsv = matplotlib.colors.rgb_to_hsv(im/xmax) * xmax
  # 直方图,bins是x轴区块大小,normalized归一化处理,输入数组落入区块中的个数,归一化为概率(分布)
  # 提取图像主色调值进行处理
  imhist, bin_edges = np.histogram(hsv[:,:,0], bins=bins, density=normalized)
  # 将分布概率转化为具体的分值,10x1大小
  imhist = imhist * np.diff(bin_edges)

  # return histogram
  return imhist


pass
