import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/mcp/serverpod_issue_reporter.dart';
import 'package:test/test.dart';

const _report = ServerpodIssueReport(
  title: 'Generated client does not compile',
  description: 'A model with a `List<Duration?>` field breaks the client.',
  type: ServerpodIssueReportType.bug,
);

final _url = Uri.parse('https://feedback.test/feedback');

void main() {
  test(
    'Given an environment without the issue report URL variable, '
    'when resolving the service URL, '
    'then it is the default.',
    () {
      expect(
        ServerpodIssueReporter.urlFromEnvironment({}),
        defaultServerpodIssueReportUrl,
      );
    },
  );

  test(
    'Given an environment with a valid issue report URL, '
    'when resolving the service URL, '
    'then it is the override.',
    () {
      expect(
        ServerpodIssueReporter.urlFromEnvironment({
          serverpodIssueReportUrlEnvVar: 'http://localhost:8099/feedback',
        }),
        Uri.parse('http://localhost:8099/feedback'),
      );
    },
  );

  test(
    'Given an environment with a malformed issue report URL, '
    'when resolving the service URL, '
    'then it is null.',
    () {
      expect(
        ServerpodIssueReporter.urlFromEnvironment({
          serverpodIssueReportUrlEnvVar: 'http://[::1',
        }),
        isNull,
      );
    },
  );

  group('Given a ServerpodIssueReporter with a malformed URL override,', () {
    late List<http.Request> requests;
    late ServerpodIssueReporter reporter;

    setUp(() {
      requests = [];
      reporter = ServerpodIssueReporter(
        environment: {serverpodIssueReportUrlEnvVar: 'http://[::1'},
        client: MockClient((request) async {
          requests.add(request);
          return http.Response('', 201);
        }),
      );
    });

    test(
      'when sending a report, '
      'then it fails naming the environment variable.',
      () async {
        final result = await reporter.send(_report);

        expect(
          result,
          isA<ServerpodIssueReportFailed>().having(
            (r) => r.reason,
            'reason',
            'SERVERPOD_ISSUE_REPORT_URL is not a valid URL.',
          ),
        );
      },
    );

    test('when sending a report, then nothing is posted.', () async {
      await reporter.send(_report);

      expect(requests, isEmpty);
    });
  });

  group('Given a ServerpodIssueReporter,', () {
    late List<http.Request> requests;
    late ServerpodIssueReporter reporter;

    setUp(() => requests = []);

    group('with a service that creates issues,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((request) async {
            requests.add(request);
            return http.Response('', 201);
          }),
        );
      });

      group('when sending a report with agent details,', () {
        late ServerpodIssueReportResult result;

        setUp(() async {
          result = await reporter.send(
            _report,
            agent: 'claude-code',
            agentVersion: '2.0.0',
            mcpVersion: '2025-06-18',
          );
        });

        test('then it is created without an issue url or id.', () {
          expect(
            result,
            isA<ServerpodIssueReportCreated>()
                .having((r) => r.url, 'url', isNull)
                .having((r) => r.id, 'id', isNull),
          );
        });

        test('then it is posted to the service url', () {
          expect(requests.single.method, 'POST');
          expect(requests.single.url, _url);
        });

        test('then it is sent as JSON', () {
          expect(
            requests.single.headers['content-type'],
            startsWith('application/json'),
          );
        });

        test('then the body holds the title, description and type', () {
          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(body, containsPair('title', _report.title));
          expect(body, containsPair('description', _report.description));
          expect(body, containsPair('type', 'bug'));
        });

        test('then the context holds the Serverpod version', () {
          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(
            body['context'],
            containsPair('serverpodVersion', templateVersion),
          );
        });

        test('then the context holds the Dart version number alone', () {
          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(
            body['context'],
            containsPair('dartVersion', matches(RegExp(r'^\d+\.\d+\.\d+\S*$'))),
          );
        });

        test('then the context holds the agent details', () {
          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(
            body['context'],
            allOf(
              containsPair('agent', 'claude-code'),
              containsPair('agentVersion', '2.0.0'),
              containsPair('mcpVersion', '2025-06-18'),
            ),
          );
        });

        test('then the context is flat', () {
          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(
            (body['context'] as Map<String, dynamic>).values,
            everyElement(isA<String>()),
          );
        });
      });

      test(
        'when sending a report without agent details, '
        'then the context leaves them out',
        () async {
          await reporter.send(_report);

          final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
          expect(
            (body['context'] as Map<String, dynamic>).keys,
            isNot(anyOf(contains('agent'), contains('mcpVersion'))),
          );
        },
      );
    });

    group('with a service that returns the created issue,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({
                'id': 'SP-123',
                'url': 'https://linear.app/serverpod/issue/SP-123',
              }),
              201,
            ),
          ),
        );
      });

      test(
        'when sending a report, '
        'then it is created with the issue url and id.',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportCreated>()
                .having(
                  (r) => r.url,
                  'url',
                  'https://linear.app/serverpod/issue/SP-123',
                )
                .having((r) => r.id, 'id', 'SP-123'),
          );
        },
      );
    });

    group('with a service that answers 200 to a created issue,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((_) async => http.Response('{}', 200)),
        );
      });

      test('when sending a report, then it is created.', () async {
        final result = await reporter.send(_report);

        expect(result, isA<ServerpodIssueReportCreated>());
      });
    });

    group('with a service that rejects the report as too large,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({'error': '"description" is too long.'}),
              413,
            ),
          ),
        );
      });

      test(
        'when sending a report, '
        'then it is rejected with the service error message.',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportRejected>().having(
              (r) => r.reason,
              'reason',
              '"description" is too long.',
            ),
          );
        },
      );
    });

    group('with a service that rate limits the report,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((_) async => http.Response('', 429)),
        );
      });

      test(
        'when sending a report, '
        'then it fails as retryable.',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>().having(
              (r) => r.retryable,
              'retryable',
              isTrue,
            ),
          );
        },
      );
    });

    group('with a service that refuses the request with an error message,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({'error': 'Unknown client.'}),
              403,
            ),
          ),
        );
      });

      test(
        'when sending a report, '
        'then it fails as not retryable with the service error message.',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>()
                .having((r) => r.retryable, 'retryable', isFalse)
                .having(
                  (r) => r.reason,
                  'reason',
                  'The feedback service responded with HTTP 403: '
                      'Unknown client.',
                ),
          );
        },
      );
    });

    group('with a service that rejects the report as invalid,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({'error': '"description" is required.'}),
              400,
            ),
          ),
        );
      });

      test(
        'when sending a report, '
        'then it is rejected with the service error message',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportRejected>().having(
              (r) => r.reason,
              'reason',
              '"description" is required.',
            ),
          );
        },
      );
    });

    group('with a service that fails internally,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({'error': 'Something went wrong.'}),
              500,
            ),
          ),
        );
      });

      test(
        'when sending a report, '
        'then it fails as retryable',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>().having(
              (r) => r.retryable,
              'retryable',
              isTrue,
            ),
          );
        },
      );
    });

    group('with a service that responds with an unexpected status,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((_) async => http.Response('', 405)),
        );
      });

      test(
        'when sending a report, '
        'then it fails as not retryable',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>().having(
              (r) => r.retryable,
              'retryable',
              isFalse,
            ),
          );
        },
      );
    });

    group('with an unreachable service,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((_) => throw http.ClientException('refused')),
        );
      });

      test(
        'when sending a report, '
        'then it fails with the connection error',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>().having(
              (r) => r.reason,
              'reason',
              contains('refused'),
            ),
          );
        },
      );
    });

    group('with a service that never responds,', () {
      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          timeout: const Duration(milliseconds: 10),
          client: MockClient((_) => Completer<http.Response>().future),
        );
      });

      test(
        'when sending a report, '
        'then it fails as retryable once the timeout passes',
        () async {
          final result = await reporter.send(_report);

          expect(
            result,
            isA<ServerpodIssueReportFailed>().having(
              (r) => r.retryable,
              'retryable',
              isTrue,
            ),
          );
        },
      );
    });
  });
}
