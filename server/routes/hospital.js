// module.exports = router;
const express = require('express');
const router = express.Router();
const db = require('../config/db');

const axios = require('axios');
const GOOGLE_API_KEY = process.env.GOOGLE_MAPS_API_KEY;

async function getPhotoReference(placeName) {
  const url = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json`
    + `?input=${encodeURIComponent(placeName)}&inputtype=textquery&fields=photos&key=${GOOGLE_API_KEY}`;
  const res = await axios.get(url);
  return res.data.candidates?.[0]?.photos?.[0]?.photo_reference || null;
}

// === 地區清單 ===
router.get('/getDistricts', async (req, res) => {
  const city = req.query.city;
  if (!city) return res.status(400).json({ error: 'city is required' });

  const query = `SELECT DISTINCT district FROM hospital WHERE city = ?`;
  try {
    const [results] = await db.query(query, [city]);
    if (results.length === 0) {
      return res.status(404).json({ error: 'No districts found for the specified city' });
    }
    res.json(results.map(r => r.district));
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database error' });
  }
});

// === 科別清單 === 
router.get('/getDepartments', async (req, res) => {
  const { city, district } = req.query;
  if (!city || !district) {
    return res.status(400).json({ error: 'city and district are required' });
  }
  const query = `
    SELECT DISTINCT sh.department
    FROM hospital h
    JOIN s_hospital sh ON h.id = sh.fk_shospital_id
    WHERE h.city = ?
      AND h.district = ?
      AND sh.department IS NOT NULL
      AND sh.department != ''
  `;
  try {
    const [results] = await db.query(query, [city, district]);
    if (results.length === 0) {
      return res.status(404).json({ error: 'No departments found for the specified location' });
    }
    res.json(results.map(r => r.department));
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database error' });
  }
});

// === 醫院查詢 ===
router.get('/getHospitals', async (req, res) => {
  const { city, district = '', dept = '' } = req.query;
  if (!city) {
    return res.status(400).json({ error: 'city is required' });
  }
  const query = `
    SELECT DISTINCT h.id, h.name, h.city, h.district, h.address, h.lat, h.lng, h.phone
    FROM hospital h
    LEFT JOIN s_hospital sh ON h.id = sh.fk_shospital_id
    WHERE h.city = ?
      AND (? = '' OR h.district = ?)
      AND (? = '' OR sh.department = ?)
  `;
  try {
    const [rows] = await db.query(query, [city, district, district, dept, dept]);
    await Promise.all(rows.map(async r => {
      try {
        // 也可以改用 r.name 或 r.address
        r.photoReference = await getPhotoReference(r.name);
      } catch (e) {
        console.error('photoRef error', e);
        r.photoReference = null;
      }
    }));
    for (const r of rows) {
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
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database error' });
  }
});

// 伺服器端 MySQL 查詢
router.get('/hospitals/nearby', async (req, res) => {
  const { lat, lng } = req.query;
  if (!lat || !lng) {
    return res.status(400).json({ error: '缺少經緯度參數' });
  }

  try {
    const sql = `
  SELECT
    id, name, city, district, address, lat, lng, phone,
    (6371000 * ACOS(
      COS(RADIANS(?)) * COS(RADIANS(lat)) *
      COS(RADIANS(lng) - RADIANS(?)) +
      SIN(RADIANS(?)) * SIN(RADIANS(lat))
    )) AS distance_m
  FROM hospital
  ORDER BY distance_m ASC
  LIMIT 10
`;

    const [rows] = await db.query(sql, [lat, lng, lat]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '伺服器錯誤' });
  }
});
//其他API
module.exports = router;