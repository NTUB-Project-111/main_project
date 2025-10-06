from tensorflow.keras.preprocessing.image import ImageDataGenerator

# 設定圖片的尺寸為 224x224，這通常是常見 CNN 模型（如 VGG、MobileNet、EfficientNet）的輸入大小
img_size = (640, 640)

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
