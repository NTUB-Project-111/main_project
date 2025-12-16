require('dotenv').config(); //將.env 檔案中的環境變數載入到 Node.js 的 process.env 中
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use('/uploads', express.static('uploads')); //使前端可以存取圖片
app.use(express.json());

const authRoutes = require('./routes/auth');
app.use('/', authRoutes);

const userRoutes = require('./routes/user');
app.use('/', userRoutes);

const recordRoutes = require('./routes/record');
app.use('/', recordRoutes);

const callRoutes = require('./routes/call');
app.use('/', callRoutes);

const hospitalRoutes = require('./routes/hospital');
app.use('/', hospitalRoutes);

const familyRoutes = require('./routes/family');
app.use('/', familyRoutes);

app.get('/', (req, res) => {
  res.send(' Server is running!');
});

app.listen(PORT, () => {
  console.log(` Server running at http://localhost:${PORT}`);
});
