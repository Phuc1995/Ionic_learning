import 'package:email_validator/email_validator.dart';

class StringValidate {
  static RegExp _numeric = RegExp(r'^-?[0-9]+$');
  static RegExp _alphabetsVN = RegExp(r'^[a-zA-Z0-9 àáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+$');
  static RegExp _alphabetsVNComma = RegExp(r'^[a-zA-Z0-9, àáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ,]+$');
  static RegExp _alphabets = RegExp(r'^[a-zA-Z0-9]+$');
  static RegExp _phoneNumber = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  static RegExp _viewerID= RegExp(r'^(?=.*[a-zA-Z])([a-zA-Z0-9_.]+)$');
  static RegExp _email= RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool isEmpty(String? value){
    if (value == null || value.isEmpty || value.trim() == "") {
      return true;
    }
    return false;
  }

  static bool isNumeric(String value) {
    return _numeric.hasMatch(value);
  }

  static bool isAlphabets(String value) {
    return _alphabetsVN.hasMatch(value);
  }

  static bool isAlphabetsComma(String value) {
    return _alphabetsVNComma.hasMatch(value);
  }

  static bool isAlphabetsEN(String value) {
    return _alphabets.hasMatch(value);
  }

  static bool isPhoneNumber(String value){
    return _phoneNumber.hasMatch(value);
  }

  static bool isViewerID(String value){
    return _viewerID.hasMatch(value);
  }

  static bool isPhoneNumberWithCode(String code, String phone) {
    // Null or empty string is invalid phone number
    // The minimum length is 4 for Saint Helena (Format: +290 XXXX) and Niue (Format: +683 XXXX).
    if (code.trim().isEmpty || phone.trim().isEmpty || phone.trim().length < 8 || phone.trim().length > 15) {
      return false;
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(code+phone)) {
      return false;
    }
    return true;
  }

  static bool isEmail(String value) {
    return EmailValidator.validate(value);
  }
}
