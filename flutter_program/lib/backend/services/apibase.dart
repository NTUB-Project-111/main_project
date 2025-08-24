class ApiBase {
  // static const String baseUrl = 'http://192.168.1.109:3000';
  
  //static const String baseUrl = 'https://dr-w.onrender.com';
  static const String baseUrl = 'http://192.168.0.150:3000';
  //11146002 自己的內網測試
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    // 可加入 token 認證邏輯
  };
}
