const express = require('express');
const jwt = require('jsonwebtoken');
const db = require('../config/db');
const bcrypt = require('bcrypt');
const router = express.Router();
// const upload = require('../utils/upload');
const { upload, uploadToCloudinary } = require('../utils/upload');


// === 叫醒伺服器用 ===
router.get('/ping', async (req, res) => {
    res.status(200).send('pong');
});


// === 取得所有使用者資料 ===
router.get('/getUsers', async (req, res) => {
    try {
        const [rows] = await db.query(
            `SELECT * FROM user`
        );
        res.json({ users: rows });
    } catch (err) {
        console.error('取得所有使用者資料錯誤:', err);
        res.status(500).json({ message: '伺服器錯誤' });
    }
});

// === 取得使用者資料 ===
router.get('/getUserInfo', async (req, res) => {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ')
        ? authHeader.split(' ')[1]
        : null;
    if (!token) {
        return res.status(401).json({ message: '未提供或格式錯誤的驗證資訊' });
    }
    try {
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        const [rows] = await db.query(
            `SELECT id, name, gender, DATE_FORMAT(birthday, '%Y-%m-%d') AS birthday, picture, email FROM user WHERE email = ?`,
            [decoded.email]
        );
        if (rows.length === 0) {
            return res.status(404).json({ message: '找不到使用者資料' });
        }
        res.json({ user: rows[0] });
    } catch (err) {
        console.error('取得使用者資料錯誤:', err);
        res.status(401).json({ message: '無效的或過期的 token' });
    }
});

// === 修改使用者名稱 ===
router.post('/updateName', async (req, res) => {
    const { id, name } = req.body;
    console.log('接收到請求', req.body);

    try {
        const [result] = await db.query('UPDATE user SET name = ? WHERE id = ?', [name, id]);
        console.log('更新成功', result);
        return res.json({ message: '名稱更新成功' });
    } catch (err) {
        console.error('資料庫錯誤:', err);
        return res.status(500).json({ error: '資料庫錯誤' });
    }
});

// === 驗證使用者密碼 ===
router.post('/verifyPassword', async (req, res) => {
    const { id, password } = req.body;
    try {
        const [rows] = await db.query('SELECT password FROM user WHERE id = ?', [id]);
        if (rows.length === 0) {
            return res.status(404).json({ message: '找不到使用者' });
        }
        const isMatch = await bcrypt.compare(password, rows[0].password);
        if (!isMatch) {
            return res.status(401).json({ message: '原密碼輸入錯誤' });
        }
        return res.json({ message: '密碼正確' });
    } catch (err) {
        console.error('驗證密碼錯誤:', err);
        return res.status(500).json({ error: '伺服器錯誤' });
    }
});


// === 修改使用者密碼 ===
router.post('/updatePassword', async (req, res) => {
    const { id, password } = req.body;
    console.log('接收到請求', req.body);
    try {
        //雜湊密碼
        const hashedPassword = await bcrypt.hash(password, 10); // 10 是 salt rounds，可調整安全性
        //更新資料庫中的密碼
        const [result] = await db.query('UPDATE user SET password = ? WHERE id = ?', [hashedPassword, id]);
        console.log('更新成功', result);
        return res.json({ message: '密碼更新成功' });
    } catch (err) {
        console.error('資料庫錯誤:', err);
        return res.status(500).json({ error: '資料庫錯誤' });
    }
});

// === 更新大頭照 ===
// router.post('/updateImage', upload.single('picture'), async (req, res) => {
//     const { id } = req.body;
//     const imagePath = req.file ? `/uploads/${req.file.filename}` : null;
//     if (!id) {
//         return res.status(400).json({ error: 'User ID is required' });
//     }
//     if (!imagePath) {
//         return res.status(400).json({ error: 'No image uploaded' });
//     }
//     try {
//         const [result] = await db.query(
//             'UPDATE user SET picture = ? WHERE id = ?',
//             [imagePath, id]
//         );
//         console.log('圖片更新成功', result);
//         return res.json({
//             message: 'User picture updated successfully',
//             path: imagePath,
//         });
//     } catch (err) {
//         console.error('資料庫錯誤:', err);
//         return res.status(500).json({ error: 'Database error', details: err });
//     }
// });
router.post('/updateImage', upload.single('picture'), async (req, res) => {
    const { id } = req.body;
    if (!id) {
        return res.status(400).json({ error: 'User ID is required' });
    }
    if (!req.file) {
        return res.status(400).json({ error: 'No image uploaded' });
    }

    try {
        // 上傳至 Cloudinary
        const cloudResult = await uploadToCloudinary(req.file.buffer, `user_${id}_${Date.now()}`);
        const imageUrl = cloudResult.secure_url;

        // 更新使用者資料表中的圖片欄位
        const [result] = await db.query(
            'UPDATE user SET picture = ? WHERE id = ?',
            [imageUrl, id]
        );

        console.log('圖片更新成功', result);
        return res.json({
            message: 'User picture updated successfully',
            path: imageUrl,
        });
    } catch (err) {
        console.error('圖片上傳錯誤:', err);
        return res.status(500).json({ error: '圖片上傳失敗', details: err });
    }
});

