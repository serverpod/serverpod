import 'dart:io';

import 'package:serverpod_embedded_postgres/src/binary/serverpod_bundle.dart';
import 'package:test/test.dart';

/// Guards the user-facing docs against drifting back to target names that
/// `prefetch --target` rejects (finding: the docs shipped Zonky's
/// `linux-amd64`/`darwin-arm64v8` names after the artifact naming moved to
/// the Serverpod `<os>-<arch>` scheme).
void main() {
  group('Given the user-facing documentation and prefetch CLI help', () {
    final documentedFiles = ['README.md', 'PLATFORMS.md', 'bin/prefetch.dart'];
    final targetPattern = RegExp(
      r'\b(?:linux|macos|windows|darwin)-(?:x64|arm64|amd64|arm64v8|x86_64)\b',
    );

    for (var path in documentedFiles) {
      test(
        'when scanning $path for platform targets, '
        'then every mentioned target is a published bundle suffix.',
        () {
          var content = File(path).readAsStringSync();
          var mentioned = targetPattern
              .allMatches(content)
              .map((m) => m.group(0)!)
              .toSet();

          expect(
            mentioned.difference(serverpodPlatformSuffixes),
            isEmpty,
            reason:
                '$path documents platform targets that prefetch would '
                'reject; valid targets: ${serverpodPlatformSuffixes.join(', ')}',
          );
        },
      );
    }
  });
}
