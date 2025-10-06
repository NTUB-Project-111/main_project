# 📄 Image Data Augmentation CLI

> **一鍵將單張影像擴增為多張多樣化圖片**

這是針對 *專題專案*（傷口護理系統）所撰寫的 **Python CLI 工具**，
利用 `TensorFlow‑Keras + Pillow + SciPy` 內建的 `ImageDataGenerator`，
快速對單張影像進行隨機旋轉、平移、縮放、剪切、翻轉等變形，
在原地產生多張擴增圖，協助強化模型訓練資料、降低過度擬合風險。

---

## ✨ 特色

| 功能                | 說明                                                      |
| ----------------- | ------------------------------------------------------- |
| **單指令產生 N 張擴增影像** | `python img_augment.py <input>` → 輸出到指定資料夾              |
| **預設安全參數**        | 旋轉 ±40°、平移 20%、縮放 20%、水平翻轉、缺失像素以 *nearest* 補值           |
| **自動命名**          | 產生檔名如 `dog_0_1234.jpg`，方便後續批量載入                         |
| **零依賴外部標籤檔**      | 只需一張圖片即可使用，無需額外 JSON/CSV                                |
| **可嵌入任意工作流程**     | CLI 模式易整合於 shell script / VS Code Task / GitHub Actions |

---

## 🖥️ 系統需求

* **作業系統**：Windows 10/11、macOS 12+、Ubuntu 20.04+（x86‑64）
* **Python**：3.11 或 3.12（64‑bit）
* **套件**：

  * `tensorflow‑cpu >= 2.16` 　（或 `tensorflow` GPU 版）
  * `Pillow >= 10.0`
  * `scipy >= 1.11`

> ⚠️ TensorFlow 目前尚未支援 Python 3.13+，請使用 3.11/3.12。

---

## 🔧 安裝步驟

```powershell
# 1. 下載／Clone 專案
> git clone https://github.com/<your‑org>/image‑data‑augmentation.git
> cd image‑data‑augmentation

# 2. 建立並啟用虛擬環境（Windows 範例）
> py -3.11 -m venv venv
> .\venv\Scripts\activate

# 3. 安裝依賴
(venv) > python -m pip install --upgrade pip setuptools wheel
(venv) > pip install tensorflow‑cpu Pillow scipy
```

macOS/Linux 改為：

```bash
python3.11 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install tensorflow-cpu Pillow scipy
```

---

## ⚡ 快速開始

```bash
# 產生 20 張擴增圖到 ./aug_out
python img_augment.py "dog.jpg" -o aug_out -n 20
```

輸出範例：

```
✔ 已在「aug_out」產生 20 張擴增影像
```

---

## 🛠️ CLI 參數

| 參數               | 預設          | 說明                 |
| ---------------- | ----------- | ------------------ |
| `image`          | *必填*        | 單張輸入影像（jpg/png 皆可） |
| `-o`, `--output` | `augmented` | 輸出資料夾名稱            |
| `-n`, `--number` | `10`        | 要產生的擴增張數           |

### 進階自訂（修改程式碼）

若想調整變形強度，請編輯 `img_augment.py` 中的 `ImageDataGenerator` 參數，例如：

```python
datagen = ImageDataGenerator(
    rotation_range=15,           # 調小旋轉角度
    shear_range=0.0,            # 關閉剪切
    brightness_range=(0.8,1.2), # 加入亮度抖動
)
```

---


---

## ❓ 常見問題 (FAQ)

| 問題                                             | 解決方式                                      |
| ---------------------------------------------- | ----------------------------------------- |
| `ModuleNotFoundError: No module named 'scipy'` | `pip install scipy`，或確認已啟用 venv           |
| `ImportError: Could not import PIL.Image`      | `pip install Pillow`                      |
| TensorFlow 顯示 oneDNN OPTS 訊息                   | 純提示，可忽略；如要關閉：`set TF_CPP_MIN_LOG_LEVEL=2` |
| Python 3.13 裝不了 TF                             | 降版至 3.11/3.12 或等官方支援                      |

---
