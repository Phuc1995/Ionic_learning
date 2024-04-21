import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/preferences.dart';

class SharedPreferenceHelper {

  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  static Future<SharedPreferenceHelper> getInstance() async {
    return SharedPreferenceHelper(await SharedPreferences.getInstance());
  }

  Future<bool> clearAll() async {
    return _sharedPreference.clear();
  }

  Future<void> reload() async {
    await _sharedPreference.reload();
  }

  // General Methods: ----------------------------------------------------------
  String? get accessToken {
    return _sharedPreference.getString(Preferences.access_token);
  }

  Future<bool> setAccessToken(String authToken) {
    return _sharedPreference.setString(Preferences.access_token, authToken);
  }

  Future<bool> removeAccessToken() {
    return _sharedPreference.remove(Preferences.access_token);
  }

  String? get refreshToken {
    return _sharedPreference.getString(Preferences.refresh_token);
  }

  Future<bool> setRefreshToken(String refreshToken) {
    return _sharedPreference.setString(Preferences.refresh_token, refreshToken);
  }

  Future<bool> removeRefreshToken() {
    return _sharedPreference.remove(Preferences.refresh_token);
  }

  String get firebaseToken {
    return _sharedPreference.getString(Preferences.firebase_token)??'';
  }

  Future<bool> setFirebaseToken(String token) {
    return _sharedPreference.setString(Preferences.firebase_token, token);
  }

  // Login:---------------------------------------------------------------------
  bool get isLoggedIn {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  Future<bool> setIsLoggedIn(bool value) {
    return _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  // isNewUser:---------------------------------------------------------------------
  bool get isNewUser {
    return _sharedPreference.getBool(Preferences.is_new) ?? false;
  }

  Future<bool> setIsNewUser(bool value) {
    return _sharedPreference.setBool(Preferences.is_new, value);
  }

  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  Future<bool> setIsDarkMode(bool value) {
    return _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.current_language);
  }

  Future<void> setLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language);
  }

  //register:---------------------------------------------------
  String? get formEmail {
    return _sharedPreference.getString(Preferences.form_email);
  }

  Future<bool> setFormEmail(String email) {
    return _sharedPreference.setString(Preferences.form_email, email);
  }

  String? get formPhoneCode {
    return _sharedPreference.getString(Preferences.form_phone_code);
  }

  Future<bool> setFormPhoneCode(String phoneCode) {
    return _sharedPreference.setString(Preferences.form_phone_code, phoneCode);
  }

  String? get formPhone {
    return _sharedPreference.getString(Preferences.form_phone);
  }

  Future<bool> setFormPhone(String phone) {
    return _sharedPreference.setString(Preferences.form_phone, phone);
  }

  String get gatewayServer {
    return _sharedPreference.getString(Preferences.gateway_server) ?? dotenv.env['GATEWAY_SERVER']!;
  }

  Future<bool> setGatewayServer(String value) {
    return _sharedPreference.setString(Preferences.gateway_server, value);
  }

  String get storageServer {
    return _sharedPreference.getString(Preferences.storage_server) ?? dotenv.env['STORAGE_SERVER']!;
  }

  Future<bool> setStorageServer(String value) {
    return _sharedPreference.setString(Preferences.storage_server, value);
  }

  String get bucketName {
    return _sharedPreference.getString(Preferences.bucket_name) ?? dotenv.env['ENV_NAME']!;
  }

  Future<bool> setBucketName(String value) {
    return _sharedPreference.setString(Preferences.bucket_name, value);
  }

  String? get registeredID {
    return _sharedPreference.getString(Preferences.registered_id);
  }

  Future<bool> setRegisteredID(String data) {
    return _sharedPreference.setString(Preferences.registered_id, data);
  }

  String? get avatarUpdate {
    return _sharedPreference.getString(Preferences.avatar);
  }

  Future<bool> setAvatar(String avatar) {
    return _sharedPreference.setString(Preferences.avatar, avatar);
  }

  String get supportEmail {
    return dotenv.env['SUPPORT_EMAIL']!;
  }

  String? get thumbnail {
    return _sharedPreference.getString(Preferences.thumbnail);
  }

  Future<bool> setThumbnail(String path) {
    return _sharedPreference.setString(Preferences.thumbnail, path);
  }

  String? get armorial {
    return _sharedPreference.getString(Preferences.armorial_url);
  }

  Future<bool> setArmorial(String armorial) {
    return _sharedPreference.setString(Preferences.armorial_url, armorial);
  }

  String get getUserUuid {
    return _sharedPreference.getString(Preferences.user_uuid)??'';
  }

  Future<bool> setUserUuid(String uuid) {
    return _sharedPreference.setString(Preferences.user_uuid, uuid);
  }

  Future<bool> setWcSession(String uri) {
    return _sharedPreference.setString(Preferences.wc_session, uri);
  }

  String get getWcSession {
    return _sharedPreference.getString(Preferences.wc_session)??'';
  }

  String? get getUserNameSupport {
    return _sharedPreference.getString(Preferences.user_name_support);
  }

  Future<bool> setUserNameSupport(String name) {
    return _sharedPreference.setString(Preferences.user_name_support, name);
  }

  String? get getUserMailSupport {
    return _sharedPreference.getString(Preferences.user_mail_support);
  }

  Future<bool> setUserMaiSupport(String mail) {
    return mail.isEmpty ? _sharedPreference.setString(Preferences.user_mail_support, "@gmail.com") : _sharedPreference.setString(Preferences.user_mail_support, mail);
  }

  Future<bool> setNotificationLive(bool value) {
    return _sharedPreference.setBool(Preferences.notification_live, value);
  }

  bool get getNotificationLive {
    return _sharedPreference.getBool(Preferences.notification_live)??true;
  }

  String getStorageUrl(){
    return this.storageServer + '/' + this.bucketName + '/';
  }
}
