import os
from dotenv import load_dotenv
import requests
import json
import cv2
import numpy as np

# 載入 .env 檔案
load_dotenv()

# API 設置
url = "https://predict.ultralytics.com"
api_key = os.getenv("ULTRALYTICS_API_KEY")  # 讀取環境變數中的 API Key
# if not api_key:
#     raise ValueError("API Key 未設定，請確認 .env 檔案是否正確！")
headers = {"x-api-key": api_key}
data = {"model": "https://hub.ultralytics.com/models/AJ6ZNdobu3ogKz9Xcybz", "imgsz": 640, "conf": 0.5, "iou": 0.5}

# 圖片路徑
image_path = "test-imgs/bruises.jpg"
output_path = "prediction/prediction-img.jpg"

# 讀取圖片
image = cv2.imread(image_path)
if image is None:
    raise ValueError(f"無法讀取圖片: {image_path}")

# 調整圖片大小至 640x640
image_resized = cv2.resize(image, (640, 640))

# 暫存調整大小後的圖片
temp_path = "resized/resized_img.jpg"
cv2.imwrite(temp_path, image_resized)
print(f"Uploading image: {temp_path}")

# 發送請求
with open(temp_path, "rb") as f:
    response = requests.post(url, headers=headers, data=data, files={"file": f})

# 檢查請求狀態
response.raise_for_status()
results = response.json()

# 印出 API 回傳內容
print(json.dumps(results, indent=2))  

# # 確保 "images" 和 "results" 存在
# if "images" not in results or not results["images"]:
#     raise KeyError("API 回傳內容中沒有 'images'，請檢查 API 回應！")

# if "results" not in results["images"][0]:
#     raise KeyError("API 回傳內容中沒有 'results'，請檢查 API 回應！")

# 繪製預測結果
for obj in results["images"][0]["results"]:  # 修正提取預測結果的位置
    if "box" not in obj:
        raise KeyError("API 回傳內容中沒有 'box'，請檢查 API 回應！")

    # 提取座標
    x1, y1 = int(obj["box"]["x1"]), int(obj["box"]["y1"])
    x2, y2 = int(obj["box"]["x2"]), int(obj["box"]["y2"])
    
    class_name = obj["name"]  # 修正名稱取得方式
    confidence = obj["confidence"] * 100  # 轉換為百分比

    # 繪製矩形框 (綠色, 厚度2)
    cv2.rectangle(image_resized, (x1, y1), (x2, y2), (0, 255, 0), 2)

    # 標籤文字 (類別 + 置信度)
    label = f"{class_name}: {confidence:.1f}%"
    cv2.putText(image_resized, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

# 儲存帶標籤的圖片
cv2.imwrite(output_path, image_resized)
print(f"預測結果已儲存為 {output_path}")
