# coding: utf-8

import flask
from PIL import Image
import io
#import logging
import model

app = flask.Flask(__name__)

def errorRequest():
    app.logger.error('Bad request from client')
    return {
        'status': 400,
        'message': 'Bad request'
    }

# initialize our Flask application and the Keras model


@app.route("/predict", methods=["POST"])
def predict():
    # ensure an image was properly uploaded to our endpoint
    if flask.request.method == "POST":
        if flask.request.files.get("image"):
            # read the image in PIL format
            image = flask.request.files["image"].read()
            image = Image.open(io.BytesIO(image))
            prediction = model.predict(image)
        else:
            prediction = errorRequest()
    else:
        prediction = errorRequest()

    return flask.jsonify(prediction)


if __name__ == "__main__":
    #app.run(debug=True)
    app.run(debug=False)

