const express = require('express');
const router = express.Router();
const db = require('../config/db');

// === 新增護理提醒 ===
router.post('/addRemind', async (req, res) => {
    try {
        const { fk_user_id, fk_record_id, day, time, freq } = req.body;
        console.log('收到的參數:', req.body);
        const query = `
      INSERT INTO calls 
      (fk_user_id, fk_record_id, day, time, freq)
      VALUES (?, ?, ?, ?, ?)
    `;
        const [result] = await db.query(query, [fk_user_id, fk_record_id, day, time, freq]);
        res.json({
            message: 'User added successfully',
            insertId: result.insertId
        });
    } catch (err) {
        console.error('資料庫錯誤:', err);
        res.status(500).json({ error: 'Database error' });
    }
});

// === 取得護理提醒 ===
router.get('/getReminds', async (req, res) => {
    const id = req.query.id;
    if (!id) return res.status(400).json({ error: 'id is required' });
    const userId = Number(id);
    if (isNaN(userId)) return res.status(400).json({ error: 'Invalid id format' });
    const query = `SELECT * FROM calls WHERE fk_user_id = ?`;
    try {
        const [results] = await db.query(query, [userId]);
        if (results.length === 0) {
            return res.status(404).json({ error: 'Reminds not found' });
        }
        res.json(results);
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: 'Database error' });
    }
});


// === 修改提醒時間 ===
router.post('/updateRemindTime', async (req, res) => {
    const { fk_record_id, fk_user_id, time } = req.body;
    // 驗證欄位是否齊全
    if (!fk_record_id || !fk_user_id || !time) {
        return res.status(400).json({ error: 'fk_record_id, fk_user_id, and time are required' });
    }
    // 驗證數值格式
    const recordId = Number(fk_record_id);
    const userId = Number(fk_user_id);
    if (isNaN(recordId) || isNaN(userId)) {
        return res.status(400).json({ error: 'Invalid fk_record_id or fk_user_id format' });
    }
    const query = 'UPDATE calls SET time = ? WHERE fk_record_id = ? AND fk_user_id = ?';
    try {
        const [result] = await db.query(query, [time, recordId, userId]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Record not found or already up-to-date' });
        }
        res.json({ message: 'Record updated successfully' });
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: 'Database error' });
    }
});

// === 刪除護理提醒 ===
router.post('/deleteRemind', async (req, res) => {
  const { fk_user_id, fk_record_id } = req.body;
  if (!fk_user_id || !fk_record_id) {
    return res.status(400).json({ error: 'fk_user_id 和 fk_record_id 都是必要的' });
  }
  const userId = Number(fk_user_id);
  const recordId = Number(fk_record_id);
  if (isNaN(userId) || isNaN(recordId)) {
    return res.status(400).json({ error: 'fk_user_id 或 fk_record_id 格式不正確' });
  }
  const query = 'DELETE FROM calls WHERE fk_user_id = ? AND fk_record_id = ?';
  try {
    const [results] = await db.query(query, [userId, recordId]);
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: '找不到符合條件的提醒資料' });
    }
    res.json({ message: '提醒資料成功刪除' });
  } catch (err) {
    console.error('資料庫錯誤:', err);
    res.status(500).json({ error: 'Database error' });
  }
});



module.exports = router;