from classify import predict_wound_presence
from roboflow_inference import detect_wound_details

def process_image(image_path: str):
    has_wound = predict_wound_presence(image_path)

    if not has_wound:
        return {
            "has_wound": False,
            "message": "此圖片未偵測到傷口"
        }

    # 傳送至 Roboflow 偵測
    roboflow_result = detect_wound_details(image_path)
    return {
        "has_wound": True,
        "wound_info": roboflow_result
    }

# ✅ 測試
if __name__ == "__main__":
    result = process_image("tests/4.jpg")
    print(result)
