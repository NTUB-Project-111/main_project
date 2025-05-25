// === 引入套件 ===
const express = require('express');
const mysql = require('mysql2');
const multer = require('multer');
const path = require('path');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { createClient } = require('redis');
const nodemailer = require('nodemailer');
require('dotenv').config(); // 載入 .env 環境變數

// === 基本設定 ===
const app = express();
const port = process.env.PORT || 3000;
const SECRET_KEY = process.env.JWT_SECRET;
const REFRESH_SECRET_KEY = process.env.REFRESH_SECRET_KEY;
const axios = require('axios');
const GOOGLE_KEY = 'AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs';
const saltRounds = 10;

// === Middleware ===
app.use(express.json()); // 處理 JSON 請求
app.use(express.urlencoded({ extended: true })); // 處理表單資料
app.use('/uploads', express.static('uploads')); // 提供上傳圖片的存取路徑

// === MySQL 資料庫設定（連線池）===
const pool = mysql.createPool({
  host: '140.131.114.242',
  user: 'rootdrwnew',
  password: 'New8888@',
  database: '114-Drw_New',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// === Multer 圖片上傳設定 ===
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});
const upload = multer({ storage });

// === JWT 驗證與角色限制 Middleware ===
function authenticateRole(requiredRole = null) {
  return function (req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: '未提供授權 token' });
    }

    const token = authHeader.split(' ')[1];

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
      if (err) return res.status(403).json({ message: 'Token 驗證失敗' });

      if (requiredRole && decoded.role !== requiredRole) {
        return res.status(403).json({ message: '權限不足' });
      }

      req.user = decoded;
      next();
    });
  };
}

// === 健康檢查 API ===
app.get('/health', (req, res) => res.send('OK'));

// === 管理員專屬 API ===
app.get('/adminOnly', authenticateRole('admin'), (req, res) => {
  res.json({ message: '歡迎管理員！' });
});

// === Redis Cloud 設定 ===
const redisClient = createClient({
  username: 'default',
  password: 'wOIuK6RL5RN2e7TZzaQX4vZRTnxKykg4',
  socket: {
    host: 'redis-16985.c295.ap-southeast-1-1.ec2.redns.redis-cloud.com',
    port: 16985
  }
});
redisClient.on('error', (err) => console.error('Redis Client Error', err));

// === 初始化 Redis 連線 ===
(async () => {
  try {
    await redisClient.connect();
    console.log('✅ 成功連線 Redis Cloud');
  } catch (err) {
    console.error('❌ Redis 連線失敗:', err);
  }
})();

// === Nodemailer 設定（Gmail）===
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'Drw114410@gmail.com',
    pass: 'qclxowyspprstriv'
  }
});


