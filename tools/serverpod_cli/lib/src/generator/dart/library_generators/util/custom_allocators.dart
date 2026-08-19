import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

/// Number of base36 characters in a hashed import prefix.
///
/// Hashed prefixes could in principle collide with each other. The odds stay
/// below 1% until a single library imports around 40 000 files; the largest
/// library Serverpod generates today imports a few hundred. A collision is
/// detected and reported rather than silently emitted, see
/// [_PrefixRegistry.prefixFor].
const _prefixLength = 7;

const _base36Digits = '0123456789abcdefghijklmnopqrstuvwxyz';

/// How many times [_PrefixRegistry._unusedPrefixFor] rehashes before deciding
/// the hash itself must be broken.
const _maxRehashAttempts = 8;

/// URLs that are always in scope, and are therefore never prefixed.
const _doNotPrefix = {'dart:core'};

/// Canonical URLs, keyed by the URL a reference carried.
///
/// The mapping is a pure function of the URL and the set of URLs one run sees
/// is bounded by the size of the project, so it is worth memoizing:
/// [_canonicalizeUrl] runs for every reference the generators emit.
final _canonicalUrls = <String, String>{};

/// Rewrites URLs that cannot be imported as referenced.
///
/// Some URLs a reference can carry are not importable — `package:fixnum` 1.2.0
/// moved its implementation into platform specific libraries under `src/` that
/// must not be imported directly. `code_builder` documents these rewrites as
/// part of the [Allocator.imports] contract, and applied them for us until
/// Serverpod started allocating its own prefixes.
///
/// Rather than restate the rules and have them drift, ask one of
/// `code_builder`'s own allocators what it would import. [Allocator.new] is
/// the one that prefixes nothing, so its [Allocator.imports] is exactly the
/// canonical URL and nothing else.
String _canonicalizeUrl(String url) {
  return _canonicalUrls.putIfAbsent(url, () {
    var probe = Allocator()..allocate(Reference('_', url));
    return probe.imports.single.url;
  });
}

/// Short prefixes reserved for the imports that dominate generated code.
///
/// Reference counts across everything this repository generates: the two
/// entries at the top alone account for roughly 45 000 of them, so shortening
/// those prefixes is most of the size difference between hashed prefixes and
/// the sequential ones they replaced.
///
/// Every prefix here is shorter than a hashed one, which is what makes the
/// table safe: a hashed prefix is always exactly [_prefixLength] characters
/// after the `_i`, so no reserved prefix can ever be produced by the hash. The
/// entries only have to be unique among themselves. Both properties are
/// covered by `import_prefix_test.dart`, which spells out the table it
/// expects; add an entry here and it goes there too.
///
/// Reserving a prefix is as permanent as the hash: changing an entry, or
/// adding one for a URL that is already in use, rewrites that import
/// throughout every generated file of every Serverpod project.
const _reservedPrefixes = {
  // Serverpod core.
  'package:serverpod/serverpod.dart': '_is',
  'package:serverpod/protocol.dart': '_isp',
  'package:serverpod_client/serverpod_client.dart': '_isc',
  'package:serverpod_service_client/serverpod_service_client.dart': '_issc',
  'package:serverpod_database/serverpod_database.dart': '_isd',
  'package:serverpod_serialization/serverpod_serialization.dart': '_iss',
  'package:serverpod_shared/serverpod_shared.dart': '_issh',
  'package:serverpod_test/serverpod_test.dart': '_ist',
  'package:serverpod_test/serverpod_test_public_exports.dart': '_istp',

  // Dart SDK libraries. `dart:core` is never prefixed, see [_doNotPrefix].
  'dart:async': '_ida',
  'dart:convert': '_idc',
  'dart:io': '_idi',
  'dart:typed_data': '_idt',

  // Auth modules, `_ia` + module + `s`erver or `c`lient. The legacy auth and
  // chat modules are deliberately absent; they keep their hashed prefixes.
  'package:serverpod_auth_core_server/serverpod_auth_core_server.dart': '_iacs',
  'package:serverpod_auth_core_client/serverpod_auth_core_client.dart': '_iacc',
  'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart': '_iais',
  'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart': '_iaic',
  'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart':
      '_iabs',
  'package:serverpod_auth_bridge_client/serverpod_auth_bridge_client.dart':
      '_iabc',
  'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart':
      '_iams',
  'package:serverpod_auth_migration_client/serverpod_auth_migration_client.dart':
      '_iamc',
};

/// Returns the import prefix used to alias [url].
///
/// Either the prefix reserved for [url] in [_reservedPrefixes], or one derived
/// from a hash of the URL.
///
/// Both are a pure function of the URL. Neither depends on how many other
/// imports the library has, nor on the order in which they are first
/// referenced, so adding, removing or renaming a model leaves the prefix of
/// every unrelated import untouched. That is what keeps a diff of regenerated
/// code limited to the code that actually changed.
///
/// The exception is a hash collision, where the losing URL is aliased as
/// something other than what this returns, see
/// [_PrefixRegistry._unusedPrefixFor]. Adding an import that collides with an
/// existing one can therefore move that one.
///
/// Do not change the hash or [_prefixLength]. These prefixes appear in every
/// generated file of every Serverpod project, so any change to them rewrites
/// all of that code at once.
String importPrefixFor(String url) {
  var reserved = _reservedPrefixes[url];
  if (reserved != null) return reserved;

  var hash = _hash(url);

  var prefix = StringBuffer('_i');
  for (var i = 0; i < _prefixLength; i++) {
    prefix.write(_base36Digits[hash % 36]);
    hash ~/= 36;
  }

  return prefix.toString();
}

