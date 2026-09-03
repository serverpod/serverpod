import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';

/// Which published versions `serverpod upgrade` is allowed to select.
enum UpgradeChannel {
  /// Released versions only.
  stable,

  /// Any published version, prereleases included.
  any;

  /// Returns the channel to track when none was requested.
  ///
  /// A prerelease installation follows prereleases, so upgrading a beta never
  /// moves back to an older stable release.
  static UpgradeChannel forVersion(final Version version) =>
      version.isPreRelease ? UpgradeChannel.any : UpgradeChannel.stable;
}

/// What `serverpod upgrade` should do with the version it resolved.
enum UpgradeAction {
  /// The target version should be installed.
  install,

  /// The installed version is the target version.
  upToDate,

  /// The target version is older than the installed one, and _not_ requested.
  downgradeBlocked,
}

/// The version an upgrade resolved to, and what installing it would do.
class UpgradeTarget {
  /// What installing [version] would do.
  final UpgradeAction action;

  /// The version to install.
  final Version version;

  const UpgradeTarget(this.action, this.version);
}

/// Picks the version to install from those [published] to pub.dev, or `null`
/// if none is a candidate.
///
/// [requested] wins when it was published. When nothing was requested, the
/// newest version [channel] admits wins.
UpgradeTarget? resolveUpgradeTarget({
  required final Version current,
  required final Iterable<Version> published,
  required final UpgradeChannel channel,
  final Version? requested,
}) {
  final candidates = published.where((final version) {
    if (requested != null) return version == requested;
    return channel == UpgradeChannel.any || !version.isPreRelease;
  }).toList()..sort();

  final target = candidates.lastOrNull;
  if (target == null) return null;
  if (target == current) return UpgradeTarget(UpgradeAction.upToDate, target);

  // Only an explicitly requested version may move the installation backwards.
  return UpgradeTarget(
    target > current || requested != null
        ? UpgradeAction.install
        : UpgradeAction.downgradeBlocked,
    target,
  );
}