//取得使用者家庭資訊
router.get('/getUserFamily', async (req, res) => {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.split(' ')[1] : null;

    if (!token) {
        return res.status(401).json({ message: '未提供 token' });
    }

    try {
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        const email = decoded.email;

        // 查使用者
        const [userRows] = await db.query(
            `SELECT id, email FROM user WHERE email = ?`,
            [email]
        );

        if (userRows.length === 0) {
            return res.status(404).json({ message: '找不到使用者' });
        }

        const user = userRows[0];

        // 查家庭成員
        const [rows] = await db.query(`
            SELECT *
            FROM family f
            WHERE f.user_id = ?;
        `, [user.id]);

        res.status(200).json({ user, family: rows });

    } catch (err) {
        console.error('資料取得錯誤:', err);
        if (err.name === 'TokenExpiredError') {
            return res.status(401).json({ message: 'Token 已過期' });
        }
        if (err.name === 'JsonWebTokenError') {
            return res.status(401).json({ message: '無效的 Token' });
        }
        res.status(500).json({ message: '伺服器錯誤' });
    }
});

//取得使用者所有資訊
router.get('/getUserDetail', async (req, res) => {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.split(' ')[1] : null;
    if (!token) {
        return res.status(401).json({ message: '未提供 token' });
    }
    try {
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        const email = decoded.email;
        // 查使用者
        const [userRows] = await db.query(
            `SELECT id, name, birthday, email, disease, freq, role, password FROM user WHERE email = ?`,
            [email]
        );
        if (userRows.length === 0) return res.status(404).json({ message: '找不到使用者' });
        const user = userRows[0];
        // 移除 gender 與 picture 欄位
        // 若前端有用到 user.gender 或 user.picture，請一併調整
        // 查診斷報告與護理提醒
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
            r.group_id,
            r.name,
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
            `, [user.id]);

        // 整理資料為巢狀格式
        const reportMap = {};
        const reports = [];
        for (const row of rows) {
            if (!reportMap[row.reportId]) {
                reportMap[row.reportId] = {
                    id: row.reportId, userId: row.fk_userid, date: row.date,
                    type: row.type, oktime: row.oktime, caremode: row.caremode,
                    ifcall: row.ifcall, choosekind: row.choosekind, recording: row.recording,
                    photo: row.photo, name: row.name, group_id: row.group_id,
                    reminds: [],
                };
                reports.push(reportMap[row.reportId]);
            }
            if (row.remindId) {
                reportMap[row.reportId].reminds.push({
                    id: row.remindId, userId: row.fk_user_id, recordId: row.fk_record_id,
                    date: row.day, time: row.time, freq: row.freq,
                });
            }
        }
        res.json({
            user,
            reports,
        });
    } catch (err) {
        console.error('資料取得錯誤:', err);
        res.status(500).json({ message: '伺服器錯誤' });
    }
});

// === 取得使用者所有資訊(含家庭) ===
router.get('/fetchUserInfo', async (req, res) => {
  try {
    const id = req.query.id || req.body.id;
    if (!id) return res.status(400).json({ message: '缺少 id 參數' });

    const [userRows] = await db.query(
      `SELECT * FROM user WHERE id = ?`,
      [id]
    );
    if (userRows.length === 0) return res.status(404).json({ message: '找不到使用者' });
    const user = userRows[0];

    const [family] = await db.query(`SELECT * FROM family WHERE user_id = ?`, [user.id]);
    const [reports] = await db.query(`SELECT * FROM record WHERE fk_userid = ? ORDER BY id_record DESC`, [user.id]);
    const [reminds] = await db.query(`SELECT * FROM calls WHERE fk_user_id = ? ORDER BY id_calls DESC`, [user.id]);

    res.json({ user, family, reports, reminds });
  } catch (err) {
    console.error('資料取得錯誤:', err.message);
    res.status(500).json({ message: '伺服器錯誤', error: err.message });
  }
});


// === 修改習慣頻率 ===
router.post('/updateFreq', async (req, res) => {
    const { id, freq } = req.body;
    console.log('接收到請求', req.body);

    try {
        const [result] = await db.query('UPDATE family SET freq = ? WHERE member_id = ?', [freq, id]);
        console.log('更新成功', result);
        return res.json({ message: '更新成功' });
    } catch (err) {
        console.error('資料庫錯誤:', err);
        return res.status(500).json({ error: '資料庫錯誤' });
    }
});

// === 修改特殊病症 ===
router.post('/updateDisease', async (req, res) => {
    const { id, disease } = req.body;
    console.log('接收到請求', req.body);

    try {
        const [result] = await db.query('UPDATE family SET disease = ? WHERE member_id = ?', [disease, id]);
        console.log('更新成功', result);
        return res.json({ message: '更新成功' });
    } catch (err) {
        console.error('資料庫錯誤:', err);
        return res.status(500).json({ error: '資料庫錯誤' });
    }
});



module.exports = router;