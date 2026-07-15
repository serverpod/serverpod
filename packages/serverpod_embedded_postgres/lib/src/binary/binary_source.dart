import 'dart:io';

/// Where [BinaryStore] obtains the PostgreSQL bundle.
enum BinarySource {
  /// Download the prebuilt bundle; if it isn't published yet (a definitive
  /// "not available", e.g. HTTP 404), build it from source. An advanced /
  /// development mode - the default is [download], so a missing release
  /// asset surfaces as an actionable error instead of an unexpected
  /// multi-gigabyte native build.
  auto,

  /// Download only - fail if the prebuilt bundle isn't available. (No
  /// fallback build.) The default.
  download,

  /// Always build from source, skipping the download. Requires the build
  /// toolchain (zig/cmake/make/bison/flex/perl, plus `bash`/MSYS2 on Windows).
  build,
}

/// Resolves the effective [BinarySource]: an [explicit] value wins, else the
/// `SERVERPOD_PG_SOURCE` env var (`auto` | `download` | `build`), else
/// [BinarySource.download].
BinarySource resolveBinarySource([BinarySource? explicit]) {
  if (explicit != null) return explicit;
  switch (Platform.environment['SERVERPOD_PG_SOURCE']?.trim().toLowerCase()) {
    case 'auto':
      return BinarySource.auto;
    case 'build':
      return BinarySource.build;
    default:
      return BinarySource.download;
  }
}
