import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../exceptions.dart';

/// Extract Zonky's PG binaries from a JAR's bytes into a destination
/// directory.
///
/// The JAR (a zip) contains a single `.txz` at its root; the txz is
/// LZMA2/XZ-compressed tar of the PG binary tree.
///
/// Two patterns required for correctness, both validated by the spike:
///
///   1. **Defer symbolic links to a second pass** and create them via
///      [Link]. Writing them as files yields 0-byte regular files and
///      breaks PG's versioned dylib chain (e.g.
///      `libicudata.68.dylib` -> `libicudata.68.2.dylib`), causing
///      `dyld: Library not loaded` at the first `initdb` invocation.
///
///   2. **Restore TAR exec bits** after writing each file -
///      [OutputFileStream] creates files with the default umask mode
///      (0644 typically), losing any +x set in the TAR header. On Windows
///      this is a no-op (POSIX exec bits aren't honored).
class ZonkyArchive {
  /// Extracts [jarBytes] into [destination] (created if needed).
  ///
  /// Reports progress (0.0..1.0) via [onProgress] roughly once per percent
  /// of TAR entries written. The final 1.0 fires after the symlink pass
  /// completes.
  static void extractInto(
    Uint8List jarBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  }) {
    destination.createSync(recursive: true);

    var txzBytes = _extractInnerTxz(jarBytes);
    // verify=false: the BinaryStore layer SHA-256s the entire JAR before we
    // ever reach this code, which transitively covers the inner txz. Skipping
    // XZ's per-stream CRC saves ~5% on cold start; we trust sha256 instead.
    var tarBytes = XZDecoder().decodeBytes(txzBytes);
    extractTarballInto(
      Uint8List.fromList(tarBytes),
      destination,
      onProgress: onProgress,
    );
  }

  /// Tar-to-disk seam, exposed so tests can build TAR fixtures directly
  /// without going through the XZ layer (`package:archive` 3.6.x's
  /// XZEncoder/XZDecoder roundtrip is not stable enough for synthetic
  /// fixtures - real Zonky XZ output decodes fine, our own encoder's does
  /// not).
  ///
  /// Production callers should use [extractInto], which handles the full
  /// JAR-to-disk chain.
  @visibleForTesting
  static void extractTarballInto(
    Uint8List tarBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  }) {
    destination.createSync(recursive: true);

    var tar = TarDecoder().decodeBytes(tarBytes);

    var symlinks = <ArchiveFile>[];
    var entries = tar.files;
    var total = entries.length;
    var stride = total > 100 ? (total ~/ 100) : 1;
    var written = 0;

    for (var entry in entries) {
      var outPath = p.join(destination.path, entry.name);

      if (entry.isSymbolicLink) {
        symlinks.add(entry);
      } else if (entry.isFile) {
        Directory(p.dirname(outPath)).createSync(recursive: true);
        var out = OutputFileStream(outPath);
        entry.writeContent(out);
        out.closeSync();
        if ((entry.mode & 0x49) != 0) {
          _setExecutable(outPath);
        }
      } else {
        // Directory entry. OutputFileStream above creates parent dirs as
        // needed; explicit dir entries cover empty dirs in the archive.
        Directory(outPath).createSync(recursive: true);
      }

      written++;
      if (onProgress != null && (written % stride == 0)) {
        onProgress(written / total);
      }
    }

    // Second pass: links resolve correctly now that all targets exist.
    for (var entry in symlinks) {
      var outPath = p.join(destination.path, entry.name);
      var target = entry.nameOfLinkedFile;
      if (target.isEmpty) {
        throw BinaryFetchException(
          'Symbolic link ${entry.name} has empty target string in TAR.',
        );
      }
      var link = Link(outPath);
      if (link.existsSync() || File(outPath).existsSync()) {
        link.deleteSync();
      }
      link.createSync(target);
    }

    onProgress?.call(1.0);
  }

  /// Locates the single `.txz` at the JAR's root and returns its bytes.
  ///
  /// Zonky's inner txz filename does NOT match the outer artifact's
  /// `<platform>-<arch>` suffix - e.g. `darwin-amd64.jar` contains
  /// `postgres-darwin-x86_64.txz`. So we glob for the single root-level
  /// `.txz` rather than constructing the name.
  static Uint8List _extractInnerTxz(Uint8List jarBytes) {
    var zip = ZipDecoder().decodeBytes(jarBytes);
    var candidates = zip.files
        .where(
          (f) => f.isFile && f.name.endsWith('.txz') && !f.name.contains('/'),
        )
        .toList();
    if (candidates.length != 1) {
      var names = candidates.map((e) => e.name).join(', ');
      throw BinaryFetchException(
        'Expected exactly one .txz at JAR root, found ${candidates.length}'
        '${names.isEmpty ? "" : ": $names"}.',
      );
    }
    return Uint8List.fromList(candidates.single.content as List<int>);
  }

  /// Sets the executable bit on [path]. POSIX-only - on Windows this is a
  /// no-op (the OS doesn't honor POSIX exec bits; .exe is by extension).
  static void _setExecutable(String path) {
    if (Platform.isWindows) return;
    var res = Process.runSync('chmod', ['+x', path]);
    if (res.exitCode != 0) {
      throw BinaryFetchException(
        'chmod +x failed for $path (exit ${res.exitCode}): ${res.stderr}',
      );
    }
  }
}
