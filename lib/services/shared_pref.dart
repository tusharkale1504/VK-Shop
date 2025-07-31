import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPhoneKey = "USERPHONEKEY";
  static String userImageKey = "USERIMAGEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, email);
    print("✅ Saved email: $email");
  }

  Future<bool> saveUserPhone(String getUSerPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneKey, getUSerPhone);
  }

  Future<bool> saveUserImage(String getUSerImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUSerImage);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(userEmailKey);
    print("🔍 Fetched email: ${email ?? '❌ None'}");
    return email;
  }

  Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhoneKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userEmailKey);
    print("🗑️ User email cleared");
  }
}