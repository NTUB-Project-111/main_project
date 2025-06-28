const express = require('express');
const router = express.Router();
const upload = require('../utils/upload');
const db = require('../config/db');

// === 新增診斷紀錄 ===
router.post('/addRecord', upload.single('photo'), async (req, res) => {
  try {
    const { fk_userid, date, type, oktime, caremode, ifcall, choosekind, recording } = req.body;
    if (!req.file) {
      return res.status(400).json({ error: '請提供圖片' });
    }
    const photoPath = `/uploads/${req.file.filename}`;
    const [result] = await db.query(
      `
      INSERT INTO record 
      (fk_userid, date, photo, type, oktime, caremode, ifcall, choosekind, recording)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [fk_userid, date, photoPath, type, oktime, caremode, ifcall, choosekind, recording]
    );
    const insertedId = result.insertId;
    return res.json({
      message: 'Record added successfully',
      id_record: insertedId,
      photoPath,
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
      ifcall, choosekind, recording
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
          photo: row.photo,
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


module.exports = router;