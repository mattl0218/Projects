# Face Modeling (Eigenfaces)

Script that creates eigenfaces using PCA code.

## Problem

[Principal Component Analysis, Dimension Reduction, Eigenface]
Face modelling serves as one of the most fundamental problems in modern artificial intelligence and
computer vision, and can be useful in various applications like face recognition, identification etc.
However, face images are usually of high-dimensional (e.g., a small 100 × 100 gray-scaled face image
has dimension 100 × 100 = 10, 000), therefore, find a suitable representation is utterly important.
In this problem, we apply the linear model, principal component analysis (PCA), on face images
to reduce the dimension and obtain eigenface representations.

Dataset: we use the dataset† which contains 177 face images. Each image contains 256 × 256
pixels and is gray-scaled (i.e., the value for each pixel is stored as unsigned integer between [0, 255],
typically, 0 is taken to be black and 255 is taken to be white). You need to split the dataset to be
train/test set, e.g., you could use the first 157 images for training, and the rest 20 faces for testing.

(1) [30pt] Write the PCA codes to compute K = 30 eigenfaces and visualize the top 10 eigen-
faces.

(2) [20pt] Use the learned K eigenfaces from (1) to reconstruct testing images, and record
the reconstruction error. The reconstruction error can be defined as || ˆY −Y ||2
N , where ˆY is the
reconstructed face using the learned eigenfaces, Y is the testing faces and N is the total number of
testing data. Please show 5 testing images and their reconstructed ones.

(3) [20pt] Try different values of K, e.g., try K = 10, 30, 50, 100, 150..., and draw the curve to
indicate the corresponding testing reconstruction errors. The x-axis of the curve can be different
K values, and the y-axis can be testing reconstruction error defined in (2).

† The dataset is coming from S.C. Zhu’s previous Stats 231: Pattern Recognition and
Machine Learning in UCLA.

## Installation

Install NumPy, Pillow, Matplotlib, and other required packages.
```
> pip install numpy Pillow matplotlib
```
Place your own data into `face-modeling/data/data.txt`.

## Example Usage

Test Pattern Recognition dataset
```
> python face-modeling.py
```

