class Auth {
  //驗證電子郵件格式
  static bool validateEmail(String value) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(value);
  }

  //驗證密碼格式
  static bool validatePassword(String value) {
    if (value.length < 8 || value.length > 16) {
      return false;
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$');
    if (!passwordRegex.hasMatch(value)) {
      return false;
    }
    return true;
  }

  //驗證密碼是否一致
  static bool verifyPassword(String value1, String value2) {
    return value1 == value2;
  }

  //驗證驗證碼格式
  static bool validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) return false;
    if (value.length != 6) return false;
    return true;
  }
}
