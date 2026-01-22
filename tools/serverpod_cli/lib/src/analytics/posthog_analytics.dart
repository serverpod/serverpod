import 'dart:async';
import 'dart:convert';

import 'package:cli_tools/cli_tools.dart';
import 'package:http/http.dart' as http;

/// PostHog analytics implementation for CLI tracking.
class PostHogAnalytics implements Analytics {
  final String projectApiKey;
  final String host;
  final String uniqueUserId;
  final String version;
  final bool enabled;
  final List<Future<void>> _pendingRequests = [];

  PostHogAnalytics({
    required this.projectApiKey,
    required this.host,
    required this.uniqueUserId,
    required this.version,
    this.enabled = true,
  });

  @override
  void track({required String event}) {
    trackWithProperties(event: event, properties: {});
  }

  /// Tracks an event with custom properties.
  void trackWithProperties({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {
    if (!enabled) return;

    final eventData = {
      'api_key': projectApiKey,
      'event': event,
      'distinct_id': uniqueUserId,
      'properties': {
        '\$lib': 'serverpod_cli',
        '\$lib_version': version,
        ...properties,
      },
    };

    _sendEvent(eventData);
  }

  /// Sends an event to PostHog asynchronously (fire and forget)
  void _sendEvent(Map<String, dynamic> eventData) {
    final future = http
        .post(
          Uri.parse('$host/capture/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(eventData),
        )
        .then((response) {
          // Request completed successfully
        })
        .catchError((error) {
          // Silently fail - analytics should not break the CLI
        });

    _pendingRequests.add(future);
  }

  @override
  void cleanUp() {
    // PostHog events are sent immediately, no cleanup needed
    // Use waitForPendingRequests() to wait for requests to complete
  }

  /// Waits for pending HTTP requests to complete (used before program exit)
  Future<void> waitForPendingRequests() async {
    // Create a copy of pending requests and clear the list to prevent duplicate waits
    final requestsToWait = List<Future<void>>.from(_pendingRequests);
    _pendingRequests.clear();

    if (requestsToWait.isNotEmpty) {
      try {
        await Future.wait(requestsToWait).timeout(
          const Duration(milliseconds: 500),
        );
      } on TimeoutException {
        // Timeout is acceptable - we tried our best
      } catch (e) {
        // Silently fail - analytics should not break the CLI
      }
    }
  }

  /// Identifies a user with additional properties (e.g., email)
  void identify({
    String? email,
    Map<String, dynamic>? properties,
  }) {
    if (!enabled) return;

    final identifyData = {
      'api_key': projectApiKey,
      'event': '\$identify',
      'distinct_id': uniqueUserId,
      '\$set': {
        if (email != null) 'email': email,
        ...?properties,
      },
    };

    http
        .post(
          Uri.parse('$host/capture/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(identifyData),
        )
        .catchError((error) {
          // Silently fail
          return http.Response('', 500);
        });
  }
}
