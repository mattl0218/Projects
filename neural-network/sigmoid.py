# Neural Network using Sigmoid Function

import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_iris
from sklearn.preprocessing import OneHotEncoder
import matplotlib.pyplot as plt

# Load Iris dataset
iris = load_iris()
X = iris.data[:,:2]
y = (iris.target == 2).astype(int)

Y = OneHotEncoder().fit_transform(y[:, np.newaxis]).toarray()

# Split the data set into training and testing
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

# Scale units
mean = np.mean(X_train, axis=0)
std = np.std(X_train, axis=0)

X_train = (X_train - mean) / std
X_test = (X_test - mean) / std


class Neural_Network(object):
  def __init__(self):
    # Size
    self.inputSize = X.shape[1]
    self.outputSize = Y.shape[1]
    self.hiddenSize = 10

    # Weight
    self.W1 = np.random.randn(self.inputSize, self.hiddenSize) 
    self.W2 = np.random.randn(self.hiddenSize, self.outputSize) 

  def forward(self, X):
    # Forward Propagation
    self.z = np.dot(X, self.W1) 
    self.z2 = self.sigmoid(self.z) # activation function
    self.z3 = np.dot(self.z2, self.W2) 
    o = self.sigmoid(self.z3) # updated activation function
    return o 

  def sigmoid(self, s):
    # activation function 
    return 1/(1+np.exp(-s))

  def sig_derivative(self, s):
    #derivative of sigmoid
    return s * (1 - s)

  def backward(self, X, y, o):
    # Backpropgate
    self.o_error = y - o 
    self.o_delta = self.o_error*self.sig_derivative(o) 

    self.z2_error = self.o_delta.dot(self.W2.T) 
    self.z2_delta = self.z2_error*self.sig_derivative(self.z2) 

    self.W1 += X.T.dot(self.z2_delta) 
    self.W2 += self.z2.T.dot(self.o_delta) 

  def train (self, X, y):
    # Train set
    o = self.forward(X)
    self.backward(X, y, o)

NN = Neural_Network()
loss = []

for i in range(1000):
    loss.append(np.mean(np.square(Y_train - NN.forward(X_train))))
    NN.train(X_train, Y_train)

# Calculate Training Accuracy
predicted_output_train = NN.forward(X_train)
predicted_output_train = np.argmax(predicted_output_train, axis=1)
Y_train_labels = np.argmax(Y_train, axis=1)
training_accuracy = np.sum(predicted_output_train == Y_train_labels) / len(Y_train_labels)
print(f"Training accuracy: {training_accuracy}")

# Calculate Testing Accuracy
predicted_output_test = NN.forward(X_test)
predicted_output_test = np.argmax(predicted_output_test, axis=1)
Y_test_labels = np.argmax(Y_test, axis=1)
testing_accuracy = np.sum(predicted_output_test == Y_test_labels) / len(Y_test_labels)
print(f"Testing accuracy: {testing_accuracy}")

# Plot data
plt.plot(loss)
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.show()
