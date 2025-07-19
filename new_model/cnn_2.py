import os
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import layers, models, callbacks
from tensorflow.keras.optimizers import Adam

from sklearn.metrics import classification_report, confusion_matrix
import numpy as np

import matplotlib.pyplot as plt

# 設定圖片的尺寸為 224x224，這通常是常見 CNN 模型（如 VGG、MobileNet、EfficientNet）的輸入大小
img_size = (299, 299)

# 每次訓練的批次大小（一次送幾張圖片進模型訓練）
batch_size = 32

# 建立一個訓練用的圖像資料生成器，會自動幫圖片進行增強處理（Data Augmentation）
train_datagen = ImageDataGenerator(
    rescale=1./255,            # 將像素值從 [0, 255] 縮放到 [0, 1]，有助於訓練穩定
    validation_split=0.2,      # 從資料集中切出 20% 作為驗證集
    horizontal_flip=True,      # 隨機水平翻轉圖片，提高模型泛化能力
    zoom_range=0.2,            # 隨機對圖片進行 0~20% 的縮放
    rotation_range=20          # 隨機將圖片旋轉 -20 到 +20 度
)

# 建立訓練集資料生成器
train_generator = train_datagen.flow_from_directory(
    'dataset/',                # 指定資料集資料夾，子資料夾的名稱會自動視為分類標籤
    target_size=img_size,      # 將所有圖片調整為指定大小
    batch_size=batch_size,     # 每個批次的圖片數量
    class_mode='binary',       # 使用二元分類模式（0 和 1），適用於是否為傷口的分類任務
    subset='training'          # 使用上面設定的 80% 資料作為訓練集
)

# 建立驗證集資料生成器
val_generator = train_datagen.flow_from_directory(
    'dataset/',                # 同樣使用相同的資料來源資料夾
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary',       # 與訓練集一致的分類模式
    subset='validation'        # 使用上面設定的 20% 資料作為驗證集
)

# CNN 模型設計
def build_model():
    model = models.Sequential([
        layers.Conv2D(32, (3, 3), activation='relu', input_shape=(299, 299, 3)),
        layers.MaxPooling2D(2, 2),
        
        layers.Conv2D(64, (3, 3), activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(128, (3, 3), activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Flatten(),
        layers.Dense(128, activation='relu'),
        layers.Dropout(0.5),
        layers.Dense(1, activation='sigmoid')  # binary classification
    ])
    
    model.compile(optimizer=Adam(learning_rate=1e-5),
                  loss='binary_crossentropy',
                  metrics=['accuracy'])
    return model

model = build_model()

# 回呼函數：提早停止與保存最佳模型
early_stop = callbacks.EarlyStopping(monitor='val_loss', patience=6, restore_best_weights=True)
checkpoint = callbacks.ModelCheckpoint("models/bests/best_model-2.h5", monitor='val_loss', save_best_only=True)

#根據 val_loss 自動調整學習率
reduce_lr = callbacks.ReduceLROnPlateau(
    monitor='val_loss',
    factor=0.5,         # 每次降低一半
    patience=3,         # 如果 3 次 epoch val_loss 沒改善，就降低
    verbose=1,
    min_lr=1e-6         # 最低學習率限制
)

# 訓練模型
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=50,
    callbacks=[early_stop, checkpoint, reduce_lr]
)

val_generator.reset()
Y_pred = model.predict(val_generator)
y_pred = (Y_pred > 0.5).astype(int)

# 儲存模型
model.save("models/finals/final_model-2.h5")

# 評估模型
loss, acc = model.evaluate(val_generator)
print(f"模型驗證準確率：{acc:.4f}")
print("分類報告：")
print(classification_report(val_generator.classes, y_pred))

plt.plot(history.history['val_loss'], label='Validation Loss')
plt.plot(history.history['loss'], label='Training Loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend()
plt.title('Training vs Validation Loss')
plt.grid(True)
plt.show()