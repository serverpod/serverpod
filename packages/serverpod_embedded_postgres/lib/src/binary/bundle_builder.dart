import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;

import '../exceptions.dart';

/// Builds the Serverpod PostgreSQL bundle from source by driving the scripts in
/// `tool/build_postgres/` (Zig as the C/C++ compiler). Used as the fallback
/// when the prebuilt bundle isn't published, or when a build is forced via
/// [BinarySource.build].
///
/// Requires the build toolchain on PATH: zig 0.16.x, cmake, pkg-config, make,
/// bison, flex, perl, curl, tar/xz - and `bash` (MSYS2 on Windows). The scripts
/// are found relative to this package; override their location with the
/// `SERVERPOD_PG_BUILD_DIR` env var (e.g. for AOT/compiled consumers where
/// package resolution is unavailable).
class BundleBuilder {
  /// Creates a [BundleBuilder].
  const BundleBuilder();

  /// Builds the bundle for [bom] (`major.minor.patch`) and [platform]
  /// (`<os>-<arch>`), returning the produced `.tar.xz`. Build output streams to
  /// this process's stdout/stderr. Throws [BinaryBuildException] on any failure
  /// (missing toolchain, missing scripts, non-zero build, or no artifact).
  Future<File> build({required String bom, required String platform}) async {
    var toolDir = await _toolDir();
    var script = File(p.join(toolDir.path, 'build-all.sh'));
    if (!script.existsSync()) {
      throw BinaryBuildException(
        'build script not found at ${script.path}; set SERVERPOD_PG_BUILD_DIR '
        'to the tool/build_postgres directory.',
      );
    }
    // The build scripts need a Unix shell + autotools. On Windows the default
    // `bash` is Git Bash (no make/autotools); point SERVERPOD_PG_BUILD_BASH at
    // MSYS2's bash (e.g. C:\msys64\usr\bin\bash.exe) there.
    var bash = Platform.environment['SERVERPOD_PG_BUILD_BASH'];
    if (bash == null || bash.isEmpty) bash = 'bash';
    if (!await _onPath(bash)) {
      throw BinaryBuildException(
        'building the embedded PostgreSQL bundle from source requires '
        '`$bash` (plus zig, cmake, make, bison, flex, perl). On Windows '
        'install MSYS2 and set SERVERPOD_PG_BUILD_BASH to its bash.',
      );
    }

    // platform is "<os>-<arch>"; arch may itself contain a dash in theory, so
    // split only on the first.
    var dash = platform.indexOf('-');
    var os = dash < 0 ? platform : platform.substring(0, dash);
    var arch = dash < 0 ? '' : platform.substring(dash + 1);

    var scratch = Directory.systemTemp.createTempSync('serverpod-pg-build-');
    var proc = await Process.start(
      bash,
      [script.path],
      environment: {
        ...Platform.environment,
        'PGBUILD': scratch.path,
        'BUNDLE_OS': os,
        'BUNDLE_ARCH': arch,
        'PG_VERSION': bom,
      },
      mode: ProcessStartMode.inheritStdio,
    );
    var code = await proc.exitCode;
    if (code != 0) {
      throw BinaryBuildException('local bundle build failed (exit $code).');
    }
    var bundle = File(
      p.join(scratch.path, 'dist', 'serverpod-postgres-$bom-$platform.tar.xz'),
    );
    if (!bundle.existsSync()) {
      throw BinaryBuildException(
        'build completed but produced no bundle at ${bundle.path}.',
      );
    }
    return bundle;
  }

  Future<Directory> _toolDir() async {
    var override = Platform.environment['SERVERPOD_PG_BUILD_DIR'];
    if (override != null && override.isNotEmpty) return Directory(override);
    var uri = await Isolate.resolvePackageUri(
      Uri.parse(
        'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart',
      ),
    );
    if (uri == null || !uri.isScheme('file')) {
      throw const BinaryBuildException(
        'cannot locate the build scripts; set SERVERPOD_PG_BUILD_DIR to the '
        'tool/build_postgres directory.',
      );
    }
    // <root>/lib/serverpod_embedded_postgres.dart -> <root>
    var pkgRoot = File.fromUri(uri).parent.parent;
    return Directory(p.join(pkgRoot.path, 'tool', 'build_postgres'));
  }

  Future<bool> _onPath(String exe) async {
    // An explicit path (e.g. SERVERPOD_PG_BUILD_BASH) - check the file directly.
    if (exe.contains('/') || exe.contains(r'\')) {
      return File(exe).existsSync() || File('$exe.exe').existsSync();
    }
    try {
      var r = await Process.run(Platform.isWindows ? 'where' : 'which', [exe]);
      return r.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}
