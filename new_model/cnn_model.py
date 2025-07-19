# import os
# import numpy as np
# import matplotlib.pyplot as plt
# from sklearn.metrics import classification_report
# import tensorflow as tf
# from tensorflow.keras.models import Model
# from tensorflow.keras.layers import Dense, Dropout, GlobalAveragePooling2D
# from tensorflow.keras.applications import MobileNetV2
# from tensorflow.keras.preprocessing.image import ImageDataGenerator
# from tensorflow.keras import callbacks
# from tensorflow.keras.optimizers import Adam
# from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

# # 設定資料目錄
# train_dir = 'dataset/train'
# val_dir = 'dataset/val'
# img_size = (224, 224)
# batch_size = 32
# epochs = 50
# model_path = 'wound_classifier_best.h5'

# # 資料擴增
# train_datagen = ImageDataGenerator(
#     rescale=1./255,
#     rotation_range=15,
#     zoom_range=0.2,
#     width_shift_range=0.1,
#     height_shift_range=0.1,
#     horizontal_flip=True
# )

# val_datagen = ImageDataGenerator(rescale=1./255)

# train_generator = train_datagen.flow_from_directory(
#     train_dir,
#     target_size=img_size,
#     batch_size=batch_size,
#     class_mode='binary'
# )

# val_generator = val_datagen.flow_from_directory(
#     val_dir,
#     target_size=img_size,
#     batch_size=batch_size,
#     class_mode='binary'
# )

# # MobileNetV2 特徵提取
# base_model = MobileNetV2(include_top=False, input_shape=(224, 224, 3), weights='imagenet')
# base_model.trainable = False

# x = base_model.output
# x = GlobalAveragePooling2D()(x)
# x = Dropout(0.3)(x)
# x = Dense(128, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(0.001))(x)
# x = Dropout(0.3)(x)
# predictions = Dense(1, activation='sigmoid')(x)

# model = Model(inputs=base_model.input, outputs=predictions)

# model.compile(optimizer=Adam(learning_rate=1e-4),
#               loss='binary_crossentropy',
#               metrics=['accuracy'])

# # Callbacks
# early_stopping = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)
# model_checkpoint = ModelCheckpoint(model_path, monitor='val_loss', save_best_only=True)
# checkpoint = callbacks.ModelCheckpoint("models/bests/best_model-2.h5", monitor='val_loss', save_best_only=True)

# # 模型訓練
# history = model.fit(
#     train_generator,
#     validation_data=val_generator,
#     epochs=epochs,
#     callbacks=[early_stopping, model_checkpoint]
# )

# # 評估
# val_loss, val_acc = model.evaluate(val_generator)
# print(f"Validation Accuracy: {val_acc:.4f}")

# # 輸出分類報告
# val_generator.reset()
# preds = model.predict(val_generator, verbose=1)
# y_pred = np.where(preds > 0.5, 1, 0)
# y_true = val_generator.classes

# print(classification_report(y_true, y_pred, target_names=val_generator.class_indices.keys()))


import os
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import classification_report
import tensorflow as tf
from tensorflow.keras.models import Model, load_model
from tensorflow.keras.layers import Dense, Dropout, GlobalAveragePooling2D
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import callbacks
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

# 設定資料目錄與參數
train_dir = 'dataset/train'
val_dir = 'dataset/val'
img_size = (224, 224)
batch_size = 32
epochs = 50
best_model_path = 'models/bests/best_model-3.h5'
final_model_path = 'models/finals/final_model-3.h5'

# 資料擴增
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=15,
    zoom_range=0.2,
    width_shift_range=0.1,
    height_shift_range=0.1,
    horizontal_flip=True
)

val_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary'
)

val_generator = val_datagen.flow_from_directory(
    val_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary'
)

# MobileNetV2 模型
base_model = MobileNetV2(include_top=False, input_shape=(224, 224, 3), weights='imagenet')
base_model.trainable = False

x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dropout(0.3)(x)
x = Dense(128, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(0.001))(x)
x = Dropout(0.3)(x)
predictions = Dense(1, activation='sigmoid')(x)

model = Model(inputs=base_model.input, outputs=predictions)

model.compile(optimizer=Adam(learning_rate=1e-4),
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Callbacks
early_stopping = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)
model_checkpoint = ModelCheckpoint(best_model_path, monitor='val_loss', save_best_only=True)

# 模型訓練
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=epochs,
    callbacks=[early_stopping, model_checkpoint]
)

# 儲存最終訓練完成後的模型
model.save(final_model_path)

# 評估最佳模型
best_model = load_model(best_model_path)
val_generator.reset()
best_loss, best_acc = best_model.evaluate(val_generator, verbose=0)
print(f"✅ Best Model Accuracy (val_loss minimum): {best_acc:.4f}")

# 評估最終模型
final_model = load_model(final_model_path)
val_generator.reset()
final_loss, final_acc = final_model.evaluate(val_generator, verbose=0)
print(f"✅ Final Trained Model Accuracy (last epoch): {final_acc:.4f}")

# 輸出分類報告（使用最終模型）
val_generator.reset()
preds = final_model.predict(val_generator, verbose=1)
y_pred = np.where(preds > 0.5, 1, 0)
y_true = val_generator.classes

print("\n📊 Classification Report (Final Model):")
print(classification_report(y_true, y_pred, target_names=val_generator.class_indices.keys()))
