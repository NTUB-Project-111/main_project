const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/getMembers', async (req, res) => {
  const id = req.query.id;
  if (!id) return res.status(400).json({ error: 'id is required' });

  const userId = Number(id);
  if (isNaN(userId)) return res.status(400).json({ error: 'Invalid id format' });

  const query = 'SELECT * FROM family WHERE user_id = ?';
  try {
    const [results] = await db.query(query, [userId]);
    if (results.length === 0) {
      return res.status(404).json({ error: 'No family member found' });
    }
    res.json({ members: results });
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database error' });
  }
});


// router.post('/addMember', async (req, res) => {

//   const { userId, role, birthyear, disease, freq } = req.body || {};

//   if (!userId || !role || !birthyear || !disease || !freq) {
//     return res.status(400).json({ message: '尚有欄位未填寫' });
//   }

//   try {
//     // 檢查該 user 下是否已有相同 role
//     const [existingRows] = await db.query(
//       'SELECT member_id FROM family WHERE user_id = ? AND role = ?',
//       [userId, role]
//     );

//     if (existingRows.length > 0) {
//       return res.status(409).json({ message: '該角色已存在' });
//     }

//     const [member] = await db.query(
//       'INSERT INTO family (user_id, role, birthyear, disease, freq) VALUES (?, ?, ?, ?, ?)',
//       [userId, role, birthyear, disease, freq]
//     );

//     console.log(`Family member added for user ${userId} with role ${role}`);
//     res.status(201).json({ message: '成員新增成功', member: member });
//   } catch (error) {
//     console.error('新增錯誤：', error);
//     res.status(500).json({ message: '伺服器錯誤' });
//   }
// });
// === 新增家庭成員 ===
router.post('/addMember', async (req, res) => {
  const { userId, role, birthyear, disease, freq } = req.body;

  // 檢查欄位是否都有填寫
  if ([userId, role, birthyear, disease, freq].some(v => v === undefined || v === null || v === '')) {
    return res.status(400).json({ message: '尚有欄位未填寫' });
  }

  try {
    // 檢查該 user 下是否已有相同角色
    const [existingRows] = await db.query(
      'SELECT member_id FROM family WHERE user_id = ? AND role = ?',
      [userId, role]
    );

    if (existingRows.length > 0) {
      return res.status(409).json({ message: '該角色已存在' });
    }

    // 新增成員
    const [result] = await db.query(
      'INSERT INTO family (user_id, role, birthyear, disease, freq) VALUES (?, ?, ?, ?, ?)',
      [userId, role, birthyear, disease, freq]
    );

    const insertedId = result.insertId;

    // 查詢剛新增的成員完整資料
    const [rows] = await db.query(
      'SELECT member_id, user_id, role, birthyear, disease, freq FROM family WHERE member_id = ?',
      [insertedId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: '找不到新增的成員資料' });
    }

    console.log(`Family member added for user ${userId} with role ${role}`);

    res.status(201).json({
      message: '成員新增成功',
      member: rows[0], // 回傳完整的成員資料
    });

  } catch (error) {
    console.error('新增錯誤：', error);
    res.status(500).json({ message: '伺服器錯誤' });
  }
});


module.exports = router;