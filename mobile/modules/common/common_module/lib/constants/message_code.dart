class MessageCode {
  MessageCode._();

  static const String BAD_REQUEST = "BAD_REQUEST";

  // Username exist in system
  static const String USER_EXIST = "USER_EXIST";

  // Username does not exist in system
  static const String USER_NOT_EXIST = "USER_NOT_EXIST";

  // Reset password success
  static const String RESET_PASSWORD_SUCCESS = "RESET_PASSWORD_SUCCESS";

  // Login success
  static const String LOGIN_SUCCESS = "LOGIN_SUCCESS";

  // Register success
  static const String REGISTER_SUCCESS = "REGISTER_SUCCESS";

  // Verify OTP success
  static const String VERIFY_OTP_SUCCESS = "VERIFY_OTP_SUCCESS";

  // Send OTP success
  static const String SEND_OTP_SUCCESS = "SEND_OTP_SUCCESS";

  // Send OTP too quickly
  static const String SEND_OTP_TOO_QUICKLY = "SEND_OTP_TOO_QUICKLY";

  static const String INCORRECT_OTP = "INCORRECT_OTP";

  // Banned
  static const String USER_LOCKED = "USER_LOCKED";

  static const String LIVE_SESSION_NOT_ALIVE = "LIVE_SESSION_NOT_ALIVE";

  static const String LIVE_SESSION_NOT_FOUND = "LIVE_SESSION_NOT_FOUND";

  static const String LIVE_SESSION_ALIVE_ERROR = "LIVE_SESSION_ALIVE_ERROR";

  static const String LIVE_STREAM_CHANNEL_CAN_NOT_CREATE = "LIVE_STREAM_CHANNEL_CAN_NOT_CREATE";

  static const String LIVE_SERVER_NOT_ALIVE = "LIVE_SERVER_NOT_ALIVE";

  static const String LIVE_SESSION_RESUMED = "LIVE_SESSION_RESUMED";

  static const String UPDATE_IDOL_SUCCESS = "UPDATE_IDOL_SUCCESS";

  static const String NICK_NAME_EXIST = "NICK_NAME_EXIST";

  static const String LINK_ACCOUNT_SUCCESS = 'LINK_ACCOUNT_SUCCESS';

  static const String LINK_ACCOUNT_EXISTING = 'LINK_ACCOUNT_EXISTING';

  static const String USER_NOT_FOUND = 'USER_NOT_FOUND';

  static const String PASSWORD_INCORRECT = 'PASSWORD_INCORRECT';
}