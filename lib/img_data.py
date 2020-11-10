import numpy as np
import pandas as pd
import os
# import urllib
import matplotlib.pyplot as plt
import cv2
import matplotlib.patches as patches
# import tensorflow as tf
# import keras
# from keras.layers import Flatten, Dense, Conv2D, MaxPooling2D, Dropout
# from keras.models import Sequential
# import sklearn
# from sklearn.preprocessing import LabelEncoder
from mtcnn.mtcnn import MTCNN


ROOT_DIR = '/Users/brtonnies/ArtificialIntelligence/face-mask-detection'
DATA_DIR = os.path.join(ROOT_DIR, 'data')
IMAGES_DIR = os.path.join(DATA_DIR, 'images')
CMFD_IMAGES_DIR = os.path.join(IMAGES_DIR, 'CMFD/images')
IMFD_IMAGES_DIR = os.path.join(IMAGES_DIR, 'IMFD/images')
ANNOTATIONS_DIR = os.path.join(DATA_DIR, 'annotations')
OUTPUT_DIR = os.path.join(DATA_DIR, 'img_data')


image_formats = ['jpg', 'jpeg', 'png']
cmfd_images = [img for img in os.listdir(CMFD_IMAGES_DIR) if img.split(".")[-1] in image_formats]
imfd_images = [img for img in os.listdir(IMFD_IMAGES_DIR) if img.split(".")[-1] in image_formats]

# "_".join(i.split("_")[1:]).split(".")[0].lower()  # <-- gets a lowercase string for the way that a mask is worn incorrectly



def train():
    return pd.read_csv(os.path.join(DATA_DIR, 'train.csv'))


def submission():
    return pd.read_csv(os.path.join(DATA_DIR, 'submission.csv'))


def get_boxes(idx, data):
    boxes = []
    for i in data[data["name"] == str(idx)]['bbox']:
        boxes.append(i)

    return boxes


def get_images():
    image_formats = ['jpg', 'jpeg', 'png']
    return [img for img in os.listdir(IMAGES_DIR) if img.split(".")[-1] in image_formats]


def get_annotations():
    return os.listdir(ANNOTATIONS_DIR)


def training_set():
    return get_images()[1698:]


def testing_set():
    return get_images()[:1698]


def draw_face_bounds(img, bound_color=(0, 255, 0)):
    detector = MTCNN()
    image = plt.imread(os.path.join(IMAGES_DIR, img))
    faces = detector.detect_faces(image)
    # print(faces)
    bounds = []
    for (x, y, w, h) in [face['box'] for  face in faces]:
        bounding_box = cv2.rectangle(image, (x, y), (x+w, y+h), bound_color, 5)
        plt.imshow(bounding_box)
        bounds.append(bounding_box)

    return bounds


def add_bboxes(df):
    t = train()
    bboxes = list()
    for i in range(len(t)):

        arr = list()
        for j in t.iloc[i][['x1', 'x2', 'y1', 'y2']]:
            arr.append(j)

        bboxes.append(arr)

    df['bbox'] = bboxes
    return df


def main():
    mtcnn = MTCNN()
    # images = get_images()
    # annotations = get_annotations()
    # images.sort()
    # annotations.sort()

    # train_images = images[1698:]
    # test_images = images[:1698]

    # process and write the training set
    # train_df = add_bboxes(train())
    # print(os.path.join(DATA_DIR, 'img_data', 'kaggle_training.csv'))
    # train().to_csv(os.path.join(DATA_DIR, 'img_data', 'kaggle_training.csv'))

    # process and write the image data set to a file for easier access
    data = list()
    df = list()

    for image in cmfd_images:
        img = plt.imread(os.path.join(CMFD_IMAGES_DIR, image))
        print("Analyzing image '{}' (#{}/{})".format(
            image,
            cmfd_images.index(image)+1,
            len(cmfd_images)
        ))

        faces = mtcnn.detect_faces(img)
        if not faces:
            print("\tNo faces detected.")
        else:
            t = list()
            for face in faces:
                print("\tFinding bounds for {}/{} faces...".format(
                    faces.index(face)+1,
                    len(faces)
                ))
                bbox = face['box']
                data.append([image, bbox])
            df.append(t)

    data += [i for i in df if len(i) == 1]
    data += [[j for j in i] for i in df if len(i) > 1]

    # neg = list()
    # for i in data:
    #     for j in i[1]:
    #         if j < 0:
    #             neg.append(i)

    neg = [[j for j in i[1]] for i in data]

    # for image in test_images:
    #     img = plt.imread(os.path.join(IMAGES_DIR, image))
    #     faces = mtcnn.detect_faces(img)
    #
    #     t = list()
    #     for face in faces:
    #         bbox = face['box']
    #         t.append([image, bbox])
    #     test_df.append(t)
    #
    # test += [i for i in test_df if len(i) > 1]
    # test += [[j for j in i] for i in test_df if len(i) == 1]
    #
    # sub = [i[0] for i in test]
    # remaining_images = [image for image in test_images if image not in sub]
    #
    # rem_df = list()
    # for image in remaining_images:
    #     img = plt.imread(os.path.join(IMAGES_DIR, image))
    #     faces = mtcnn.detect_faces(img)
    #
    #     t = list()
    #     for face in faces:
    #         bbox = face['box']
    #         t.append([image, bbox])
    #     rem_df.append(t)
    #
    #     test += [i for i in rem_df if len(i) > 1]
    #     test += [[j for j in i] for i in rem_df if len(i) == 1]

    # print(data)

    dframe = pd.DataFrame(
        # data=data,
        # columns=['name', 'x1', 'x2', 'y1', 'y2', 'classname']
    )
    dframe['name'] = [i[0] for i in data]
    dframe['x1'] = [i[1][0] for i in data]
    dframe['x2'] = [i[1][1] for i in data]
    dframe['y1'] = [i[1][2] for i in data]
    dframe['y2'] = [i[1][3] for i in data]
    dframe['classname'] = ["face_mask_correct" for i in data]
    print(dframe)
    dframe.to_csv(os.path.join(DATA_DIR, 'img_data', 'cmfd_training.csv'))


main()


