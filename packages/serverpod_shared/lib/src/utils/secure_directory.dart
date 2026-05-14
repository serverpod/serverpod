import 'dart:io';

/// Atomically ensures a directory exists at [path] with mode 0700 on
/// POSIX (and an owner-restricted ACL on Windows). No-op if [path]
/// already exists.
///
/// On POSIX, a plain [Directory.createSync] derives the new directory's
/// mode from `0777 & ~umask`. With the typical desktop umask of 0022
/// that yields 0755, leaving anything inside world-readable - a problem
/// for trust-authenticated Unix domain sockets and other secrets that
/// rely on filesystem permissions.
///
/// [Directory.createTempSync] is specified to call `mkdtemp(3)`, which
/// always creates with mode 0700. We then `rename(2)` into place: the
/// syscall preserves the inode (and therefore the mode) and avoids a
/// separate `chmod` step that Dart's [Directory] API doesn't expose
/// without shelling out. On `EEXIST` we lose a race against another
/// process that created [path] first; the existing directory is trusted.
///
/// macOS and Windows already give each user a private parent directory
/// (`~/Library/...`, `%LOCALAPPDATA%`), so the mode tightening is
/// primarily a Linux hardening - but the same code path runs everywhere.
void ensureSecureDirectorySync(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) return;

  final parent = dir.parent;
  parent.createSync(recursive: true);
  final temp = parent.createTempSync('secure_init_');
  try {
    temp.renameSync(path);
  } on FileSystemException {
    if (temp.existsSync()) temp.deleteSync(recursive: true);
    if (!dir.existsSync()) rethrow;
  }
}
