#For for file, this article was used as reference and tutorial
#https://towardsdatascience.com/image-detection-from-scratch-in-keras-f314872006c9
#For the training data, a pre made csv dataset was used 
#http://datax.kennesaw.edu/imdb_wiki/

import cv2
import os
import random

import matplotlib.image as mpimg
import matplotlib.pyplot as plt

import numpy as np
from sklearn.model_selection import train_test_split

from keras import layers
from keras import models
from keras import optimizers
from keras.preprocessing.image import ImageDataGenerator
from keras.preprocessing.image import img_to_array, load_img

#Image dimensions
nrows = 100
ncolumns = 100
channels = 1

BATCH_SIZE = 32
EPOCHS = 64

def show_image(path):
  img = mpimg.imread(path)
  imgplot = plt.imshow(img)
  plt.show()

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

train_imgs = ['input/facedata/train/{}'.format(i) for i in os.listdir('input/facedata/train')]
random.shuffle(train_imgs)

X, y = process_image(train_imgs)

X = np.reshape(np.array(X), (len(X),100,100,1))
y = np.array(y)

X_train, X_val, y_train, y_val = train_test_split(X, y, test_size = 0.20, random_state = 2)

print("Shape of X_train " + str(X_train.shape))
print("Shape of y_train " + str(y_train.shape))

ntrain = len(X_train)
nval = len(X_val)

# Create a simple VGGnet architechture
model = models.Sequential()
model.add(layers.Conv2D(32, (3, 3), activation = 'relu', input_shape = (100, 100, 1)))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Conv2D(64, (3, 3), activation = 'relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Conv2D(128, (3, 3), activation = 'relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Conv2D(128, (3, 3), activation = 'relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Flatten())
model.add(layers.Dropout(0.5))
model.add(layers.Dense(512, activation='relu'))
model.add(layers.Dense(1, activation='sigmoid'))
model.compile(loss = 'binary_crossentropy', optimizer = optimizers.RMSprop(lr=1e-4), metrics=['accuracy'])

model.summary()
train_datagen = ImageDataGenerator(rescale=1./255,
                                   rotation_range=40,
                                   width_shift_range=0.2,
                                   height_shift_range=0.2,
                                   shear_range=0.2,
                                   zoom_range=0.2,
                                   horizontal_flip=True,)
val_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow(X_train, y_train, batch_size=BATCH_SIZE)
val_generator = val_datagen.flow(X_val, y_val, batch_size=BATCH_SIZE)

history = model.fit_generator(train_generator,
                              steps_per_epoch=ntrain//BATCH_SIZE,
                              epochs=EPOCHS,
                              validation_data=val_generator,
                              validation_steps=nval//BATCH_SIZE)
#Save the model
model.save('model_keras.h5')

#Plot training accuracy and loss
acc = history.history['accuracy']
val_acc = history.history['val_accuracy']
loss = history.history['loss']
val_loss = history.history['val_loss']

epochs = range(1, len(acc) + 1)
plt.plot(epochs, acc, 'b', label='Training accuracy')
plt.plot(epochs, val_acc, 'r', label='Validation accuracy')
plt.title('Training and Validation accuracy')
plt.legend()
plt.savefig('fit_accuracy.png')
plt.figure()

plt.plot(epochs, loss, 'b', label='Training loss')
plt.plot(epochs, val_loss, 'r', label='Validation loss')
plt.title('Training and Validation loss')
plt.legend()
plt.savefig('fit_loss.png')


###################################################################################################################