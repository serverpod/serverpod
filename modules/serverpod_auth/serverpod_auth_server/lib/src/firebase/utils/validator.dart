/// Validates that a string is a valid Firebase Auth uid.
bool isUid(String? uid) {
  return uid != null && uid.isNotEmpty && uid.length <= 128;
}
