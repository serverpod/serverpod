import 'package:pub_semver/pub_semver.dart';

import '../exceptions.dart';

/// Bill of materials of one published Serverpod PostgreSQL bundle
/// (PostgreSQL + PostGIS + pgvector): the component versions plus the bundle
/// packaging [revision].
///
/// Published bundles are immutable. Any change that alters the shipped bytes
/// while the PostgreSQL version stays the same (an extension bump, a compiler
/// or packaging fix) must ship as a new [revision] - the revision is what
/// lets a fixed bundle reach users whose cache already holds the broken one.
///
/// Keep in sync with `tool/build_postgres/versions.env` (the shell side of
/// this spec); `bundle_spec_test.dart` cross-checks the two.
class BundleSpec {
  /// PostgreSQL major.minor.patch ("BOM") version.
  final Version postgresVersion;

  /// Monotonic packaging revision within [postgresVersion], starting at 1.
  final int revision;

  /// PostGIS version compiled into the bundle.
  final String postgisVersion;

  /// pgvector version compiled into the bundle.
  final String pgvectorVersion;

  /// Creates a bundle specification.
  const BundleSpec({
    required this.postgresVersion,
    required this.revision,
    required this.postgisVersion,
    required this.pgvectorVersion,
  });

  /// Major.minor.patch PG version, e.g. `16.13.0`.
  String get bom =>
      '${postgresVersion.major}.${postgresVersion.minor}.'
      '${postgresVersion.patch}';

  /// Unique, immutable identity of the bundle: `<bom>-r<revision>`. Names
  /// the release tag, the archive, and the cache entry, so two revisions of
  /// the same PG version can never be mistaken for each other.
  String get bundleId => '$bom-r$revision';

  /// GitHub release tag carrying this bundle's assets.
  String get releaseTag => 'embedded-postgres-v$bundleId';

  @override
  String toString() => 'BundleSpec($bundleId)';

  @override
  bool operator ==(Object other) =>
      other is BundleSpec &&
      other.postgresVersion == postgresVersion &&
      other.revision == revision &&
      other.postgisVersion == postgisVersion &&
      other.pgvectorVersion == pgvectorVersion;

  @override
  int get hashCode =>
      Object.hash(postgresVersion, revision, postgisVersion, pgvectorVersion);
}

/// Every bundle this package version knows how to download, one entry per
/// PG version (each carrying its current revision).
final List<BundleSpec> publishedBundleSpecs = [
  BundleSpec(
    postgresVersion: Version(16, 13, 0),
    revision: 1,
    postgisVersion: '3.5.4',
    pgvectorVersion: '0.8.3',
  ),
];

/// Resolves the [BundleSpec] for [version].
///
/// Throws [UnsupportedVersionException] when no bundle is published for
/// [version] - before any network or filesystem work, so a typo'd version
/// fails immediately with the supported set instead of as a late 404.
BundleSpec bundleSpecFor(Version version) {
  for (var spec in publishedBundleSpecs) {
    if (spec.postgresVersion == version) return spec;
  }
  throw UnsupportedVersionException(
    'No Serverpod PostgreSQL bundle is published for version $version. '
    'Published versions: '
    '${publishedBundleSpecs.map((s) => s.bom).join(', ')}.',
  );
}
