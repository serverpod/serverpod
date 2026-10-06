import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'email_passwordless_test_utils.dart';

void main() {
  late PasswordlessTestClient client;
  late List<Object> errors;
  late int authenticatedCount;
  late EmailPasswordlessAuthController controller;

  setUp(() {
    client = PasswordlessTestClient();
    errors = [];
    authenticatedCount = 0;
    controller = EmailPasswordlessAuthController(
      client: client,
      onAuthenticated: () => authenticatedCount++,
      onError: errors.add,
    );
  });

  tearDown(() => controller.dispose());

  test(
    'Given a new controller, '
    'when reading its state, '
    'then it is idle on the start screen without a pending request.',
    () {
      expect(controller.currentScreen, EmailPasswordlessFlowScreen.start);
      expect(controller.state, EmailAuthState.idle);
      expect(controller.error, isNull);
    },
  );

  test(
    'Given a valid email address, '
    'when starting the login, '
    'then the trimmed email is sent and the verify screen is shown.',
    () async {
      controller.emailController.text = ' user@example.com ';

      await controller.startLogin();

      expect(client.passwordless!.startedEmails, ['user@example.com']);
      expect(controller.currentScreen, EmailPasswordlessFlowScreen.verify);
      expect(controller.state, EmailAuthState.idle);
    },
  );

  test(
    'Given a started login, '
    'when finishing it with the code, '
    'then the request id and the code are sent, the session is updated and '
    'onAuthenticated is called.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startLogin();
      controller.verificationCodeController.text = ' 123456 ';

      await controller.finishLogin();

      final finished = client.passwordless!.finishedRequests.single;
      expect(finished.id, client.passwordless!.nextRequestId);
      expect(finished.code, '123456');
      expect(controller.state, EmailAuthState.authenticated);
      expect(client.auth.isAuthenticated, isTrue);
      expect(authenticatedCount, 1);
      expect(errors, isEmpty);
    },
  );

  test(
    'Given an invalid email address, '
    'when starting the login, '
    'then the server is not called and the invalid email error is shown.',
    () async {
      controller.emailController.text = 'not-an-email';

      await controller.startLogin();

      expect(client.passwordless!.startedEmails, isEmpty);
      expect(controller.currentScreen, EmailPasswordlessFlowScreen.start);
      expect(controller.error, isA<InvalidEmailException>());
      expect(errors.single, isA<InvalidEmailException>());
    },
  );

  test(
    'Given an email address with an alias, '
    'when starting the login with the default validation, '
    'then the alias is rejected.',
    () async {
      controller.emailController.text = 'user+alias@example.com';

      await controller.startLogin();

      expect(client.passwordless!.startedEmails, isEmpty);
      expect(controller.error, isA<InvalidEmailException>());
    },
  );

  test(
    'Given a custom email validation, '
    'when starting the login, '
    'then it is used instead of the default.',
    () async {
      final custom = EmailPasswordlessAuthController(
        client: client,
        emailValidation: (_) {},
      );
      addTearDown(custom.dispose);
      custom.emailController.text = 'user+alias@example.com';

      await custom.startLogin();

      expect(client.passwordless!.startedEmails, ['user+alias@example.com']);
    },
  );

  test(
    'Given a rate limited email address, '
    'when starting the login, '
    'then it stays on the start screen with a user facing error.',
    () async {
      client.passwordless!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.rateLimited,
      );
      controller.emailController.text = 'user@example.com';

      await controller.startLogin();

      expect(controller.currentScreen, EmailPasswordlessFlowScreen.start);
      expect(controller.state, EmailAuthState.error);
      expect(
        errors.single.toString(),
        'Too many codes have been requested. Please try again later.',
      );
    },
  );

  for (final (reason, message) in [
    (
      idp.EmailPasswordlessLoginExceptionReason.invalid,
      'Invalid verification code. Please check and try again, or request a '
          'new code.',
    ),
    (
      idp.EmailPasswordlessLoginExceptionReason.expired,
      'The verification code has expired. Please request a new one.',
    ),
    (
      idp.EmailPasswordlessLoginExceptionReason.tooManyAttempts,
      'Too many failed attempts. Please request a new code.',
    ),
  ]) {
    test(
      'Given the server rejects the code with ${reason.name}, '
      'when finishing the login, '
      'then the error is shown and the user is not authenticated.',
      () async {
        controller.emailController.text = 'user@example.com';
        await controller.startLogin();
        client.passwordless!.finishError = idp.EmailPasswordlessLoginException(
          reason: reason,
        );
        controller.verificationCodeController.text = '000000';

        await controller.finishLogin();

        expect(controller.currentScreen, EmailPasswordlessFlowScreen.verify);
        expect(controller.state, EmailAuthState.error);
        expect(errors.single.toString(), message);
        expect(authenticatedCount, 0);
        expect(client.auth.isAuthenticated, isFalse);
      },
    );
  }

  test(
    'Given no login was started, '
    'when finishing the login, '
    'then an error state is set without a user facing error.',
    () async {
      controller.verificationCodeController.text = '123456';

      await controller.finishLogin();

      expect(controller.state, EmailAuthState.error);
      expect(errors, isEmpty);
      expect(client.passwordless!.finishedRequests, isEmpty);
    },
  );

  test(
    'Given the verify screen, '
    'when resending the code, '
    'then a new login request is started for the same email, the screen '
    'stays and the entered code is kept.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startLogin();
      controller.verificationCodeController.text = '12';
      final newId = UuidValue.fromString(
        '00000000-0000-4000-8000-0000000000bb',
      );
      client.passwordless!.nextRequestId = newId;

      await controller.resendVerificationCode();
      expect(controller.verificationCodeController.text, '12');
      controller.verificationCodeController.text = '123456';
      await controller.finishLogin();

      expect(client.passwordless!.startedEmails, [
        'user@example.com',
        'user@example.com',
      ]);
      expect(client.passwordless!.finishedRequests.single.id, newId);
    },
  );

  test(
    'Given the start screen, '
    'when resending the code, '
    'then a StateError is thrown.',
    () async {
      expect(controller.resendVerificationCode(), throwsStateError);
    },
  );

  test(
    'Given the verify screen, '
    'when navigating to the start screen, '
    'then the pending request is discarded and the code is cleared.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startLogin();
      controller.verificationCodeController.text = '123456';

      controller.navigateToStart();
      await controller.finishLogin();

      expect(controller.currentScreen, EmailPasswordlessFlowScreen.start);
      expect(controller.verificationCodeController.text, isEmpty);
      expect(client.passwordless!.finishedRequests, isEmpty);
    },
  );

  test(
    'Given a login request id from elsewhere, '
    'when navigating to the verify screen with it, '
    'then finishing the login uses that id.',
    () async {
      final id = UuidValue.fromString('00000000-0000-4000-8000-0000000000cc');
      controller.navigateToVerify(loginRequestId: id);
      controller.verificationCodeController.text = '123456';

      await controller.finishLogin();

      expect(client.passwordless!.finishedRequests.single.id, id);
    },
  );

  test(
    'Given a listener, '
    'when starting the login, '
    'then it is notified of the loading state and of the result.',
    () async {
      final states = <EmailAuthState>[];
      controller.addListener(() => states.add(controller.state));
      controller.emailController.text = 'user@example.com';
      states.clear();

      await controller.startLogin();

      expect(states, [EmailAuthState.loading, EmailAuthState.idle]);
    },
  );

  test(
    'Given an endpoint that is not registered, '
    'when starting the login, '
    'then an error state is set without a user facing error.',
    () async {
      final bare = EmailPasswordlessAuthController(
        client: PasswordlessTestClient(withPasswordless: false),
        onError: errors.add,
      );
      addTearDown(bare.dispose);
      bare.emailController.text = 'user@example.com';

      await bare.startLogin();

      expect(bare.state, EmailAuthState.error);
      expect(errors, isEmpty);
    },
  );

  test(
    'Given the controller implements EmailCodeFormController, '
    'when used as that type, '
    'then it is a Listenable.',
    () {
      expect(controller, isA<EmailCodeFormController>());
      expect(controller, isA<Listenable>());
    },
  );
}
