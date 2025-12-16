const express = require('express');
const router = express.Router();
const { upload, uploadToCloudinary } = require('../utils/upload');
const db = require('../config/db');

// === OpenAI DALL·E ===
const OpenAI = require('openai');
require('dotenv').config();
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });


// === 依據護理建議產生圖片OpenAI DALL·E ===
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

// === 新增診斷報告 ===
router.post('/addRecord', upload.single('photo'), async (req, res) => {
  try {
    // 首先會先將請求端傳入的參數存入變數中
    const { fk_userid, date, type, oktime, caremode, ifcall, choosekind, recording, name, member_id } = req.body;

    // 檢查是否有收到圖片檔案，若沒有則回傳錯誤
    if (!req.file) {
      return res.status(400).json({ error: '請提供圖片' });
    }

    // 將圖片上傳至 Cloudinary，檔名以時間戳記命名
    const cloudResult = await uploadToCloudinary(req.file.buffer, Date.now().toString());

    // 取得 Cloudinary 回傳的圖片網址
    const photoUrl = cloudResult.secure_url;

    // 將新紀錄插入資料庫的 record 資料表
    const [result] = await db.query(
      `
      INSERT INTO record 
      (fk_userid, date, photo, type, oktime, caremode, ifcall, choosekind, recording, name, member_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [fk_userid, date, photoUrl, type, oktime, caremode, ifcall, choosekind, recording, name, member_id]
    );

    // result取得剛插入診斷報告 ID
    const insertedId = result.insertId;

    // 新增成功時印出成功訊息
    console.log(`新增診斷報告成功，ID: ${insertedId}, UserID: ${fk_userid}`);
    // 回傳成功訊息，包含新診斷報告的 ID 及圖片網址
    return res.json({
      message: 'Record added successfully',
      id_record: insertedId,
      photoPath: photoUrl, // Cloudinary 圖片網址
    });
  } catch (err) {
    // 錯誤處理：印出錯誤訊息並回傳錯誤
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
      ifcall, choosekind, recording, group_id, name, member_id
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
        r.id_record,
        DATE_FORMAT(r.date, '%Y-%m-%d') AS date,
        r.type,
        r.oktime,
        r.caremode,
        r.ifcall,
        r.choosekind,
        r.recording,
        r.photo,
        r.name,
        r.group_id,
        r.member_id AS record_member_id,
        c.fk_user_id,
        c.id_calls,
        c.fk_record_id,
        c.time,
        c.day,
        c.freq,
        c.member_id AS call_member_id
      FROM record r
      LEFT JOIN calls c ON r.id_record = c.fk_record_id
      WHERE r.fk_userid = ?
      ORDER BY r.id_record ASC, c.id_calls ASC;
    `, [userId]);

    const reportMap = {};
    const reports = [];

    for (const row of rows) {

      if (!reportMap[row.id_record]) {
        reportMap[row.id_record] = {
          id_record: row.id_record,
          fk_userid: row.fk_userid,
          member_id: row.record_member_id,
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

        reports.push(reportMap[row.id_record]);
      }

      if (row.id_calls != null) {
        reportMap[row.id_record].reminds.push({
          id_calls: row.id_calls,
          fk_user_id: row.fk_user_id,
          fk_record_id: row.fk_record_id,
          day: row.day,
          time: row.time,
          freq: row.freq,
          member_id: row.call_member_id,
        });
      }
    }

    res.json({ reports }); // <-- 正確位置

  } catch (err) {
    console.error('資料取得錯誤:', err);
    res.status(500).json({ message: '伺服器錯誤' });
  }
});


//取得group
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

//取得memberId
router.get('/getMemberId', async (req, res) => {
  const userId = req.query.userId;

  if (!userId) {
    return res.status(400).json({ success: false, message: '缺少 userId ' });
  }

  try {
    const [rows] = await db.query(
      'SELECT DISTINCT r.member_id FROM record r WHERE r.fk_userid = ?',
      [userId]
    );

    if (rows.length > 0) {
      res.status(200).json({
        success: true,
        memberId: rows[0].member_id,
      });
    } else {
      res.status(404).json({ success: false, message: '找不到符合條件的紀錄' });
    }
  } catch (error) {
    console.error('查詢 member_id 失敗：', error);
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

//修改是否開啟護理提醒
router.post('/updateIfcall', async (req, res) => {
  const { userId, recordId, ifcall } = req.body;
  if (!userId || !ifcall) {
    return res.status(400).json({ success: false, message: '缺少必要參數 (userId 或 oktime)' });
  }
  try {
    let result;
    if (!recordId) {
      return res.status(400).json({ success: false, message: 'recordId 為必要參數' });
    }
    [result] = await db.query(
      'UPDATE record SET ifcall = ? WHERE fk_userid = ? AND id_record = ?',
      [ifcall, userId, recordId]
    );
    if (result.affectedRows > 0) {
      res.status(200).json({ success: true });
    } else {
      res.status(404).json({ success: false, message: '找不到符合條件的紀錄' });
    }
  } catch (error) {
    console.error('更新 ifcall 失敗：', error);
    res.status(500).json({ success: false, message: '伺服器錯誤' });
  }
});

//更新groupId
router.post('/updateGroupId', async (req, res) => {
  const { userId, recordId1, recordId2, groupId } = req.body;
  if (!userId || !recordId1 || !recordId2 || groupId === undefined) {
    return res.status(400).json({ success: false, message: '缺少必要欄位' });
  }
  try {
    const [result] = await db.query(
      'UPDATE record SET group_id = ? WHERE fk_userid = ? AND id_record IN (?, ?)',
      [groupId, userId, recordId1, recordId2]
    );
    if (result.affectedRows > 0) {
      res.status(200).json({ success: true, message: '更新成功' });
    } else {
      res.status(404).json({ success: false, message: '找不到符合條件的資料' });
    }
  } catch (error) {
    console.error('更新 group_id 失敗：', error);
    res.status(500).json({ success: false, message: '伺服器錯誤' });
  }
});

module.exports = router;