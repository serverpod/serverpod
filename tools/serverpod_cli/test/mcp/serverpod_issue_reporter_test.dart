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

ServerpodIssueReporter _reporterResponding(
  int status, [
  Object? body,
]) => ServerpodIssueReporter(
  url: _url,
  client: MockClient(
    (_) async => http.Response(body == null ? '' : jsonEncode(body), status),
  ),
);

void main() {
  group(
    'Given a ServerpodIssueReporter with a service that creates issues,',
    () {
      late http.Request captured;
      late ServerpodIssueReporter reporter;

      setUp(() {
        reporter = ServerpodIssueReporter(
          url: _url,
          client: MockClient((request) async {
            captured = request;
            return http.Response('', 201);
          }),
        );
      });

      test(
        'when sending a report, '
        'then it is created',
        () async {
          final result = await reporter.send(_report);

          expect(result, isA<ServerpodIssueReportCreated>());
        },
      );

      test(
        'when sending a report, '
        'then it is posted as JSON with a flat context of the environment',
        () async {
          await reporter.send(
            _report,
            agent: 'claude-code',
            agentVersion: '2.0.0',
            mcpVersion: '2025-06-18',
          );

          expect(captured.method, 'POST');
          expect(captured.url, _url);
          expect(
            captured.headers['content-type'],
            startsWith('application/json'),
          );
          final body = jsonDecode(captured.body) as Map<String, dynamic>;
          expect(body, containsPair('title', _report.title));
          expect(body, containsPair('description', _report.description));
          expect(body, containsPair('type', 'bug'));
          final context = body['context'] as Map<String, dynamic>;
          expect(context, containsPair('serverpodVersion', templateVersion));
          expect(context, containsPair('agent', 'claude-code'));
          expect(context, containsPair('agentVersion', '2.0.0'));
          expect(context, containsPair('mcpVersion', '2025-06-18'));
          expect(context['dartVersion'], matches(RegExp(r'^\d+\.\d+\.\d+')));
          expect(context.values, everyElement(isA<String>()));
        },
      );

      test(
        'when sending a report without agent details, '
        'then the context leaves them out',
        () async {
          await reporter.send(_report);

          final body = jsonDecode(captured.body) as Map<String, dynamic>;
          expect(
            body['context'],
            isNot(anyOf(contains('agent'), contains('mcpVersion'))),
          );
        },
      );
    },
  );

  test(
    'Given a ServerpodIssueReporter with a service that rejects the report as invalid, '
    'when sending a report, '
    'then it is rejected with the service error message',
    () async {
      final reporter = _reporterResponding(400, {
        'error': '"description" is required.',
      });

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

  test(
    'Given a ServerpodIssueReporter with a service that fails internally, '
    'when sending a report, '
    'then it fails as retryable',
    () async {
      final reporter = _reporterResponding(500, {
        'error': 'Something went wrong.',
      });

      final result = await reporter.send(_report);

      expect(
        result,
        isA<ServerpodIssueReportFailed>()
            .having((r) => r.reason, 'reason', contains('HTTP 500'))
            .having((r) => r.retryable, 'retryable', isTrue),
      );
    },
  );

  test(
    'Given a ServerpodIssueReporter with a service that responds with an unexpected status, '
    'when sending a report, '
    'then it fails as not retryable',
    () async {
      final reporter = _reporterResponding(405);

      final result = await reporter.send(_report);

      expect(
        result,
        isA<ServerpodIssueReportFailed>()
            .having((r) => r.reason, 'reason', contains('HTTP 405'))
            .having((r) => r.retryable, 'retryable', isFalse),
      );
    },
  );

  test(
    'Given a ServerpodIssueReporter with an unreachable service, '
    'when sending a report, '
    'then it fails instead of throwing',
    () async {
      final reporter = ServerpodIssueReporter(
        url: _url,
        client: MockClient((_) => throw http.ClientException('refused')),
      );

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

  test(
    'Given a ServerpodIssueReporter with a service that never responds, '
    'when sending a report, '
    'then it fails as retryable once the timeout passes',
    () async {
      final reporter = ServerpodIssueReporter(
        url: _url,
        timeout: const Duration(milliseconds: 10),
        client: MockClient((_) => Completer<http.Response>().future),
      );

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
}
