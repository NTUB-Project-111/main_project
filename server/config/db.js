const mysql = require('mysql2');

// === MySQL 資料庫設定 ===
const pool = mysql.createPool({
  host: '140.131.114.242',
  user: 'rootdrwnew',
  password: 'New8888@',
  database: '114-Drw_New',
  waitForConnections: true,
  connectionLimit: 10, //最大連線數
  queueLimit: 0 //允許無限等待
});

//將這個物件匯出，讓其他檔案可以透過require('./db')的方式來使用它
module.exports = pool.promise(); 