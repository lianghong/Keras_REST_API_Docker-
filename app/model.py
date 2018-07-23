
from keras.applications import ResNet50
#from keras.applications import inception_v3
from keras.preprocessing.image import img_to_array
from keras.applications import imagenet_utils
import numpy as np
import tensorflow as tf
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

model = ResNet50(include_top=True, weights='imagenet', input_tensor=None, input_shape=None, pooling=None, classes=1000)
graph = tf.get_default_graph()

#model.predict(np.zeros((1, 224, 224, 3)))
#model = inception_v3.InceptionV3(include_top=True, weights='imagenet', input_tensor=None, input_shape=None)

def prepare_image(image, target):
    # if the image mode is not RGB, convert it
    if image.mode != "RGB":
        image = image.convert("RGB")

    # resize the input image and preprocess it
    image = image.resize(target)
    image = img_to_array(image)
    image = np.expand_dims(image, axis=0)
    image = imagenet_utils.preprocess_input(image)
    return image


def predict(image):
    data = {"success": False}
    data["predictions"] = []
    input = prepare_image(image, target=(224,224))

    global graph
    with graph.as_default():
        preds = model.predict(input)
#    preds = model.predict(input)
    results = imagenet_utils.decode_predictions(preds,top=3)[0]

    for (imagenetID, label, prob) in results:
        r = {"label": label, "probability": float(prob)}
        data["predictions"].append(r)

    # indicate that the request was a success
    data["success"] = True
    return data

