from openai import api_key
from roboflow import Roboflow
import cv2
from dotenv import load_dotenv

# 載入 .env 檔案
load_dotenv()

# 使用 API 金鑰
rf = Roboflow(api_key=api_key)
project = rf.workspace().project("wound-ebsdw")
model = project.version(10).model

# 設定圖片路徑
image_path = "test-imgs/burn.jpeg"
output_path = "prediction/prediction-img4.jpg"

# 讀取原始圖片
image = cv2.imread(image_path)

# 調整圖片大小至 640x640
image_resized = cv2.resize(image, (640, 640))

# 暫存調整大小後的圖片
temp_path = "resized/resized_img.jpg"
cv2.imwrite(temp_path, image_resized)

# 進行預測 (使用已調整大小的圖片)
prediction = model.predict(temp_path, confidence=50, overlap=50).json()

# 在圖片上繪製預測結果
for obj in prediction["predictions"]:
    x, y, width, height = int(obj["x"]), int(obj["y"]), int(obj["width"]), int(obj["height"])
    class_name = obj["class"]
    confidence = obj["confidence"] * 100  # 轉換為百分比
    
    # 計算邊界框的座標
    x1, y1, x2, y2 = x - width // 2, y - height // 2, x + width // 2, y + height // 2

    # 繪製矩形框 (綠色, 厚度2)
    cv2.rectangle(image_resized, (x1, y1), (x2, y2), (0, 255, 0), 2)

    # 標籤文字 (類別 + 置信度)
    label = f"{class_name}: {confidence:.1f}%"
    cv2.putText(image_resized, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

# 儲存帶標籤的圖片
cv2.imwrite(output_path, image_resized)

print(f"預測結果已儲存為 {output_path}")
