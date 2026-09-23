import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Firebase service-account JSON map', () {
    test(
      'when fromJson is called with project_id only, then canSign is false.',
      () {
        final credentials = FirebaseServiceAccountCredentials.fromJson({
          'project_id': 'my-project',
        });
        expect(credentials.projectId, 'my-project');
        expect(credentials.canSign, isFalse);
      },
    );

    test(
      'when fromJson is called with client_email and private_key, '
      'then canSign is true and tokenUri defaults.',
      () {
        final credentials = FirebaseServiceAccountCredentials.fromJson({
          'project_id': 'my-project',
          'client_email': 'sa@my-project.iam.gserviceaccount.com',
          'private_key':
              '-----BEGIN PRIVATE KEY-----\nabc\n-----END PRIVATE KEY-----',
          'private_key_id': 'abc123',
        });
        expect(credentials.canSign, isTrue);
        expect(
          credentials.tokenUri,
          FirebaseServiceAccountCredentials.defaultTokenUri,
        );
        expect(credentials.privateKeyId, 'abc123');
      },
    );

    test(
      'when project_id is missing, then fromJson throws FormatException.',
      () {
        expect(
          () => FirebaseServiceAccountCredentials.fromJson({
            'type': 'service_account',
          }),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
