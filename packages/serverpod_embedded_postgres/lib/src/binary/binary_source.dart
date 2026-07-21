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

/// Resolves the effective [BinarySource]: an [explicit] value wins, else
/// `SERVERPOD_PG_SOURCE` from [environment] (`auto` | `download` | `build`),
/// else [BinarySource.download].
///
/// [environment] defaults to [Platform.environment]. It can be supplied by
/// callers that need to resolve the source against a specific environment.
BinarySource resolveBinarySource({
  BinarySource? explicit,
  Map<String, String>? environment,
}) {
  if (explicit != null) return explicit;
  switch ((environment ?? Platform.environment)['SERVERPOD_PG_SOURCE']
      ?.trim()
      .toLowerCase()) {
    case 'auto':
      return BinarySource.auto;
    case 'build':
      return BinarySource.build;
    default:
      return BinarySource.download;
  }
}
