class ApiBase {
  static const String baseUrl = 'http://192.168.1.109:3000';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    // 可加入 token 認證邏輯
  };
}
