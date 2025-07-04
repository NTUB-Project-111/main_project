const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();
const db = require('../config/db');
const redisClient = require('../config/redis');
const transporter = require('../utils/mailer');
const upload = require('../utils/upload');
const jwt = require('jsonwebtoken'); //user身分驗證


// === 發送驗證碼 ===
router.post('/sendCode', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: '請輸入 Email' });
  const rateLimitKey = `rate_limit:${email}`;
  const resetCodeKey = `reset_code:${email}`;
  if (await redisClient.get(rateLimitKey)) {
    return res.status(429).json({ message: '請稍後再試' });
  }
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  try {
    await redisClient.setEx(resetCodeKey, 300, code);
    await redisClient.setEx(rateLimitKey, 60, '1');
    const mailOptions = {
      from: process.env.GMAIL_USER,
      to: email,
      subject: '驗證碼',
      text: `您好，您的驗證碼是：${code}。\n請於 5 分鐘內輸入以完成驗證。`
    };
    await transporter.sendMail(mailOptions);
    return res.json({ message: '驗證碼已寄出' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: '伺服器錯誤' });
  }
});

// === 驗證重設密碼驗證碼 ===
router.post('/verifyCode', async (req, res) => {
  const { email, code } = req.body;
  if (!email || !code) return res.status(400).json({ message: '請填寫Email及驗證碼' });
  try {
    const savedCode = await redisClient.get(`reset_code:${email}`);
    if (!savedCode) return res.status(410).json({ message: '驗證碼已過期或不存在' });
    if (savedCode !== code) return res.status(401).json({ message: '驗證碼錯誤' });
    return res.json({ message: '驗證碼正確' });
  } catch (err) {
    return res.status(500).json({ message: '伺服器錯誤' });
  }
});

// === 註冊帳號 ===
router.post('/register', upload.single('picture'), async (req, res) => {
  const { name, gender, birthday, email, password, disease, freq } = req.body;
  const picture = req.file ? req.file.path : null;
  if (!name || !gender || !birthday || !email || !password) {
    return res.status(400).json({ message: '尚有欄位未填寫' });
  }
  try {
    const [existing] = await db.query('SELECT id FROM user WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ message: '此電子郵件已被註冊' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO user (name, gender, birthday, picture, email, password, disease, freq) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [name, gender, birthday, picture, email, hashedPassword, disease, freq]
    );
    res.status(201).json({ message: '註冊成功' });
  } catch (error) {
    console.error('註冊錯誤：', error);
    res.status(500).json({ message: '伺服器錯誤' });
  }
});

// === 登入帳號 ===
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    // 1. 找出該 email 的使用者
    const [rows] = await db.query('SELECT * FROM user WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ message: '此帳號不存在' });
    }
    const user = rows[0];
    // 2. 比對密碼
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: '密碼錯誤' });
    }
    // 3. 產生 JWT Token
    const accessToken = jwt.sign(
      { id: user.id, email: user.email },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: '15m' }
    );
    res.json({ accessToken });
  } catch (err) {
    console.error('登入錯誤:', err);
    res.status(500).json({ message: '伺服器錯誤' });
  }

});


// === 檢查帳號是否存在 ===
router.post('/exist', async (req, res) => {
  const { email } = req.body;
  // email 格式檢查
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return res.status(400).json({
      success: false,
      message: '請提供有效的 email',
    });
  }
  try {
    const [rows] = await db.query(
      'SELECT id FROM user WHERE email = ?',
      [email]
    );
    if (rows.length === 0) {
      return res.status(200).json({
        success: true,
        exists: false,
        message: '此帳號不存在',
      });
    }
    res.status(200).json({
      success: true,
      exists: true,
      message: '帳號已存在',
    });
  } catch (error) {
    console.error('查詢帳號錯誤:', error);
    res.status(500).json({
      success: false,
      message: '伺服器錯誤，請稍後再試',
    });
  }
});

// === 重設密碼 ===
router.post('/resetPassword', async (req, res) => {
  const { email, newPassword } = req.body;
  if (!email || !newPassword) {
    return res.status(400).json({ error: '請提供 email 與 newPassword' });
  }
  try {
    // 查詢使用者是否存在
    const [users] = await db.query('SELECT id FROM user WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(404).json({ error: '找不到該電子郵件的使用者' });
    }
    const userId = users[0].id;
    // 密碼加密
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    // 更新密碼
    await db.query('UPDATE user SET password = ? WHERE id = ?', [hashedPassword, userId]);
    res.json({ message: '密碼已成功重設' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: '伺服器錯誤' });
  }
});


module.exports = router;
