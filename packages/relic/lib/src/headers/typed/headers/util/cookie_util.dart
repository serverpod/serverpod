/// Validates the cookie name and returns a string representation of the cookie name.
String validateCookieName(String name) {
  // Allow empty names
  if (name.isEmpty) return name;

  // Disallowed characters (separators)
  const separators = {
    "(",
    ")",
    "<",
    ">",
    "@",
    ",",
    ";",
    ":",
    "\\",
    '"',
    "/",
    "[",
    "]",
    "?",
    "=",
    "{",
    "}"
  };

  for (int i = 0; i < name.length; i++) {
    int codeUnit = name.codeUnitAt(i);

    // Disallow control characters, non-ASCII characters, and reserved separators
    if (
        // Disallows ASCII control characters (code points 0-32), including spaces, tabs, and other non-printable characters
        codeUnit <= 32 ||
            // Disallows non-ASCII characters (code points 127 and above), ensuring only standard ASCII is used
            codeUnit >= 127 ||
            // Disallows reserved separator characters [separators], based on RFC 6265
            separators.contains(name[i])) {
      throw FormatException("Invalid cookie name");
    }
  }

  return name;
}

/// Validates the cookie value and returns a string representation of the cookie value.
String validateCookieValue(String value) {
  // Allow empty values
  if (value.isEmpty) return value;

  // Check for quoted strings
  int start = 0;
  int end = value.length;

  if (value.length >= 2 &&
      // Starting with '"'
      value.codeUnitAt(start) == 0x22 &&
      // Ending with '"'
      value.codeUnitAt(end - 1) == 0x22) {
    start++;
    end--;
  }

  // Validate characters inside the string
  for (int i = start; i < end; i++) {
    int codeUnit = value.codeUnitAt(i);

    if (!(
        // '!' (ASCII 33) is allowed
        codeUnit == 0x21 ||
            // '#' (35) to '+' (43) are allowed, including symbols like '#', '$', '%', '&', and '+'
            (codeUnit >= 0x23 && codeUnit <= 0x2B) ||
            // '-' (45) to ':' (58) are allowed, covering '-', '.', '/', '0-9', and ':'
            (codeUnit >= 0x2D && codeUnit <= 0x3A) ||
            // '<' (60) to '[' (91) are allowed, covering '<', '=', '>', '?', '@', 'A-Z', and '['
            (codeUnit >= 0x3C && codeUnit <= 0x5B) ||
            // ']' (93) to '~' (126) are allowed, covering ']', '^', '_', '`', 'a-z', '{', '|', '}', and '~'
            (codeUnit >= 0x5D && codeUnit <= 0x7E))) {
      throw FormatException("Invalid cookie value");
    }
  }

  return Uri.decodeComponent(value);
}
