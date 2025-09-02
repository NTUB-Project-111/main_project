const express = require('express');
const router = express.Router();
// const upload = require('../utils/upload');
const { upload, uploadToCloudinary } = require('../utils/upload');
const db = require('../config/db');

// // === STABILITY ===
// const axios = require('axios');
// const FormData = require('form-data');
// const STABILITY_API_KEY = process.env.STABILITY_API_KEY;

// === OpenAI DALL·E ===
const OpenAI = require('openai');
require('dotenv').config();
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// === Stable Diffusion (Modelslab) ===
// const USER_KEY = process.env.MODELSLAB_API_KEY || '你的Modelslab Key';
// const ENDPOINT_URL = 'https://modelslab.com/api/v7/images/text-to-image';


// //  === StableDiffusion ===
// router.post('/generateImage', async (req, res) => {
//   try {
//     const { advice } = req.body;
//     if (!advice) {
//       return res.status(400).json({ success: false, message: '缺少護理建議' });
//     }

//     const prompt = `medical illustration, wound care instruction: ${advice}, clear step-by-step, educational, minimal blood, clean design`;

//     const requestBody = {
//       prompt,
//       model_id: 'imagen-4',
//       aspect_ratio: '1:1',
//       key: USER_KEY
//     };

//     // Node 18+ 內建 fetch
//     const response = await fetch(ENDPOINT_URL, {
//       method: 'POST',
//       headers: {
//         'key': USER_KEY,
//         'Content-Type': 'application/json',
//       },
//       body: JSON.stringify(requestBody)
//     });

//     let result;
//     try {
//       result = await response.json();
//     } catch (e) {
//       const text = await response.text();
//       return res.status(500).json({
//         success: false,
//         message: '無法解析 Modelslab 回傳結果',
//         raw: text
//       });
//     }

//     // 檢查回傳是否有圖片
//     if (!result?.data?.[0]?.b64_json) {
//       return res.status(500).json({
//         success: false,
//         message: 'Modelslab 沒回傳圖片資料或發生錯誤',
//         raw: result
//       });
//     }

//     const b64 = result.data[0].b64_json;
//     const buffer = Buffer.from(b64, 'base64');

//     // 上傳到 Cloudinary
//     const cloudResult = await uploadToCloudinary(buffer, `wound_${Date.now()}`);
//     const imageUrl = cloudResult.secure_url;

//     res.json({ success: true, imageUrl });

//   } catch (err) {
//     console.error('Stable Diffusion 生成錯誤:', err);
//     res.status(500).json({
//       success: false,
//       message: '圖片生成失敗',
//       error: err.message
//     });
//   }
// });


// === 依據護理建議產生圖片OpenAI DALL·E ===
// router.post('/generateImage', async (req, res) => {
//   try {
//     const { advice } = req.body;
//     if (!advice) {
//       return res.status(400).json({ success: false, message: '缺少護理建議' });
//     }

//     const prompt = `medical illustration of wound care instruction:
//      ${advice}, single clear image (not split panels), educational style, 
//      minimal blood, clean medical design, no text, no captions`;

//     // 產生圖片
//     const result = await openai.images.generate({
//       model: 'gpt-image-1',
//       prompt: prompt,
//       size: '1024x1024',
//         quality: "low",
//       n: 1,
//     });

//     const b64 = result.data[0]?.b64_json;
//     if (!b64) {
//       return res.status(500).json({ success: false, message: 'OpenAI 沒回傳圖片資料', raw: result });
//     }

//     // 將 Base64 轉成 Buffer
//     const buffer = Buffer.from(b64, 'base64');

//     // 上傳到 Cloudinary，並取得網址
//     const cloudResult = await uploadToCloudinary(buffer, `wound_${Date.now()}`);
//     const imageUrl = cloudResult.secure_url;