/// 64 bit FNV-1a, run through a SplitMix64 finalizer.
///
/// FNV-1a alone mixes its low bits poorly, and [importPrefixFor] reads the
/// prefix out of exactly those bits. The finalizer avalanches the whole word
/// so that every bit of the URL reaches them.
///
/// The result is masked down to 60 bits so it is always positive: Dart's [int]
/// is signed, and the base36 conversion needs `%` and `~/` to behave as if it
/// were not. 60 bits is far more than the 37 the conversion consumes.
int _hash(String value) {
  var hash = 0xcbf29ce484222325;
  for (var i = 0; i < value.length; i++) {
    hash = (hash ^ value.codeUnitAt(i)) * 0x100000001b3;
  }

  hash ^= hash >>> 30;
  hash *= 0xbf58476d1ce4e5b9;
  hash ^= hash >>> 27;
  hash *= 0x94d049bb133111eb;
  hash ^= hash >>> 31;

  return hash & 0x0fffffffffffffff;
}

/// An [Allocator] whose prefixes are assigned in one go, from the complete set
/// of imports a library needs, rather than as references arrive.
///
/// Callers emit the library once into the allocator to collect its imports,
/// call [assignPrefixes], and only then emit the code they keep. See
/// [GenerateCode.collectImports].
abstract interface class AssigningAllocator implements Allocator {
  /// Assigns a prefix to every import collected so far.
  ///
  /// Idempotent, because the members of a sealed hierarchy share one set of
  /// prefixes and each of them asks for the assignment.
  void assignPrefixes();
}

/// The set of imports of a single generated library, and the prefix each one
/// is aliased with.
///
/// Owns the whole path from a referenced URL to a prefix: canonicalization,
/// resolution, deciding whether a prefix is needed at all, and assigning the
/// prefixes themselves. Keeping it in one place is what lets the emitted
/// import directive and the prefix in the code beside it agree by
/// construction.
class _PrefixRegistry {
  _PrefixRegistry({String Function(String url)? resolveUrl})
    : _resolveUrl = resolveUrl;

  /// See [StableImportAllocator.new].
  final String Function(String url)? _resolveUrl;

  final Set<String> _urls = {};

  /// The assignment, or `null` while imports are still being collected.
  Map<String, String>? _prefixes;

  /// Returns the prefix to alias [url] with, recording the import, or `null`
  /// when the reference needs neither prefix nor import.
  ///
  /// Before [assignPrefixes] this answers with the URL's own hashed prefix.
  /// That is what the collecting pass emits, and its output is thrown away.
  ///
  /// Throws a [StateError] for a URL first seen after [assignPrefixes], since
  /// [imports] has no directive for it. That is a lifecycle mistake on our
  /// side rather than anything a user did, and silently emitting a prefixed
  /// reference with no import behind it would produce Dart that does not
  /// compile.
  String? prefixFor(String url) {
    var resolved = _canonicalizeUrl(url);
    resolved = _resolveUrl?.call(resolved) ?? resolved;

    // After resolving, so that a resolver is free to map a URL to or from one
    // that is always in scope.
    if (_doNotPrefix.contains(resolved)) return null;

    _urls.add(resolved);

    var prefixes = _prefixes;
    if (prefixes == null) return importPrefixFor(resolved);

    var prefix = prefixes[resolved];
    if (prefix == null) {
      throw StateError(
        'The import "$resolved" was first referenced after the prefixes of '
        'this library were assigned, so it would be left without an import '
        'directive. Every library sharing these prefixes has to go through '
        'GenerateCode.collectImports before any of them is generated.',
      );
    }

    return prefix;
  }

  /// Assigns a prefix to every URL collected so far, see
  /// [AssigningAllocator.assignPrefixes].
  void assignPrefixes() {
    if (_prefixes != null) return;

    var prefixes = <String, String>{};
    var taken = <String, String>{};

    // Sorted, so that the assignment depends only on which imports the library
    // needs, never on the order the generators happened to reference them in.
    // Emission order shifts whenever a model is added or a field is reordered,
    // and a prefix that moved with it would be exactly the churn these stable
    // prefixes exist to prevent.
    for (var url in _urls.toList()..sort()) {
      var prefix = _unusedPrefixFor(url, taken);
      prefixes[url] = prefix;
      taken[prefix] = url;
    }

    _prefixes = prefixes;
  }

