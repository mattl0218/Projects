# Face Modeling (Eigenfaces)

Script that creates a neural network to predict class labels.

## Problem

Build a neural network with one hidden layer to predict class labels for Iris plant dataset (https:
//archive.ics.uci.edu/ml/datasets/iris).

(1) [20pt] Properly split the data to training and testing set, and report the training, testing
accuracy. You can use sigmoid activation function and select any reasonable size of hidden units.
Note that for this part, you need to implement the forward/backward function yourself without
using the deep learning package. However, you can use the deep learning package, e.g., tensorflow,
pytorch, matconvnet etc, to compare with your own results.

(2) [10pt] Try different design of the neural network, compare with part (1), and report findings.

This is an open-ended question, you can change the previous model in several ways, e.g., (1) change
the activation function to be tanh, ReLU etc, or (2) try to build more complex neural network by
introducing more layers, or many other options. Note that for this part, you are allowed to use
deep learning packages.

## Installation

Install NumPy, scikit-learn, Matplotlib, and other required packages.
```
> pip install numpy scikit-learn matplotlib
```

## Example Usage

Test the neural network using the sigmoid function on Iris dataset
```
> python sigmoid.py
```

Test the neural network using the tanh function on Iris datatset
```
> python tanh.py
```
