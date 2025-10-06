import requests
import json
from PIL import Image
import os

# 你可以用 dotenv 管理 API_KEY
API_KEY = "你的_YOLO_API_KEY"
MODEL_URL = f"https://detect.roboflow.com/wound-ebsdw/10?api_key={API_KEY}"

# 傷口類型對應表
wound_map = {
    'Abrasions': '擦傷',
    'Bruise': '瘀青',
    'Burn': '燒傷',
    'Cut': '割傷',
    '無異常': '無異常'
}


def analyze_wound(image_path: str) -> str:
    try:
        # 讀取並調整圖片尺寸
        image = Image.open(image_path).convert("RGB")
        image = image.resize((640, 640))
        temp_path = "resized_image.jpg"
        image.save(temp_path)

        # 發送 multipart 請求
        with open(temp_path, "rb") as img_file:
            files = {
                "file": img_file
            }
            data = {
                "confidence": "50",
                "overlap": "50"
            }
            response = requests.post(MODEL_URL, files=files, data=data)

        os.remove(temp_path)

        if response.status_code != 200:
            raise Exception(f"API 請求失敗: {response.status_code}")

        results = response.json()
        detected = {pred["class"] for pred in results.get("predictions", []) if "class" in pred}

        wound_type = next(iter(detected), "無異常")
        return wound_map.get(wound_type, "無異常")

    except Exception as e:
        print(f"錯誤: {e}")
        return "分析失敗"

if __name__ == "__main__":
    image_path = "tests/4.jpg"  # ✅ 替換成你要測試的圖片
    result = analyze_wound(image_path)
    print("偵測結果：", result)