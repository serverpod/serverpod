import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod_cli/src/generated/version.dart';

/// Where issue reports are sent unless
/// [serverpodIssueReportUrlEnvVar] overrides it.
final Uri defaultServerpodIssueReportUrl = Uri.https(
  'agent-feedback.serverpod.space',
  '/feedback',
);

/// Environment variable that overrides [defaultServerpodIssueReportUrl], for
/// pointing the bridge at a local or staging feedback service.
const serverpodIssueReportUrlEnvVar = 'SERVERPOD_ISSUE_REPORT_URL';

/// Kind of [ServerpodIssueReport]; the service files bugs and feedback
/// separately.
enum ServerpodIssueReportType { bug, feedback }

/// A bug or feedback an agent filed about Serverpod or its tooling.
class ServerpodIssueReport {
  final String title;

  /// Markdown details, including the agent's diagnosis for bugs.
  final String description;

  final ServerpodIssueReportType type;

  const ServerpodIssueReport({
    required this.title,
    required this.description,
    required this.type,
  });
}

/// Outcome of sending a [ServerpodIssueReport].
sealed class ServerpodIssueReportResult {
  const ServerpodIssueReportResult();
}

/// The service created an issue for the report.
final class ServerpodIssueReportCreated extends ServerpodIssueReportResult {
  const ServerpodIssueReportCreated();
}

/// The service rejected the report as invalid. [reason] is the service's own
/// message, meant for the caller to fix the report.
final class ServerpodIssueReportRejected extends ServerpodIssueReportResult {
  final String reason;

  const ServerpodIssueReportRejected(this.reason);
}

/// The report could not be delivered. [retryable] is set when the service
/// failed in a way that sending once more later may fix.
final class ServerpodIssueReportFailed extends ServerpodIssueReportResult {
  final String reason;
  final bool retryable;

  const ServerpodIssueReportFailed(this.reason, {this.retryable = false});
}

/// Sends [ServerpodIssueReport]s to the Serverpod agent feedback service over
/// plain HTTP, together with details about the environment they were filed
/// from.
class ServerpodIssueReporter {
  /// Null when [serverpodIssueReportUrlEnvVar] holds an invalid URL; every
  /// [send] then fails.
  final Uri? url;
  final Duration timeout;
  final http.Client? _client;

  /// [client] and [environment] stand in for the real network and process
  /// environment in tests. [url] defaults to [serverpodIssueReportUrlEnvVar]
  /// in [environment] when set, else [defaultServerpodIssueReportUrl].
  ServerpodIssueReporter({
    Uri? url,
    http.Client? client,
    Map<String, String>? environment,
    this.timeout = const Duration(seconds: 10),
  }) : url = url ?? urlFromEnvironment(environment ?? Platform.environment),
       _client = client;

  /// Sends [report], tagging it with the [agent] (MCP client name) that filed
  /// it, the agent's version and the negotiated [mcpVersion]. Never throws.
  Future<ServerpodIssueReportResult> send(
    ServerpodIssueReport report, {
    String? agent,
    String? agentVersion,
    String? mcpVersion,
  }) async {
    final url = this.url;
    if (url == null) {
      return const ServerpodIssueReportFailed(
        '$serverpodIssueReportUrlEnvVar is not a valid URL.',
      );
    }

    final body = jsonEncode({
      'title': report.title,
      'description': report.description,
      'type': report.type.name,
      'context': {
        'serverpodVersion': templateVersion,
        'dartVersion': Platform.version.split(' ').first,
        'os': Platform.operatingSystem,
        'osVersion': Platform.operatingSystemVersion,
        'agent': ?agent,
        'agentVersion': ?agentVersion,
        'mcpVersion': ?mcpVersion,
      },
    });

    final owned = _client == null;
    final client = _client ?? http.Client();
    try {
      final response = await client
          .post(
            url,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.userAgentHeader: 'serverpod_cli/$templateVersion',
            },
            body: body,
          )
          .timeout(timeout);
      return switch (response.statusCode) {
        201 => const ServerpodIssueReportCreated(),
        400 => ServerpodIssueReportRejected(
          _jsonObject(response.body)?['error']?.toString() ??
              'The report is invalid.',
        ),
        >= 500 => ServerpodIssueReportFailed(
          'The feedback service failed with HTTP ${response.statusCode}.',
          retryable: true,
        ),
        final status => ServerpodIssueReportFailed(
          'The feedback service responded with HTTP $status.',
        ),
      };
    } on TimeoutException {
      return ServerpodIssueReportFailed(
        'The feedback service did not respond within ${timeout.inSeconds}s.',
        retryable: true,
      );
    } catch (e) {
      return ServerpodIssueReportFailed('Could not reach $url: $e');
    } finally {
      if (owned) client.close();
    }
  }

  /// The service URL [environment] selects: [serverpodIssueReportUrlEnvVar]
  /// when set, else [defaultServerpodIssueReportUrl]. Null when the variable
  /// holds an invalid URL.
  static Uri? urlFromEnvironment(Map<String, String> environment) {
    final override = environment[serverpodIssueReportUrlEnvVar];
    if (override == null || override.isEmpty) {
      return defaultServerpodIssueReportUrl;
    }
    return Uri.tryParse(override);
  }

  /// Decodes [body] as a JSON object, or null when it is not one.
  static Map<String, Object?>? _jsonObject(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, Object?> ? decoded : null;
    } on FormatException {
      return null;
    }
  }
}
