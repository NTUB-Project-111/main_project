#!/usr/bin/env python
# img_augment.py
# 用法：
#   python img_augment.py path/to/input.jpg -o out_dir -n 20

import argparse
import os
import numpy as np
from tensorflow.keras.preprocessing.image import (
    ImageDataGenerator,
    load_img,
    img_to_array,
)

def augment_image(img_path: str, out_dir: str, n: int = 10) -> None:
    """將單張影像進行資料擴增，並把結果存到 out_dir。"""
    os.makedirs(out_dir, exist_ok=True)

    # 讀圖 → Numpy 陣列 → (1, H, W, C)
    pil_img = load_img(img_path)                # 讀成 PIL 影像
    x = img_to_array(pil_img)                   # (H, W, C)
    x = np.expand_dims(x, axis=0)               # (1, H, W, C)

    # 建立擴增器
    datagen = ImageDataGenerator(
        rotation_range=40,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode="nearest",
    )

    # 產生並寫檔
    prefix = os.path.splitext(os.path.basename(img_path))[0]
    counter = 0
    for batch in datagen.flow(
        x,
        batch_size=1,
        save_to_dir=out_dir,
        save_prefix=prefix,
        save_format="jpg",
    ):
        counter += 1
        if counter >= n:  # 產生 n 張就停
            break
    print(f"✔ 已在「{out_dir}」產生 {counter} 張擴增影像")

def main():
    parser = argparse.ArgumentParser(description="單圖影像資料擴增工具")
    parser.add_argument("image", help="輸入影像路徑（jpg/png 皆可）")
    parser.add_argument(
        "-o", "--output", default="augmented", help="輸出資料夾（預設 augmented）"
    )
    parser.add_argument(
        "-n", "--number", type=int, default=10, help="要產生幾張擴增影像（預設 10）"
    )
    args = parser.parse_args()
    augment_image(args.image, args.output, args.number)

if __name__ == "__main__":
    main()
