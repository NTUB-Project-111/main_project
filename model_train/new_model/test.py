import tensorflow as tf
from tensorflow.keras.preprocessing import image
import numpy as np

# 載入模型
model = tf.keras.models.load_model('models/bests/best_model.h5')

# 預測單張圖片
def predict_image(img_path):
    img = image.load_img(img_path, target_size=(224, 224))
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    prediction = model.predict(img_array)[0][0]

    if prediction >= 0.7:
        print(f"圖片：{img_path} → 判斷結果：有傷口 ({prediction:.2f})")
    else:
        print(f"圖片：{img_path} → 判斷結果：無傷口 ({prediction:.2f})")

# 使用範例
predict_image('test_dataset/4.jpg')