//     res.json({
//       success: true,
//       imageUrl, // 這個就是可公開存取的圖片網址
//     });
//   } catch (err) {
//     console.error('圖片生成錯誤:', err);
//     res.status(500).json({
//       success: false,
//       message: '圖片生成失敗',
//       error: err.message,
//       raw: err
//     });
//   }
// });
router.post('/generateImages', async (req, res) => {
  try {
    const { advices } = req.body; // advices: ["洗手", "止血", "清潔傷口"]
    if (!advices || !Array.isArray(advices) || advices.length === 0) {
      return res.status(400).json({ success: false, message: '缺少護理步驟' });
    }
    const imageUrls = [];
    for (const advice of advices) {
      // 安全 prompt
      const prompt = `Educational medical illustration of a first aid or wound care step:
        ${advice}, clear, step-by-step instructional style, non-graphic, professional medical illustration, 
        bandaged or covered wound, minimal blood, fully clothed, no nudity, no text or captions, 
        simple clean background`;
      const result = await openai.images.generate({
        model: 'gpt-image-1',
        prompt: prompt,
        size: '1024x1024',
        quality: "low",
        n: 1,
      });
      const b64 = result.data[0]?.b64_json;
      if (!b64) continue; // 跳過沒有回傳的
      const buffer = Buffer.from(b64, 'base64');
      const cloudResult = await uploadToCloudinary(buffer, `wound_${Date.now()}`);
      imageUrls.push(cloudResult.secure_url);
    }
    if (imageUrls.length === 0) {
      return res.status(500).json({ success: false, message: '所有步驟圖片生成失敗' });
    }
    res.json({
      success: true,
      imageUrls,
    });
  } catch (err) {
    console.error('圖片生成錯誤:', err);
    res.status(500).json({
      success: false,
      message: '圖片生成失敗',
      error: err.message,
      raw: err
    });
  }
});



// // ==== 依據護理建議產生圖片 Stability ====
// router.post('/generateImage', async (req, res) => {
//   try {
//     const { advice } = req.body;
//     if (!advice) {
//       return res.status(400).json({ success: false, message: '缺少護理建議' });
//     }

//     const prompt = `medical illustration, wound care instruction: ${advice}, clear step-by-step, educational, minimal blood, clean design`;

//     // 使用 FormData
//     const form = new FormData();
//     form.append('prompt', prompt);
//     form.append('output_format', 'png'); // 可以改成 'webp'

//     // 呼叫 Stability AI v2beta
//     const response = await axios.post(
//       'https://api.stability.ai/v2beta/stable-image/generate/core',
//       form,
//       {
//         headers: {
//           ...form.getHeaders(),
//           'Authorization': `Bearer ${STABILITY_API_KEY}`,
//           'Accept': 'image/*',
//         },
//         responseType: 'arraybuffer', // 取得圖片二進位資料
//       }
//     );

//     const buffer = Buffer.from(response.data, 'binary');

//     // 上傳到 Cloudinary
//     const cloudResult = await uploadToCloudinary(buffer, `wound_${Date.now()}`);
//     const imageUrl = cloudResult.secure_url;

//     res.json({
//       success: true,
//       imageUrl,
//     });

//   } catch (err) {
//     console.error('圖片生成錯誤:', err.response?.data || err.message);
//     res.status(500).json({
//       success: false,
//       message: '圖片生成失敗',
//       error: err.response?.data || err.message,
//     });
//   }
// });


