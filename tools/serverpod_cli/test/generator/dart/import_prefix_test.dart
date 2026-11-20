import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:test/test.dart';

/// Two URLs found by birthday search over [importPrefixFor] to share a prefix.
///
/// [laterCollidingUrl] is the one that sorts last, which is what decides which
/// of the two keeps the prefix they both hash to. Hard coded on purpose: the
/// hash is frozen, so if these two stop colliding the hash changed.
const collidingUrl = 'package:p173851/lib173851.dart';
const laterCollidingUrl = 'package:p271239/lib271239.dart';

void main() {
  group('Given the URLs that generated code imports most often,', () {
    // Spelled out rather than read back from the generator: these prefixes
    // appear in every generated file of every Serverpod project, so changing
    // one rewrites all of that code.
    const reservedPrefixes = {
      'package:serverpod/serverpod.dart': '_is',
      'package:serverpod/protocol.dart': '_isp',
      'package:serverpod_client/serverpod_client.dart': '_isc',
      'package:serverpod_service_client/serverpod_service_client.dart': '_issc',
      'package:serverpod_database/serverpod_database.dart': '_isd',
      'package:serverpod_serialization/serverpod_serialization.dart': '_iss',
      'package:serverpod_shared/serverpod_shared.dart': '_issh',
      'package:serverpod_test/serverpod_test.dart': '_ist',
      'package:serverpod_test/serverpod_test_public_exports.dart': '_istp',
      'dart:async': '_ida',
      'dart:convert': '_idc',
      'dart:io': '_idi',
      'dart:typed_data': '_idt',
      'package:serverpod_auth_core_server/serverpod_auth_core_server.dart':
          '_iacs',
      'package:serverpod_auth_core_client/serverpod_auth_core_client.dart':
          '_iacc',
      'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart':
          '_iais',
      'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart':
          '_iaic',
      'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart':
          '_iabs',
      'package:serverpod_auth_bridge_client/serverpod_auth_bridge_client.dart':
          '_iabc',
      'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart':
          '_iams',
      'package:serverpod_auth_migration_client/serverpod_auth_migration_client.dart':
          '_iamc',
    };

    test(
      'when getting the import prefix for each, '
      'then each is the short prefix reserved for that URL.',
      () {
        expect({
          for (var url in reservedPrefixes.keys) url: importPrefixFor(url),
        }, reservedPrefixes);
      },
    );

    test(
      'when getting the import prefix for each, '
      'then no two URLs share a prefix.',
      () {
        expect(
          reservedPrefixes.keys.map(importPrefixFor).toSet(),
          hasLength(reservedPrefixes.length),
        );
      },
    );

    test(
      'when getting the import prefix for each, '
      'then each is shorter than the nine characters of a hashed prefix, '
      'which is what keeps the hash from ever producing one of them.',
      () {
        expect(
          reservedPrefixes.keys.map((url) => importPrefixFor(url).length),
          everyElement(lessThan(9)),
        );
      },
    );
  });

  group(
    'Given a URL for a package with no reserved prefix, '
    'when getting the import prefix,',
    () {
      const url = 'package:example/example.dart';
      late final prefix = importPrefixFor(url);

      test('then it is a 9-character string.', () {
        expect(prefix, hasLength(9));
      });

      test('then it starts with an _i.', () {
        expect(prefix, startsWith('_i'));
      });

      test('then the import prefix is stable.', () {
        expect(prefix, importPrefixFor(url));
      });
    },
  );

  group(
    'Given a URL for a dart library with no reserved prefix, '
    'when getting the import prefix,',
    () {
      const url = 'dart:collection';
      late final prefix = importPrefixFor(url);

      test('then it is a 9-character string.', () {
        expect(prefix, hasLength(9));
      });
    },
  );

  test('Given two different URLs, '
      'when getting the import prefix, '
      'then they have different prefixes.', () {
    expect(
      importPrefixFor('package:example/example.dart'),
      isNot(importPrefixFor('package:other/other.dart')),
    );
  });

  group('Given a reference to a fixnum implementation library,', () {
    // package:fixnum 1.2.0 moved its implementation into platform specific
    // libraries under src/ that must not be imported directly.
    late StableImportAllocator allocator;
    late String allocated;

    setUp(() {
      allocator = StableImportAllocator();
      allocated = allocator.allocate(
        const Reference('Int64', 'package:fixnum/src/int64.dart'),
      );
    });

    test(
      'when allocating a reference, '
      'then the reference is aliased to the public library.',
      () {
        expect(
          allocated,
          '${importPrefixFor('package:fixnum/fixnum.dart')}.Int64',
        );
      },
    );

    test(
      'when getting the imports, '
      'then the public library is what gets imported.',
      () {
        expect(
          allocator.imports.map((directive) => directive.url),
          ['package:fixnum/fixnum.dart'],
        );
      },
    );

    test(
      'when allocating multiple references to the public library, '
      'then it shares one public import only.',
      () {
        var shared = StableImportAllocator();
        shared.allocate(
          const Reference('Int64', 'package:fixnum/src/int64.dart'),
        );
        shared.allocate(
          const Reference('Int32', 'package:fixnum/fixnum.dart'),
        );

        expect(shared.imports, hasLength(1));
      },
    );
  });

  test(
    'Given a reference to an ordinary library, '
    'when allocating a reference, '
    'then the URL is imported exactly as referenced.',
    () {
      var allocator = StableImportAllocator();
      allocator.allocate(
        const Reference('Example', 'package:example/src/nested/example.dart'),
      );

      expect(
        allocator.imports.map((directive) => directive.url),
        ['package:example/src/nested/example.dart'],
      );
    },
  );

  test(
    'Given a reference with no URL, '
    'when allocating a reference, '
    'then it is emitted unprefixed and imports nothing.',
    () {
      var allocator = StableImportAllocator();

      expect(allocator.allocate(const Reference('int')), 'int');
      expect(allocator.imports, isEmpty);
    },
  );

  test(
    'Given a reference to dart:core, '
    'when allocating a reference, '
    'then it is emitted unprefixed and imports nothing.',
    () {
      var allocator = StableImportAllocator();

      expect(allocator.allocate(const Reference('int', 'dart:core')), 'int');
      expect(allocator.imports, isEmpty);
    },
  );

  group(
    'Given two libraries that reference the same imports in different orders,',
    () {
      const urls = [
        'package:serverpod/serverpod.dart',
        'dart:typed_data',
        'sub/dir/model.dart',
        'package:example/example.dart',
        '../shared/other.dart',
      ];

      late StableImportAllocator inOrder;
      late StableImportAllocator reversed;

      setUp(() {
        inOrder = StableImportAllocator();
        reversed = StableImportAllocator();

        for (var url in urls) {
          inOrder.allocate(Reference('Symbol', url));
        }
        for (var url in urls.reversed) {
          reversed.allocate(Reference('Symbol', url));
        }

        inOrder.assignPrefixes();
        reversed.assignPrefixes();
      });

      test(
        'when their import prefixes are assigned, '
        'then both emit the same import directives.',
        () {
          expect(
            reversed.imports.map(
              (directive) => "import '${directive.url}' as ${directive.as};",
            ),
            inOrder.imports.map(
              (directive) => "import '${directive.url}' as ${directive.as};",
            ),
          );
        },
      );
    },
  );

  test(
    'Given two URLs that were found to hash to the same prefix, '
    'when getting the import prefix for each, '
    'then the two prefixes are the same.',
    () {
      expect(importPrefixFor(collidingUrl), importPrefixFor(laterCollidingUrl));
    },
  );

  group(
    'Given a library that references two URLs whose prefixes collide,',
    () {
      late StableImportAllocator allocator;

      setUp(() {
        allocator = StableImportAllocator();

        for (var url in [collidingUrl, laterCollidingUrl]) {
          allocator.allocate(Reference('Symbol', url));
        }

        allocator.assignPrefixes();
      });

      test(
        'when its import prefixes are assigned, '
        'then the URL that sorts first is aliased with the prefix it hashes '
        'to.',
        () {
          expect(
            allocator.imports.map(
              (directive) => "import '${directive.url}' as ${directive.as};",
            ),
            contains(
              "import '$collidingUrl' as ${importPrefixFor(collidingUrl)};",
            ),
          );
        },
      );

      test(
        'when its import prefixes are assigned, '
        'then the URL that sorts last is imported under a different prefix.',
        () {
          var moved = allocator.imports.firstWhere(
            (directive) => directive.url == laterCollidingUrl,
          );

          expect(moved.as, isNot(importPrefixFor(laterCollidingUrl)));
        },
      );

      test(
        'when its import prefixes are assigned, '
        'then the URL that sorts last is aliased with an ordinary hashed '
        'prefix.',
        () {
          var moved = allocator.imports
              .firstWhere((directive) => directive.url == laterCollidingUrl)
              .as;

          expect(moved, hasLength(9));
          expect(moved, startsWith('_i'));
        },
      );
    },
  );

  group(
    'Given two libraries that reference the same two colliding URLs in '
    'different orders,',
    () {
      late StableImportAllocator inOrder;
      late StableImportAllocator reversed;

      setUp(() {
        inOrder = StableImportAllocator();
        reversed = StableImportAllocator();

        for (var url in [collidingUrl, laterCollidingUrl]) {
          inOrder.allocate(Reference('Symbol', url));
        }
        for (var url in [laterCollidingUrl, collidingUrl]) {
          reversed.allocate(Reference('Symbol', url));
        }

        inOrder.assignPrefixes();
        reversed.assignPrefixes();
      });

      test(
        'when their import prefixes are assigned, '
        'then both emit the same import directives.',
        () {
          expect(
            reversed.imports.map(
              (directive) => "import '${directive.url}' as ${directive.as};",
            ),
            inOrder.imports.map(
              (directive) => "import '${directive.url}' as ${directive.as};",
            ),
          );
        },
      );
    },
  );

  group('Given a library whose import prefixes have been assigned,', () {
    late StableImportAllocator allocator;

    setUp(() {
      allocator = StableImportAllocator();
      allocator.allocate(
        const Reference('Example', 'package:example/example.dart'),
      );
      allocator.assignPrefixes();
    });

    test(
      'when allocating a reference to an import it collected, '
      'then the reference is aliased with the prefix it was assigned.',
      () {
        expect(
          allocator.allocate(
            const Reference('Example', 'package:example/example.dart'),
          ),
          '${importPrefixFor('package:example/example.dart')}.Example',
        );
      },
    );

    test(
      'when allocating a reference to an import it never collected, '
      'then the import that would be left out is reported.',
      () {
        expect(
          () => allocator.allocate(
            const Reference('Late', 'package:example/late.dart'),
          ),
          throwsA(
            isStateError.having(
              (error) => error.message,
              'message',
              contains('package:example/late.dart'),
            ),
          ),
        );
      },
    );
  });

  group('Given a library that resolves two of its URLs onto one package,', () {
    late StableImportAllocator allocator;

    setUp(() {
      allocator = StableImportAllocator(
        resolveUrl: (url) => url.startsWith('package:alias/')
            ? 'package:target/target.dart'
            : url,
      );

      allocator
        ..allocate(const Reference('A', 'package:alias/alias.dart'))
        ..allocate(const Reference('B', 'package:target/target.dart'))
        ..assignPrefixes();
    });

    test(
      'when allocating a reference through the URL that resolves, '
      'then it is aliased with the prefix of the package it resolves to.',
      () {
        expect(
          allocator.allocate(
            const Reference('A', 'package:alias/alias.dart'),
          ),
          '${importPrefixFor('package:target/target.dart')}.A',
        );
      },
    );

    test(
      'when getting the imports, '
      'then only the package they resolve to is imported.',
      () {
        expect(
          allocator.imports.map(
            (directive) => "import '${directive.url}' as ${directive.as};",
          ),
          [
            "import 'package:target/target.dart' as "
                "${importPrefixFor('package:target/target.dart')};",
          ],
        );
      },
    );
  });
}
