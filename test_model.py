import os

import cv2
import numpy as np

import matplotlib.image as mpimg
import matplotlib.pyplot as plt

from keras import models
from keras.preprocessing.image import ImageDataGenerator

nrows = 100
ncolumns = 100

def save_image(path, title = ''):
  name = path.split('/')[-1]
  plt.figure()
  img = mpimg.imread(path)
  plt.title(title)
  imgplot = plt.imshow(img)
  plt.savefig('output/'+ name)
  plt.close()

def process_image(list_images):
  """
  Returns two arrays:
    X is an array of resized images
    y is an array of labels

  """
  X = [] #images
  y = [] #labels

  for image in list_images:
    resized_img = cv2.resize(cv2.imread(image, cv2.IMREAD_GRAYSCALE), (nrows, ncolumns))
    X.append(resized_img)

    #Get labels
    if 'woman' in image:
      y.append(0)
    else:
      y.append(1)

  return X, y

def get_accuracy(list_images, model):
  X_test, y_test = process_image(list_images)
  X_test = np.reshape(np.array(X_test), (len(X_test),100,100,1))
  y_test = np.array(y_test)

  print("Shape of X_test " + str(X_test.shape))
  print("Shape of y_test " + str(y_test.shape))

  i = 0;

  error_w = 0.0
  correct_w = 0.0

  error_m = 0.0
  correct_m = 0.0

  test_datagen = ImageDataGenerator(rescale=1./255)

  for batch in test_datagen.flow(X_test, batch_size=1):
    pred = model.predict(batch)
    if pred >= 0.5:
      #save_image(test_images[i], 'This is a man')
      if y_test[i] == 1:
        correct_m += 1
      else:
        error_w += 1
    else:
      #save_image(test_images[i], 'This is a woman')
      if y_test[i] == 0:
        correct_w += 1
      else:
        error_m += 1
    i = i + 1

    if i >= len(X_test):
      break

  accuracy_m = correct_m / (error_m + correct_m)
  accuracy_w = correct_w / (error_w + correct_w)
  accuracy = (correct_w + correct_m) / len(X_test)

  print("Accuracy : " + str(accuracy))
  #print("Accuracy for man : " + str(accuracy_m))
  #print("Accuracy for woman : " + str(accuracy_w))

model = models.load_model('model_keras.h5')

test_images  = ['input/facedata/test/{}'.format(i) for i in os.listdir('input/facedata/test')]

print("Evaluating on test data")
get_accuracy(test_images, model)
