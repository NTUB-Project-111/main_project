from tensorflow.keras.models import load_model
import numpy as np
import cv2

model = load_model("wound_detection/cnn_model.h5")
IMG_SIZE = 224

def predict_wound_presence(image_path: str) -> bool:
    img = cv2.imread(image_path)
    img = cv2.resize(img, (IMG_SIZE, IMG_SIZE))
    img = img.astype("float32") / 255.0
    img = np.expand_dims(img, axis=0)

    prediction = model.predict(img)[0][0]
    return prediction >= 0.6  # True 表示有傷口
