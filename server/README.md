# Server

#uploads是放使用者傳入圖片的檔案

#撰寫順序:在server.js中撰寫api => 測試api沒問題後在flutter中撰寫能連上伺服器api的程式碼

#串後端資料時伺服器要一直保持開啟的狀態，否則無法讀寫資料

#開啟伺服器:node server.js

#檔案開啟後記得加入.env檔【JWT_SECRET】、【REFRESH_SECRET_KEY】在群組記事本