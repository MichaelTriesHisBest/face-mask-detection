import os
import urllib
import cv2
import numpy as np
import matplotlib.pyplot as plt

KAGGLE_IMAGES_GIT = "https://github.com/brtonnies/face-mask-detection/blob/main/data/images"
CMFD_DIR_GIT = "https://github.com/brtonnies/face-mask-detection/blob/main/data/images/CMFD/images"
IMFD_DIR_GIT = "https://github.com/brtonnies/face-mask-detection/blob/main/data/images/IMFD/images"


def url_to_image(name, options=None):
    url = os.path.join(KAGGLE_IMAGES_GIT, "{}?raw=true".format(name))
    resp = urllib.request.urlopen(url)

    print(options)

    if options is not None and len(options.keys()) > 0:
        if 'lib' in options.keys() and options['lib'] == 'cv2':
            image = np.asarray(bytearray(resp.read()), dtype="uint8")
            image = cv2.imdecode(image, cv2.IMREAD_COLOR)
        elif 'format' in options.keys() and options['format'] is not None:
            image = plt.imread(resp, format=options['format'])
        else:
            image = plt.imread(url)
    else:
        image = plt.imread(url)

    return image
