# Matthew Luzzi
# "I pledge my honor that I have abided by the Stevens Honor System"

import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import os

path = './face_data/'
image_files = os.listdir(path)
image_list = []

for img_file in image_files:
    img_path = os.path.join(path, img_file)
    img = Image.open(img_path)
    image_list.append(np.array(img).reshape(256*256)) # Load images and flatten to 1D

train_images = image_list[:157]
test_images = image_list[157:]

mean_image = np.mean(train_images, axis=0) # get mean image

result_images = [] 
for img in train_images:
    subtracted_img = img - mean_image
    result_images.append(subtracted_img)
train_images = result_images # subtract mean image

u, s, vT = np.linalg.svd(train_images, full_matrices=False) # SVD


# 2A - Write the PCA codes to compute K = 30 eigenfaces and visualize the top 10 eigen-faces.
K = 30
eigenfaces = vT[:K] # 30 eigenfaces

fig_a = plt.figure(1) 
for i in range(10): # Top 10 eigenfaces
    eigenface_image = eigenfaces[i].reshape((256, 256))
    plt.subplot(2, 5, i + 1)
    plt.imshow(eigenface_image, cmap='gray')
    plt.title(f'Eigenface {i + 1}')
    plt.axis('off')  # Hide the axes
plt.tight_layout()
fig_a.show()


# 2B - Show 5 testing images and their reconstructed ones
reconstructed_faces = [np.dot(eigenfaces.T, np.dot(eigenfaces, img - mean_image)) + mean_image for img in test_images] # reconstruct faces as images
errors = [np.linalg.norm(reconstructed_face - test_image)**2 / len(test_images) for reconstructed_face, test_image in zip(reconstructed_faces, test_images)] # get reconstruction error

fig_b = plt.figure(2, figsize=(10, 5))
for i in range(5):
    plt.subplot(2, 5, i+1)
    plt.imshow(test_images[i].reshape(256, 256), cmap='gray')
    plt.title(f'Image {i + 1}')
    plt.axis('off') # First 5 images to display

for i in range(5):
    plt.subplot(2, 5, i+6)
    plt.imshow(reconstructed_faces[i].reshape(256, 256), cmap='gray')
    plt.title(f'Reconstructed {i + 1}')
    plt.axis('off') # Reconstructed 5 images from original

plt.tight_layout()
fig_b.show() # Displays the first 5 images and reconstructed 5 images


# 2C - Try different values of K, e.g., try K = 10, 30, 50, 100, 150..., and draw the curve to indicate the corresponding testing reconstruction errors. The x-axis of the curve can be different
# K values, and the y-axis can be testing reconstruction error defined in (2)
K_vals = [10, 30, 50, 100, 150]
errors = []
for K in K_vals:
    eigenfaces = vT[:K]
    reconstructed_faces = [np.dot(eigenfaces.T, np.dot(eigenfaces, img - mean_image)) + mean_image for img in test_images]
    error = np.mean([np.linalg.norm(reconstructed_face - test_image)**2 for reconstructed_face, test_image in zip(reconstructed_faces, test_images)])
    errors.append(error) # Reconstruction error of different values of K

fig_c = plt.figure(3)
plt.plot(K_vals, errors)
plt.xlabel('K')
plt.ylabel('Reconstruction Error')
plt.show()
