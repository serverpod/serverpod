/// Validates that a string is a valid Firebase Auth uid.
bool isUid(String? uid) {
  return uid != null && uid.isNotEmpty && uid.length <= 128;
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
