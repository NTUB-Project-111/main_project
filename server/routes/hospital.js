const express = require('express');
const router = express.Router();
const db = require('../config/db');

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

//其他API


module.exports = router;