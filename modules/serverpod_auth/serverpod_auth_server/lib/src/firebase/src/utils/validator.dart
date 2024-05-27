/// Validates that a string is a valid email.

bool isEmail(String? email) {
  if (email == null) return false;
  // There must at least one character before the @ symbol and another after.
  var re = RegExp(r'^[^@]+@[^@]+$');
  return re.hasMatch(email);
}

/// Validates that a string is a valid Firebase Auth uid.
bool isUid(String? uid) {
  return uid != null && uid.isNotEmpty && uid.length <= 128;
}

/// Validates that a string is a valid phone number.
bool isPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null) return false;
  // Phone number validation is very lax here. Backend will enforce E.164
  // spec compliance and will normalize accordingly.
  // The phone number string must be non-empty and starts with a plus sign.
  var re1 = RegExp(r'^\+');
  // The phone number string must contain at least one alphanumeric character.
  var re2 = RegExp(r'[\da-zA-Z]+');
  return re1.hasMatch(phoneNumber) && re2.hasMatch(phoneNumber);
}

/// Validates that a string is a valid Firebase Auth password.
bool isPassword(String? password) {
// A password must be a string of at least 6 characters.
  return password != null && password.length >= 6;
}

/// Validates that a string is a valid web URL.
bool isUrl(String? urlStr) {
  if (urlStr == null) return false;
  try {
    Uri.parse(urlStr);
    return true;
  } on FormatException {
    return false;
  }
}
