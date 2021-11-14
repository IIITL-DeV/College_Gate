import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userroom = "USERROOM";
  static String userphone = "USERPHONE";
  static String useridcard = "USERIDCARD";
  static String userProfilePicKey = "USERPROFILEPICKEY";

//save data
  Future<bool> saveroom(String? room) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userroom, room!);
  }

  Future<bool> savephone(String? phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userphone, phone!);
  }

  Future<bool> saveidcard(String? idcard) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userphone, idcard!);
  }

  Future<bool> saveUserName(String? userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName!);
  }

  Future<bool> saveUserEmail(String? useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, useremail!);
  }

  Future<bool> saveUserId(String? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId!);
  }

  Future<bool> saveDisplayName(String? displayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, displayName!);
  }

  Future<bool> saveUserProfileUrl(String? userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, userProfile!);
  }

  //get data
  Future<String?> getUseridcard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(useridcard);
  }

  Future<String?> getUserroom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userroom);
  }

  Future<String?> getUserphone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userphone);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}
