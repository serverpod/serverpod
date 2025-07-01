import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/util/pubspec_lock_parser.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';

/// Warnings for when the package version does not match the version of the
/// Serverpod's CLI.
class ServerpodPackagesVersionCheckWarnings {
  static const incompatibleVersion =
      'The package version does not match the version of the Serverpod\'s '
      'CLI. This may cause errors or unexpected behavior.';
  static String approximateVersion(Version cliVersion) =>
      'The package is defined with a version range (for example '
      '"^$cliVersion"). This can cause a mismatch with Serverpod\'s CLI '
      'version. It\'s preferred to use "$cliVersion" over "^$cliVersion" for '
      'the Serverpod packages.';
  static const lockFileOutOfSync =
      'The pubspec.lock file contains Serverpod packages with versions that '
      'don\'t match the CLI version. This may cause errors or unexpected behavior. '
      'Run "dart pub get" to update your dependencies.';
}

extension on PubspecPlus {
  Iterable<HostedDep> get serverpodDeps =>
      deps.whereType<HostedDep>().where((d) => const [
            'serverpod',
            'serverpod_client',
          ].contains(d.name));
}

extension on PubspecLockParser {
  Iterable<LockedPackage> get serverpodPackages =>
      allPackages.where((p) => const [
            'serverpod',
            'serverpod_client',
          ].contains(p.name));
}

List<SourceSpanSeverityException> validateServerpodPackagesVersion(
  Version version,
  PubspecPlus pubspecPlus,
) {
  return [
    for (var dep in pubspecPlus.serverpodDeps)
      ..._validatePackageCompatibilities(dep, version)
  ];
}

SourceSpanSeverityException? validateServerpodLockFileVersion(
  Version cliVersion,
  PubspecLockParser lockParser,
) {
  for (var package in lockParser.serverpodPackages) {
    if (package.version != cliVersion) {
      return SourceSpanSeverityException(
        ServerpodPackagesVersionCheckWarnings.lockFileOutOfSync,
        null, // No source span available for lock file entries
        severity: SourceSpanSeverity.warning,
      );
    }
  }

  return null;
}

List<SourceSpanSeverityException> _validatePackageCompatibilities(
  HostedDep serverpodDep,
  Version cliVersion,
) {
  List<SourceSpanSeverityException> packageWarnings = [];

  var span = serverpodDep.span;
  var version = serverpodDep.dependency.version;
  if (!version.allowsAny(cliVersion)) {
    packageWarnings.add(SourceSpanSeverityException(
        ServerpodPackagesVersionCheckWarnings.incompatibleVersion, span,
        severity: SourceSpanSeverity.warning));
  }

  if (version is! Version) {
    packageWarnings.add(SourceSpanSeverityException(
        ServerpodPackagesVersionCheckWarnings.approximateVersion(cliVersion),
        span,
        severity: SourceSpanSeverity.warning));
  }

  return packageWarnings;
}
