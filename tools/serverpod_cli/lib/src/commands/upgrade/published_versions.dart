import 'package:pub_api_client/pub_api_client.dart' show PubClient;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Fetches every version of [packageName] published to pub.dev, or `null`
/// when pub.dev could not be reached.
Future<List<Version>?> fetchPublishedVersions(
  final String packageName, {
  final Duration timeout = const Duration(seconds: 10),
}) async {
  final client = PubClient();
  try {
    final versions = await client.packageVersions(packageName).timeout(timeout);
    return versions.map(_tryParseVersion).nonNulls.toList();
  } catch (e) {
    log.debug('Failed to look up published versions of $packageName: $e');
    return null;
  } finally {
    client.close();
  }
}

Version? _tryParseVersion(final String version) {
  try {
    return Version.parse(version);
  } on FormatException catch (e) {
    log.debug('Ignoring unparsable version "$version": ${e.message}');
    return null;
  }
}
