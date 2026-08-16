import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/zonky_archive.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('zonky_archive_test_');
  });

  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('Given a JAR shape that violates "exactly one .txz at root"', () {
    test(
      'when there is no .txz at the JAR root then BinaryFetchException is thrown.',
      () {
        var jar = _buildJar([
          ('postgres-x.txz.bak', _trivialTxz()), // wrong extension
        ]);

        expect(
          () => ZonkyArchive.extractInto(jar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
      },
    );

    test(
      'when two .txz files exist at the JAR root '
      'then BinaryFetchException is thrown.',
      () {
        var jar = _buildJar([
          ('postgres-a.txz', _trivialTxz()),
          ('postgres-b.txz', _trivialTxz()),
        ]);

        expect(
          () => ZonkyArchive.extractInto(jar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
      },
    );

    test(
      'when a .txz exists only inside a subdir '
      'then BinaryFetchException is thrown (root-level matches required).',
      () {
        var jar = _buildJar([
          ('META-INF/postgres.txz', _trivialTxz()),
        ]);

        expect(
          () => ZonkyArchive.extractInto(jar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
      },
    );
  });

  group('Given a tarball with content', () {
    // We don't re-test TarDecoder/OutputFileStream's "regular files come out
    // intact" path - that's package:archive's responsibility. The tests below
    // pin the workarounds we explicitly added on top: the deferred-symlink
    // pass and exec-bit restoration. The spike proved both were necessary.

    test(
      'when extracting a symlink entry '
      'then a real symlink is created (NOT a 0-byte regular file).',
      () {
        var tar = _buildTar([
          _TarEntry.file('lib/libfoo.1.0.dylib', Uint8List.fromList([1, 2, 3])),
          _TarEntry.symlink('lib/libfoo.1.dylib', target: 'libfoo.1.0.dylib'),
        ]);

        ZonkyArchive.extractTarballInto(tar, tmp);

        var link = Link(p.join(tmp.path, 'lib/libfoo.1.dylib'));
        expect(
          link.existsSync(),
          isTrue,
          reason: 'symlink should exist as a Link, not a regular File',
        );
        expect(
          FileSystemEntity.isLinkSync(link.path),
          isTrue,
          reason: 'must be a real symlink, not a 0-byte file',
        );
        expect(link.targetSync(), 'libfoo.1.0.dylib');
      },
      onPlatform: const {'windows': Skip('Windows symlink perms')},
    );

    test(
      'when a file entry has mode 0o755 '
      'then the extracted file is executable on POSIX.',
      () {
        var tar = _buildTar([
          _TarEntry.file(
            'bin/postgres',
            Uint8List.fromList([0]),
            mode: 0x1ED, // 0o755
          ),
        ]);

        ZonkyArchive.extractTarballInto(tar, tmp);

        var out = File(p.join(tmp.path, 'bin/postgres'));
        expect(out.existsSync(), isTrue);
        var statMode = out.statSync().mode;
        // Owner exec bit (0o100 = 0x40).
        expect(
          statMode & 0x40,
          isNot(0),
          reason: 'owner exec bit should be set after extract',
        );
      },
      onPlatform: const {'windows': Skip('POSIX exec bits not honored')},
    );

    test(
      'when a file entry name contains ../ that escapes the destination '
      'then BinaryFetchException is thrown (tar-slip).',
      () {
        var tar = _buildTar([
          _TarEntry.file('../escape.txt', Uint8List.fromList([1])),
        ]);

        expect(
          () => ZonkyArchive.extractTarballInto(tar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
        expect(
          File(p.join(tmp.parent.path, 'escape.txt')).existsSync(),
          isFalse,
          reason: 'sibling-dir file must not be created',
        );
      },
    );

    test(
      'when a file entry name is an absolute path '
      'then BinaryFetchException is thrown.',
      () {
        // POSIX absolute - on Windows package:path treats /etc/... as
        // root-relative-to-current-drive, which still won't be inside tmp.
        var tar = _buildTar([
          _TarEntry.file('/etc/passwd', Uint8List.fromList([1])),
        ]);

        expect(
          () => ZonkyArchive.extractTarballInto(tar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
      },
    );

    test(
      'when a symlink target resolves outside the destination '
      'then BinaryFetchException is thrown (symlink-traversal).',
      () {
        var tar = _buildTar([
          _TarEntry.file('lib/real.txt', Uint8List.fromList([1])),
          _TarEntry.symlink(
            'lib/escape',
            target: '../../../../etc/passwd',
          ),
        ]);

        expect(
          () => ZonkyArchive.extractTarballInto(tar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
        expect(
          Link(p.join(tmp.path, 'lib/escape')).existsSync(),
          isFalse,
          reason: 'escaping symlink must not be created',
        );
      },
      onPlatform: const {'windows': Skip('Windows symlink perms')},
    );

    test(
      'when a symlink target is an absolute path '
      'then BinaryFetchException is thrown.',
      () {
        var tar = _buildTar([
          _TarEntry.symlink('boom', target: '/etc/passwd'),
        ]);

        expect(
          () => ZonkyArchive.extractTarballInto(tar, tmp),
          throwsA(isA<BinaryFetchException>()),
        );
      },
      onPlatform: const {'windows': Skip('Windows symlink perms')},
    );

    test('when extracting then onProgress is called and ends at 1.0.', () {
      var tar = _buildTar([
        for (var i = 0; i < 50; i++)
          _TarEntry.file('f$i', Uint8List.fromList([i])),
      ]);
      var fractions = <double>[];

      ZonkyArchive.extractTarballInto(tar, tmp, onProgress: fractions.add);

      expect(fractions, isNotEmpty);
      expect(fractions.last, 1.0);
      expect(fractions.every((f) => f >= 0.0 && f <= 1.0), isTrue);
    });
  });
}

class _TarEntry {
  final String name;
  final Uint8List content;
  final bool isSymbolicLink;
  final String? linkTarget;
  final int mode;

  _TarEntry.file(this.name, this.content, {this.mode = 0x1A4 /* 0o644 */})
    : isSymbolicLink = false,
      linkTarget = null;

  _TarEntry.symlink(this.name, {required String target})
    : content = Uint8List(0),
      isSymbolicLink = true,
      linkTarget = target,
      mode = 0x1FF /* 0o777 */;
}

/// Builds a raw `.tar` (no compression) - tests that exercise the
/// tar-to-disk seam call this and pass to [ZonkyArchive.extractTarballInto].
Uint8List _buildTar(List<_TarEntry> entries) {
  var archive = Archive();
  for (var e in entries) {
    var f = ArchiveFile(e.name, e.content.length, e.content)..mode = e.mode;
    if (e.isSymbolicLink) {
      // archive 3.x exposes isSymbolicLink + nameOfLinkedFile as settable
      // fields; archive 4.x replaced them with a `symbolicLink: String?`
      // setter (and isSymbolicLink became computed). Set via dynamic to
      // build correctly under whichever version melos resolves.
      _markAsSymlink(f, e.linkTarget!);
    }
    archive.addFile(f);
  }
  return Uint8List.fromList(TarEncoder().encode(archive));
}

void _markAsSymlink(ArchiveFile f, String target) {
  final dynamic d = f;
  // archive 4.x path - one setter, isSymbolicLink follows.
  try {
    // ignore: avoid_dynamic_calls
    d.symbolicLink = target;
    return;
  } on NoSuchMethodError {
    // fall through to archive 3.x.
  }
  // archive 3.x path - two settable fields.
  // ignore: avoid_dynamic_calls
  d.isSymbolicLink = true;
  // ignore: avoid_dynamic_calls
  d.nameOfLinkedFile = target;
}

Uint8List _buildJar(List<(String, Uint8List)> entries) {
  var archive = Archive();
  for (var (name, bytes) in entries) {
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }
  var zipBytes = ZipEncoder().encode(archive);
  return Uint8List.fromList(zipBytes);
}

/// Returns opaque bytes used as `.txz` payload in JAR-shape tests. The
/// shape tests never get past the "exactly one .txz at root" check, so the
/// payload is never XZ-decoded - any bytes work.
Uint8List _trivialTxz() => Uint8List.fromList(const [0xFD, 0x37, 0x7A, 0x58]);
