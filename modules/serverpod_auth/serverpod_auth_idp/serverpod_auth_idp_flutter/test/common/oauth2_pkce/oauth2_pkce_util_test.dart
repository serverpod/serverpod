import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

final class MockException implements Exception {
  const MockException({required this.message, required this.code});

  final String message;
  final int code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MockException &&
        other.runtimeType == runtimeType &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => Object.hash(code, message);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final oauth = OAuth2PkceUtil(
    config: OAuth2PkceProviderClientConfig(
      authorizationEndpoint: Uri.https('example.com', '/authorize'),
      clientId: 'test-client',
      redirectUri: 'test-app://callback',
      callbackUrlScheme: 'test-app',
    ),
    useWebview: false,
  );

  const channel = MethodChannel('flutter_web_auth_2');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  group('PlatformExceptionHandler', () {
    test(
      'should throw [OAuth2PkceUserCancelledException] when oauth attempt '
      "throws [PlatformException(code: 'CANCELED')]",
      () async {
        messenger.setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'authenticate') {
            throw PlatformException(
              code: 'CANCELED',
              message: 'User canceled login',
            );
          }
          return null;
        });

        await expectLater(
          oauth.authorize(),
          throwsA(isA<OAuth2PkceUserCancelledException>()),
        );
      },
    );

    test(
      'should throw [OAuth2PkceUnknownException] when '
      "[PlatformException] is thrown with code not matching 'CANCELED'",
      () async {
        final exception = PlatformException(
          code: 'TIMEOUT',
          message: 'Attempt timed out.',
        );
        messenger.setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'authenticate') {
            throw exception;
          }
          return null;
        });

        await expectLater(
          oauth.authorize(),
          throwsA(
            isA<OAuth2PkceUnknownException>()
                .having(
                  (exception) => exception.rawException,
                  'rawException',
                  isA<PlatformException>()
                      .having(
                        (platformException) => platformException.code,
                        'code',
                        exception.code,
                      )
                      .having(
                        (platformException) => platformException.message,
                        'message',
                        exception.message,
                      ),
                )
                .having(
                  (exception) => exception.rawStackTrace,
                  'rawStackTrace',
                  isA<StackTrace>(),
                ),
          ),
        );
      },
    );
  });

  group('OAuth2PkceUnknownException', () {
    test(
      'should expose a [rawException] and [rawStackTrace] '
      'when wrapping an exception into an [OAuth2PkceUnknownException]',
      () async {
        const exception = MockException(
          message: 'Something went wrong',
          code: 911,
        );
        messenger.setMockMessageHandler(channel.name, (_) {
          throw exception;
        });

        await expectLater(
          oauth.authorize(),
          throwsA(
            isA<OAuth2PkceUnknownException>()
                .having(
                  (exception) => exception.rawException,
                  'rawException',
                  same(exception),
                )
                .having(
                  (exception) => exception.rawStackTrace,
                  'rawStackTrace',
                  isA<StackTrace>(),
                ),
          ),
        );
      },
    );
  });
}
