// const multer = require('multer');
// const path = require('path');

// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, 'uploads/');
//   },
//   filename: function (req, file, cb) {
//     const uniqueName = Date.now() + '-' + Math.round(Math.random() * 1e9);
//     const ext = path.extname(file.originalname);
//     cb(null, uniqueName + ext);
//   }
// });

// const upload = multer({ storage });

// module.exports = upload;

const multer = require('multer');
const { v2: cloudinary } = require('cloudinary');
const { Readable } = require('stream');

// 使用 memoryStorage 讓 multer 把圖片存進 buffer（才能傳給 Cloudinary）
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Cloudinary 設定
cloudinary.config({
  cloud_name:'dp6nv22vo',
  api_key:'446548531346232',
  api_secret:process.env.CLOUDINAEY_SECRET
});

// 將 buffer 上傳到 Cloudinary
const uploadToCloudinary = (buffer, filename) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { public_id: filename, folder: 'user_uploads' },
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
    Readable.from(buffer).pipe(stream);
  });
};

module.exports = { upload, uploadToCloudinary };

