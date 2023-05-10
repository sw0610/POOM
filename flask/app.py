from flask import Flask, request, jsonify, send_file
from keras.models import load_model
from PIL import Image
import os
import numpy as np

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = './env'
model = load_model('C:/Users/SSAFY/flask/env/dog_model3.h5')

@app.route("/exam")
def predict():
    if 'image' not in request.files:
        return 'No file uploaded', 400
    
    image_file = request.files['image']

    if image_file.filename == '':
        return 'Invalid file', 400
    
    image = Image.open(image_file).convert("RGB")

    resized_image = image.resize((512, 512))
    resized_image.save('/data/user/0/com.example.poom/cache/1db09bef-9d44-4610-b466-93d0de384aa0/resized_image.jpg')

    image.save(image_file, "JPEG")
    img = image.resize((128, 128))
    img = np.array(img) / 255.0
    img = np.expand_dims(img, axis=0)

    prediction = model.predict(img)
    print(prediction)

    accu = float(prediction[0][0]) * 100.0
    print("유사도 : ", accu)

    if accu >= 70.0:
        return send_file('/data/user/0/com.example.poom/cache/1db09bef-9d44-4610-b466-93d0de384aa0/resized_image.jpg', mimetype='image/jpeg')
    elif accu < 70.0:
        return '', 404

if __name__ == '__main__':
    from waitress import serve
    app.run()