router.post('/addRecord', upload.single('photo'), async (req, res) => {
  try {
    const { fk_userid, date, type, oktime, caremode, ifcall, choosekind, recording, name } = req.body;
    if (!req.file) {
      return res.status(400).json({ error: '請提供圖片' });
    }
    // 上傳至 Cloudinary
    const cloudResult = await uploadToCloudinary(req.file.buffer, Date.now().toString());
    const photoUrl = cloudResult.secure_url;
    const [result] = await db.query(
      `
      INSERT INTO record 
      (fk_userid, date, photo, type, oktime, caremode, ifcall, choosekind, recording, name)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [fk_userid, date, photoUrl, type, oktime, caremode, ifcall, choosekind, recording, name]
    );
    const insertedId = result.insertId;
    return res.json({
      message: 'Record added successfully',
      id_record: insertedId,
      photoPath: photoUrl, // Cloudinary 圖片網址
    });
  } catch (err) {
    console.error('新增錯誤:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});


// === 取得使用者診斷報告 ===
router.get('/getRecords', async (req, res) => {
  const id = req.query.id;
  if (!id) return res.status(400).json({ error: 'id is required' });
  const userId = Number(id);
  if (isNaN(userId)) return res.status(400).json({ error: 'Invalid id format' });
  const query = `
    SELECT 
      id_record, fk_userid,
      DATE_FORMAT(date, '%Y-%m-%d') AS date,
      photo, type, oktime, caremode,
      ifcall, choosekind, recording, group_id, name
    FROM record
    WHERE fk_userid = ?
  `;
  try {
    const [results] = await db.query(query, [userId]);
    if (results.length === 0) {
      return res.status(404).json({ error: 'No records found' });
    }
    res.json({ records: results });
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database error' });
  }
});

//取得使用者的診斷報告與護理提醒
router.get('/getRecordRemind', async (req, res) => {
  const userId = req.query.id;

  if (!userId) {
    return res.status(400).json({ message: '缺少 id 參數' });
  }

  try {
    const [rows] = await db.query(`
            SELECT
                r.fk_userid,
                r.id_record AS reportId,
                DATE_FORMAT(r.date, '%Y-%m-%d') AS date,
                r.type,
                r.oktime,
                r.caremode,
                r.ifcall,
                r.choosekind,
                r.recording,
                r.photo,
                r.name
                r.group_id,
                c.fk_user_id,
                c.id_calls AS remindId,
                c.fk_record_id,
                c.time,
                c.day,
                c.freq
            FROM record r
            LEFT JOIN calls c ON r.id_record = c.fk_record_id
            WHERE r.fk_userid = ?
            ORDER BY r.id_record ASC, c.id_calls ASC;
        `, [userId]);

    // 整理成巢狀格式
    const reportMap = {};
    const reports = [];
    for (const row of rows) {
      if (!reportMap[row.reportId]) {
        reportMap[row.reportId] = {
          id: row.reportId,
          userId: row.fk_userid,
          date: row.date,
          type: row.type,
          oktime: row.oktime,
          caremode: row.caremode,
          ifcall: row.ifcall,
          choosekind: row.choosekind,
          recording: row.recording,
          name: row.name,
          photo: row.photo,
          group_id: row.group_id,
          reminds: [],
        };
        reports.push(reportMap[row.reportId]);
      }

      if (row.remindId) {
        reportMap[row.reportId].reminds.push({
          id: row.remindId,
          userId: row.fk_user_id,
          recordId: row.fk_record_id,
          date: row.day,
          time: row.time,
          freq: row.freq,
        });
      }
    }

    res.json({ reports });
  } catch (err) {
    console.error('資料取得錯誤:', err);
    res.status(500).json({ message: '伺服器錯誤' });
  }
});

//取得groupId
router.get('/getGroup', async (req, res) => {
  const userId = req.query.userId;
  try {
    const [rows] = await db.query(
      'SELECT DISTINCT r.group_id FROM record r WHERE r.fk_userid = ?',
      [userId]
    );
    res.status(200).json({
      success: true,
      data: rows.map(row => row.group_id),
    });
  } catch (error) {
    console.error('查詢 group_id 失敗：', error);
    res.status(500).json({ success: false, message: '伺服器錯誤' });
  }
});

//取得groupId
router.get('/getGroupId', async (req, res) => {
  const userId = req.query.userId;
  const recordId = req.query.recordId;

  if (!userId || !recordId) {
    return res.status(400).json({ success: false, message: '缺少 userId 或 recordId' });
  }

  try {
    const [rows] = await db.query(
      'SELECT r.group_id FROM record r WHERE r.fk_userid = ? AND r.id_record = ?',
      [userId, recordId]
    );

    if (rows.length > 0) {
      res.status(200).json({
        success: true,
        groupId: rows[0].group_id,
      });
    } else {
      res.status(404).json({ success: false, message: '找不到符合條件的紀錄' });
    }
  } catch (error) {
    console.error('查詢 group_id 失敗：', error);
    res.status(500).json({ success: false, message: '伺服器錯誤' });
  }
});

//更新癒合時間
router.post('/updateOktime', async (req, res) => {
  const { userId, recordId, groupId, oktime } = req.body;
  if (!userId || !oktime) {
    return res.status(400).json({ success: false, message: '缺少必要參數 (userId 或 oktime)' });
  }
  try {
    let result;
    if (groupId) {
      // 若有傳 groupId：用 userId + groupId 為條件
      [result] = await db.query(
        'UPDATE record SET oktime = ? WHERE fk_userid = ? AND group_id = ?',
        [oktime, userId, groupId]
      );
    } else {
      // 未傳 groupId：必須傳 recordId
      if (!recordId) {
        return res.status(400).json({ success: false, message: '未傳入 groupId 時，recordId 為必要參數' });
      }
      [result] = await db.query(
        'UPDATE record SET oktime = ? WHERE fk_userid = ? AND id_record = ?',
        [oktime, userId, recordId]
      );
    }
    if (result.affectedRows > 0) {
      res.status(200).json({ success: true });
    } else {
      res.status(404).json({ success: false, message: '找不到符合條件的紀錄' });
    }
  } catch (error) {
    console.error('更新 oktime 失敗：', error);
    res.status(500).json({ success: false, message: '伺服器錯誤' });
  }
});


module.exports = router;