// === 上傳圖片並寫入資料庫 ===
app.post('/uploadImage', upload.single('image'), (req, res) => {
  const { fk_userid, date, type, caremode, ifcall, choosekind, recording } = req.body;
  const imagePath = req.file ? `/uploads/${req.file.filename}` : null;
  if (!imagePath) {
    return res.status(400).json({ error: 'No image uploaded' });
  }
  const query = `
    INSERT INTO record (fk_userid, date, photo, type, caremode, ifcall, choosekind, recording) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  pool.query(query, [fk_userid, date, imagePath, type, caremode, ifcall, choosekind, recording], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json({
      message: 'Image uploaded and record added successfully',
      imagePath
    });
  });
});

// === 更新使用者大頭照 ===
app.post('/updateImage', upload.single('image'), (req, res) => {
  const { id } = req.body;
  const imagePath = req.file ? `/uploads/${req.file.filename}` : null;

  if (!id) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  if (!imagePath) {
    return res.status(400).json({ error: 'No image uploaded' });
  }

  const query = 'UPDATE user SET picture = ? WHERE id = ?';
  pool.query(query, [imagePath, id], (err, results) => {
    if (err) {
      console.error("SQL Error:", err);
      return res.status(500).json({ error: 'Database error', details: err });
    }
    res.json({ message: 'User picture updated successfully', path: imagePath });
  });
});


// === 登入使用者 ===
app.post('/loginUser', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: '請輸入帳號與密碼' });

  const query = 'SELECT id, password, role FROM user WHERE email = ?';
  pool.query(query, [email], (err, results) => {
    if (err) return res.status(500).json({ message: '伺服器錯誤' });
    if (results.length === 0) return res.status(404).json({ message: '此帳號不存在' });

    const user = results[0];
    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err) return res.status(500).json({ message: '伺服器錯誤' });
      if (!isMatch) return res.status(401).json({ message: '密碼錯誤' });

      // 建立 access token（有效期短）
      const accessToken = jwt.sign(
        { userID: user.id, role: user.role },
        SECRET_KEY,
        { expiresIn: '15m' } // 建議縮短為 15 分鐘
      );

      // 建立 refresh token（有效期長）
      const refreshToken = jwt.sign(
        { userID: user.id },
        REFRESH_SECRET_KEY,
        { expiresIn: '7d' }
      );

      // 回傳兩個 token
      return res.status(200).json({
        message: '登入成功',
        token: accessToken,
        refreshToken: refreshToken,
      });
    });
  });
});

// === 更新Token ===
app.post('/refreshToken', (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ message: '未提供 refreshToken' });
  }

  jwt.verify(refreshToken, REFRESH_SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: 'refreshToken 驗證失敗或已過期' });
    }

    const { userID } = decoded;

    // 根據 userID 查詢角色資料（可選）
    const query = 'SELECT role FROM user WHERE id = ?';
    pool.query(query, [userID], (err, results) => {
      if (err || results.length === 0) {
        return res.status(500).json({ message: '找不到使用者資料' });
      }

      const userRole = results[0].role;

      // 發出新的 accessToken
      const newAccessToken = jwt.sign(
        { userID, role: userRole },
        SECRET_KEY,
        { expiresIn: '15m' }
      );

      res.status(200).json({ token: newAccessToken });
    });
  });
});


// === 驗證密碼 ===
app.post('/verifyPassword', (req, res) => {
  const { email, password } = req.body;
  const query = 'SELECT password FROM user WHERE email = ?';
  pool.query(query, [email], (err, results) => {
    if (err) return res.status(500).json({ success: false, error: '資料庫錯誤' });
    if (results.length === 0) return res.status(404).json({ success: false, error: '使用者未找到' });

    bcrypt.compare(password, results[0].password, (err, result) => {
      if (err) return res.status(500).json({ success: false, error: '比對錯誤' });
      return result
        ? res.status(200).json({ success: true, message: '密碼正確' })
        : res.status(401).json({ success: false, error: '密碼錯誤' });
    });
  });
});


// === 發送驗證碼（忘記密碼）===
app.post('/sendCode', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: '請輸入 Email' });

  const rateLimitKey = `rate_limit:${email}`;
  if (await redisClient.get(rateLimitKey)) return res.status(429).json({ message: '請稍後再試' });

  const code = Math.floor(100000 + Math.random() * 900000).toString();

  try {
    await redisClient.setEx(`reset_code:${email}`, 300, code); // 驗證碼有效 5 分鐘
    await redisClient.setEx(rateLimitKey, 60, '1'); // 60 秒內不可重發

    const mailOptions = {
      from: 'Drw114410@gmail.com',
      to: email,
      subject: 'Dr.W_驗證碼',
      text: `您好，您的驗證碼是：${code}。\n請在 5 分鐘內輸入以完成驗證。`
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) return res.status(500).json({ message: '寄送驗證碼 Email 失敗' });
      return res.json({ message: '驗證碼已寄出' });
    });
  } catch (err) {
    return res.status(500).json({ message: '伺服器錯誤' });
  }
});

// === 忘記密碼流程 ===
app.post('/forgotPassword', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: '請輸入 Email' });

  pool.query('SELECT * FROM user WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ message: '伺服器錯誤' });
    if (results.length === 0) return res.status(404).json({ message: 'Email 不存在' });

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    try {
      await redisClient.setEx(`reset_code:${email}`, 300, code);

      const mailOptions = {
        from: 'Drw114410@gmail.com',
        to: email,
        subject: '忘記密碼驗證碼',
        text: `您好，您的驗證碼是：${code}。\n請在 5 分鐘內輸入以完成驗證。`
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) return res.status(500).json({ message: '寄送驗證碼 Email 失敗' });
        return res.json({ message: '驗證碼已寄出' });
      });
    } catch (redisErr) {
      return res.status(500).json({ message: 'Redis 儲存驗證碼失敗' });
    }
  });
});

// === 驗證重設密碼驗證碼 ===
app.post('/verifyResetCode', async (req, res) => {
  const { email, code } = req.body;
  if (!email || !code) return res.status(400).json({ message: '請填寫所有欄位' });

  try {
    const savedCode = await redisClient.get(`reset_code:${email}`);
    if (!savedCode) return res.status(410).json({ message: '驗證碼已過期或不存在' });
    if (savedCode !== code) return res.status(401).json({ message: '驗證碼錯誤' });

    return res.json({ message: '驗證碼正確' });
  } catch (err) {
    return res.status(500).json({ message: '伺服器錯誤' });
  }
});

// === 重設密碼 ===
app.post('/resetPassword', async (req, res) => {
  const { email, code, newPassword } = req.body;

  if (!email || !code || !newPassword) {
    return res.status(400).json({ message: '請填寫所有欄位' });
  }

  try {
    const savedCode = await redisClient.get(`reset_code:${email}`);

    if (!savedCode || savedCode !== code) {
      return res.status(401).json({ message: '驗證碼錯誤或已過期' });
    }

    bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
      if (err) return res.status(500).json({ message: '加密失敗' });

      const updateQuery = 'UPDATE user SET password = ? WHERE email = ?';
      pool.query(updateQuery, [hashedPassword, email], async (err) => {
        if (err) return res.status(500).json({ message: '更新密碼失敗' });

        await redisClient.del(`reset_code:${email}`);
        return res.json({ message: '密碼已更新，請重新登入' });
      });
    });
  } catch (err) {
    return res.status(500).json({ message: '伺服器錯誤' });
  }
});


// === 新增使用者 ===
app.post('/addUser', upload.single('photo'), (req, res) => {
  const { name, email, password, gender, birthday } = req.body;
  const photoPath = req.file ? `/uploads/${req.file.filename}` : null;

  bcrypt.hash(password, saltRounds, (err, hashedPassword) => {
    if (err) return res.status(500).json({ success: false, error: '加密失敗' });

    const query = 'INSERT INTO user (name, email, password, gender, birthday, picture) VALUES (?, ?, ?, ?, ?, ?)';
    pool.query(query, [name, email, hashedPassword, gender, birthday, photoPath], (err) => {
      if (err) return res.status(500).json({ success: false, error: 'Database error' });
      return res.status(200).json({ success: true });
    });
  });
});

// === 修改使用者名稱 ===
app.post('/updateName', (req, res) => {
  const { id, name } = req.body;
  pool.query('UPDATE user SET name = ? WHERE id = ?', [name, id], (err) => {
    if (err) return res.status(500).send('Database error');
    res.send({ message: 'User name updated successfully' });
  });
});

// === 修改密碼 ===
app.post('/updatePassword', (req, res) => {
  const { id, password } = req.body;
  pool.query('UPDATE user SET password = ? WHERE id = ?', [password, id], (err) => {
    if (err) return res.status(500).send('Database error');
    res.send({ message: 'User password updated successfully' });
  });
});

// === 取得所有使用者資料 ===
app.get('/getUsers', (req, res) => {
  pool.query('SELECT * FROM user', (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.json(results);
  });
});

// === 取得單一使用者資料（JWT驗證）===
app.get('/getUserInfo', authenticateRole(), (req, res) => {
  const userID = req.user.userID;
  const query = `
    SELECT id, name, DATE_FORMAT(birthday, '%Y-%m-%d') AS birthday, gender, email, password, picture 
    FROM user 
    WHERE id = ?
  `;
  pool.query(query, [userID], (err, results) => {
    if (err) return res.status(500).json({ error: 'Database error' });
    if (results.length === 0) return res.status(404).json({ error: 'User not found' });
    res.json(results[0]);
  });
});

// === 根據 Email 取得使用者 ID ===
app.get('/saveUserId', (req, res) => {
  const email = req.query.email;
  if (!email) return res.status(400).send('Email is required');
  pool.query('SELECT id FROM user WHERE email = ?', [email], (err, results) => {
    if (err) return res.status(500).send('Database error');
    if (results.length === 0) return res.status(404).send('User not found');
    res.json(results[0]);
  });
});


// === 取得使用者診斷報告 ===
app.get('/getUserRecord', (req, res) => {
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

  pool.query(query, [userId], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) return res.status(404).json({ error: 'No records found' });

    res.json({ records: results });
  });
});

// === 取得護理提醒 ===
app.get('/getReminds', (req, res) => {
  const id = req.query.id;
  if (!id) return res.status(400).json({ error: 'id is required' });

  const query = `SELECT * FROM calls WHERE fk_user_id = ?`;

  pool.query(query, [id], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) return res.status(404).json({ error: 'Reminds not found' });

    res.json(results);
  });
});

// === 取得結合後的診斷+護理提醒資料 ===
app.get('/getRemindRecord', (req, res) => {
  const id = req.query.id;
  if (!id) return res.status(400).json({ error: 'id is required' });

  const query = `
    SELECT DISTINCT 
      r.fk_userid, r.id_record,
      DATE_FORMAT(r.date, '%Y-%m-%d') AS date,
      r.photo, r.type, r.ifcall, r.oktime,
      c.time, c.freq
    FROM record r
    INNER JOIN calls c ON r.id_record = c.fk_record_id
    WHERE r.ifcall = 'Y' AND fk_userid = ?
  `;

  pool.query(query, [id], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) return res.status(404).json({ error: 'Reminds not found' });

    res.json(results);
  });
});

// === 刪除護理提醒 ===
app.post('/deleteRemind', (req, res) => {
  const { fk_user_id, fk_record_id } = req.body;
  if (!fk_user_id || !fk_record_id)
    return res.status(400).json({ error: 'fk_user_id 和 fk_record_id 都是必要的' });

  const query = 'DELETE FROM calls WHERE fk_user_id = ? AND fk_record_id = ?';

  pool.query(query, [fk_user_id, fk_record_id], (err, results) => {
    if (err) {
      console.error('資料庫錯誤:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.affectedRows === 0)
      return res.status(404).json({ error: '找不到符合條件的提醒資料' });

    res.json({ message: '提醒資料成功刪除' });
  });
});

// === 修改診斷紀錄 ifcall 欄位 ===
app.post('/updateRecord', (req, res) => {
  const { id_record, fk_userid, ifcall } = req.body;

  const query = 'UPDATE record SET ifcall = ? WHERE id_record = ? AND fk_userid = ?';

  pool.query(query, [ifcall, id_record, fk_userid], (err, results) => {
    if (err) return res.status(500).send('Database error');

    res.send({ message: 'Record updated successfully' });
  });
});

// === 修改提醒時間 ===
app.post('/updateCallTime', (req, res) => {
  const { fk_record_id, fk_user_id, time } = req.body;

  const query = 'UPDATE calls SET time = ? WHERE fk_record_id = ? AND fk_user_id = ?';

  pool.query(query, [time, fk_record_id, fk_user_id], (err, results) => {
    if (err) return res.status(500).send('Database error');

    res.send({ message: 'Record updated successfully' });
  });
});

// === 首頁換藥提醒 ===
app.get('/getHomeRemind', (req, res) => {
  const id = req.query.id;
  if (!id) return res.status(400).json({ error: 'id is required' });

  const query = `
    SELECT 
      r.fk_userid,
      DATE_FORMAT(c.day, '%Y-%m-%d') AS date,
      r.photo, r.type, c.time
    FROM record r
    INNER JOIN calls c ON r.id_record = c.fk_record_id
    WHERE r.ifcall = 'Y' AND fk_userid = ?
  `;

  pool.query(query, [id], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) return res.status(404).json({ error: 'Home Reminds not found' });

    res.json(results);
  });
});

// === 新增診斷紀錄 ===
app.post('/addRecord', upload.single('photo'), (req, res) => {
  const { fk_userid, date, type, oktime, caremode, ifcall, choosekind, recording } = req.body;

  if (!req.file) return res.status(400).json({ error: '請提供圖片' });

  const photoPath = `/uploads/${req.file.filename}`;

  const query = `
    INSERT INTO record 
    (fk_userid, date, photo, type, oktime, caremode, ifcall, choosekind, recording)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  pool.query(
    query,
    [fk_userid, date, photoPath, type, oktime, caremode, ifcall, choosekind, recording],
    (err, results) => {
      if (err) {
        console.error('資料庫錯誤:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json({ message: 'Record added successfully', photoPath });
    }
  );
});

// === 新增護理提醒 ===
app.post('/addRemind', (req, res) => {
  const { fk_user_id, fk_record_id, day, time, freq } = req.body;

  console.log('收到的參數:', req.body);

  const query = `
    INSERT INTO calls 
    (fk_user_id, fk_record_id, day, time, freq)
    VALUES (?, ?, ?, ?, ?)
  `;

  pool.query(query, [fk_user_id, fk_record_id, day, time, freq], (err, results) => {
    if (err) {
      console.error('資料庫錯誤:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json({ message: 'User added successfully' });
  });
});

// === 地址轉換成經緯度 ===   可刪
async function geocode(addr) {
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(addr)}&key=${GOOGLE_KEY}`;
  const res = await axios.get(url);
  if (res.data.status === 'OK') {
    return res.data.results[0].geometry.location;
  } else {
    throw new Error('Geocode failed: ' + res.data.status);
  }
}

// === 從 Google 地圖查詢醫院電話 ===  可刪
async function fetchPhoneFromGoogle(placeName, city) {
  const url = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${encodeURIComponent(city + placeName)}&inputtype=textquery&fields=place_id&key=${GOOGLE_KEY}`;
  const res = await axios.get(url);

  if (res.data.status === 'OK' && res.data.candidates.length > 0) {
    const placeId = res.data.candidates[0].place_id;
    const detailUrl = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&fields=formatted_phone_number&key=${GOOGLE_KEY}`;
    const detailRes = await axios.get(detailUrl);

    if (detailRes.data.status === 'OK' && detailRes.data.result.formatted_phone_number) {
      return detailRes.data.result.formatted_phone_number;
    }
  }

  return '';
}

// === 取得所有醫院資料 ===
app.get('/getHospitals', (req, res) => {
  const sql = `
    SELECT id, name, city, district, address
    FROM hospital
  `;

  pool.query(sql, (err, results) => {
    if (err) {
      console.error('SQL error:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// === 城市清單 ===
app.get('/api/cities', (req, res) => {
  pool.query("SELECT DISTINCT city FROM hospital ORDER BY city", (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.json(results.map(r => r.city));
  });
});

// === 地區清單 ===
app.get('/api/districts', (req, res) => {
  const { city } = req.query;
  pool.query("SELECT DISTINCT district FROM hospital WHERE city = ?", [city], (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.json(results.map(r => r.district));
  });
});

// === 科別 ===
app.get('/api/departments', (req, res) => {
  const { city, district } = req.query;
  const sql = `
    SELECT DISTINCT sh.department
    FROM hospital h
    JOIN s_hospital sh ON h.id = sh.fk_shospital_id
    WHERE h.city = ?
      AND h.district = ?
      AND sh.department IS NOT NULL
      AND sh.department != ''
  `;
  pool.query(sql, [city, district], (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.json(results.map(r => r.department));
  });
});


// === 醫院查詢 ===
app.get('/api/hospitals', async (req, res) => {
  const { city, district = '', dept = '' } = req.query;
  const sql = `
    SELECT h.id, h.name, h.city, h.district, h.address, h.lat, h.lng, h.phone
    FROM hospital h
    LEFT JOIN s_hospital sh ON h.id = sh.fk_shospital_id
    WHERE h.city = ?
      AND (? = '' OR h.district = ?)
      AND (? = '' OR sh.department = ?)
  `;

  pool.query(sql, [city, district, district, dept, dept], async (err, rows) => {
    if (err) return res.status(500).send('Database error');

    for (let r of rows) {
      if (!r.lat || !r.lng || r.lat === 0 || r.lng === 0) {
        try {
          const { lat, lng } = await geocode(r.address);
          r.lat = lat;
          r.lng = lng;
        } catch (e) {
          console.error("Geocode failed:", r.name, e.message);
        }
      }
    }

    res.json(rows);
  });
});

// === 啟動伺服器 ===
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