  /// The prefix for [url], rehashed until nothing in [taken] uses it.
  ///
  /// Two URLs hashing to the same prefix is vanishingly unlikely, but the
  /// imports involved can easily belong to packages the user does not control,
  /// so failing here would leave them with a project that cannot be generated
  /// and nothing they could do about it. Letting them share a prefix is not an
  /// option either: it is valid Dart, so it would surface much later as an
  /// ambiguous reference in code nobody wrote.
  ///
  /// Which of the two moves is decided by [assignPrefixes] visiting URLs in
  /// sorted order, so it is a property of the pair rather than of when each
  /// was referenced.
  String _unusedPrefixFor(String url, Map<String, String> taken) {
    var prefix = importPrefixFor(url);
    if (!taken.containsKey(prefix)) return prefix;

    for (var attempt = 1; attempt <= _maxRehashAttempts; attempt++) {
      var rehashed = importPrefixFor('$url#$attempt');
      if (!taken.containsKey(rehashed)) return rehashed;
    }

    // Not reachable with a working hash: this needs $_maxRehashAttempts
    // independent collisions in a row.
    throw StateError(
      'Could not find a free import prefix for "$url" after '
      '$_maxRehashAttempts rehashes. importPrefixFor is not distributing '
      'prefixes as it should.',
    );
  }

  /// The import directives for everything collected so far.
  ///
  /// Sorted, because the prefixes no longer encode the order in which imports
  /// were first referenced. [Directive] sorts as the `directives_ordering`
  /// lint expects: `dart:`, then `package:`, then relative.
  Iterable<Directive> get imports {
    var prefixes =
        _prefixes ?? {for (var url in _urls) url: importPrefixFor(url)};

    return [
      for (var MapEntry(key: url, value: prefix) in prefixes.entries)
        Directive.import(url, as: prefix),
    ]..sort();
  }
}

/// An [Allocator] that aliases every import with a prefix derived from its
/// URL, see [importPrefixFor].
///
/// [resolveUrl] maps a referenced URL to the one to import, for generators
/// that emit references against one package and import another. Resolving
/// here rather than rewriting the emitted source keeps the prefix derived from
/// the URL that actually ends up in the import directive.
class StableImportAllocator implements AssigningAllocator {
  final _PrefixRegistry _registry;

  StableImportAllocator({String Function(String url)? resolveUrl})
    : _registry = _PrefixRegistry(resolveUrl: resolveUrl);

  @override
  void assignPrefixes() => _registry.assignPrefixes();

  @override
  String allocate(Reference reference) {
    var symbol = reference.symbol!;
    var url = reference.url;
    if (url == null) return symbol;

    var prefix = _registry.prefixFor(url);
    return prefix == null ? symbol : '$prefix.$symbol';
  }

  @override
  Iterable<Directive> get imports => _registry.imports;
}

/// Collects the imports of a library that is split into part files.
///
/// The part files and the library they belong to share one namespace, so they
/// also share one collector: the parts resolve their prefixes against it while
/// the library that owns them emits the import directives.
class ImportCollector {
  final _PrefixRegistry _registry;
  final String basePath;

  ImportCollector(this.basePath, {String Function(String url)? resolveUrl})
    : _registry = _PrefixRegistry(resolveUrl: resolveUrl);

  /// See [AssigningAllocator.assignPrefixes].
  void assignPrefixes() => _registry.assignPrefixes();

  String _normalizePath(String topNodePath, String currentPath) {
    if (topNodePath.startsWith('package:') || topNodePath.startsWith('dart:')) {
      return topNodePath;
    }

    var absolutePath = p.join(p.dirname(currentPath), topNodePath);
    var relativePath = p.relative(absolutePath, from: p.dirname(basePath));

    // If on Windows, top level paths could appear with backslashes and break
    // the import clause, such as `import '..\protocol.dart' as _i1;`.
    return p.split(relativePath).join('/');
  }

  /// Returns the prefix to alias [topNodePath] with as seen from
  /// [currentPath], or `null` when the reference needs no prefix.
  String? getOrCreateAlias(String topNodePath, String currentPath) {
    return _registry.prefixFor(_normalizePath(topNodePath, currentPath));
  }

  Iterable<Directive> get imports => _registry.imports;
}

class PartOfAllocator implements AssigningAllocator {
  final String _currentPath;
  final ImportCollector _importCollector;

  PartOfAllocator({
    required String currentPath,
    required ImportCollector importCollector,
  }) : _currentPath = currentPath,
       _importCollector = importCollector;

  @override
  void assignPrefixes() => _importCollector.assignPrefixes();

  @override
  String allocate(Reference reference) {
    var symbol = reference.symbol!;
    var url = reference.url;
    if (url == null) return symbol;

    var alias = _importCollector.getOrCreateAlias(url, _currentPath);
    return alias == null ? symbol : '$alias.$symbol';
  }

  @override
  Iterable<Directive> get imports => [];
}

class PartAllocator implements AssigningAllocator {
  final PartOfAllocator _partOfAllocator;

  PartAllocator({
    required PartOfAllocator partOfAllocator,
  }) : _partOfAllocator = partOfAllocator;

  @override
  void assignPrefixes() => _partOfAllocator.assignPrefixes();

  @override
  String allocate(Reference reference) => _partOfAllocator.allocate(reference);

  @override
  Iterable<Directive> get imports => _partOfAllocator._importCollector.imports;
}
