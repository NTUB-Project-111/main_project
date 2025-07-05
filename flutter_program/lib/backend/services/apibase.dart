class ApiBase {
  static const String baseUrl = 'https://dr-w.onrender.com';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    // 可加入 token 認證邏輯
  };
}
