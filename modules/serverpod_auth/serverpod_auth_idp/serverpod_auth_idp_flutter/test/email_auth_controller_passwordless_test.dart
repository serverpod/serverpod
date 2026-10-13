import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'email_auth_test_utils.dart';

void main() {
  late EmailTestClient client;
  late List<Object> errors;
  late int authenticatedCount;
  late EmailAuthController controller;

  setUp(() {
    client = EmailTestClient();
    errors = [];
    authenticatedCount = 0;
    controller = EmailAuthController(
      client: client,
      startScreen: EmailFlowScreen.passwordlessStart,
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
      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
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

      await controller.startPasswordlessLogin();

      expect(client.email!.startedEmails, ['user@example.com']);
      expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
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
      await controller.startPasswordlessLogin();
      controller.verificationCodeController.text = ' 123456 ';

      await controller.finishPasswordlessLogin();

      final finished = client.email!.finishedRequests.single;
      expect(finished.id, client.email!.nextRequestId);
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

      await controller.startPasswordlessLogin();

      expect(client.email!.startedEmails, isEmpty);
      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
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

      await controller.startPasswordlessLogin();

      expect(client.email!.startedEmails, isEmpty);
      expect(controller.error, isA<InvalidEmailException>());
    },
  );

  test(
    'Given a custom email validation, '
    'when starting the login, '
    'then it is used instead of the default.',
    () async {
      final custom = EmailAuthController(
        client: client,
        startScreen: EmailFlowScreen.passwordlessStart,
        emailValidation: (_) {},
      );
      addTearDown(custom.dispose);
      custom.emailController.text = 'user+alias@example.com';

      await custom.startPasswordlessLogin();

      expect(client.email!.startedEmails, ['user+alias@example.com']);
    },
  );

  test(
    'Given a rate limited email address, '
    'when starting the login, '
    'then it stays on the start screen with a user facing error.',
    () async {
      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.rateLimited,
      );
      controller.emailController.text = 'user@example.com';

      await controller.startPasswordlessLogin();

      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
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
        await controller.startPasswordlessLogin();
        client.email!.finishError = idp.EmailPasswordlessLoginException(
          reason: reason,
        );
        controller.verificationCodeController.text = '000000';

        await controller.finishPasswordlessLogin();

        expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
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

      await controller.finishPasswordlessLogin();

      expect(controller.state, EmailAuthState.error);
      expect(errors, isEmpty);
      expect(client.email!.finishedRequests, isEmpty);
    },
  );

  test(
    'Given the verify screen, '
    'when resending the code, '
    'then a new login request is started for the same email, the screen '
    'stays and the entered code is kept.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      controller.verificationCodeController.text = '12';
      final newId = UuidValue.fromString(
        '00000000-0000-4000-8000-0000000000bb',
      );
      client.email!.nextRequestId = newId;

      await controller.resendVerificationCode();
      expect(controller.verificationCodeController.text, '12');
      controller.verificationCodeController.text = '123456';
      await controller.finishPasswordlessLogin();

      expect(client.email!.startedEmails, [
        'user@example.com',
        'user@example.com',
      ]);
      expect(client.email!.finishedRequests.single.id, newId);
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
    'then the code is cleared and the login can not be finished from there.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      controller.verificationCodeController.text = '123456';

      controller.navigateTo(EmailFlowScreen.passwordlessStart);
      await controller.finishPasswordlessLogin();

      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
      expect(controller.verificationCodeController.text, isEmpty);
      expect(client.email!.finishedRequests, isEmpty);
    },
  );

  test(
    'Given a login request id from elsewhere, '
    'when navigating to the verify screen with it, '
    'then finishing the login uses that id.',
    () async {
      final id = UuidValue.fromString('00000000-0000-4000-8000-0000000000cc');
      controller.navigateTo(
        EmailFlowScreen.passwordlessVerify,
        requestId: id,
      );
      controller.verificationCodeController.text = '123456';

      await controller.finishPasswordlessLogin();

      expect(client.email!.finishedRequests.single.id, id);
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

      await controller.startPasswordlessLogin();

      expect(states, [EmailAuthState.loading, EmailAuthState.idle]);
    },
  );

  test(
    'Given an endpoint that is not registered, '
    'when starting the login, '
    'then an error state is set without a user facing error.',
    () async {
      final bare = EmailAuthController(
        client: EmailTestClient(withEmail: false),
        startScreen: EmailFlowScreen.passwordlessStart,
        onError: errors.add,
      );
      addTearDown(bare.dispose);
      bare.emailController.text = 'user@example.com';

      await bare.startPasswordlessLogin();

      expect(bare.state, EmailAuthState.error);
      expect(errors, isEmpty);
    },
  );

  test(
    'Given a started login, '
    'when the state is reset, '
    'then the login request is forgotten and can not be finished.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();

      controller.resetState();
      controller.verificationCodeController.text = '123456';
      await controller.finishPasswordlessLogin();

      expect(controller.state, EmailAuthState.error);
      expect(client.email!.finishedRequests, isEmpty);
    },
  );

  test(
    'Given the verify screen, '
    'when navigating back, '
    'then the passwordless start screen is shown.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();

      expect(controller.navigateBack(), isTrue);

      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
      expect(controller.canNavigateBack, isFalse);
    },
  );

  test(
    'Given a controller starting on the login screen, '
    'when navigating to the passwordless start screen and back, '
    'then the login screen is shown again.',
    () {
      final own = EmailAuthController(client: client);
      addTearDown(own.dispose);

      own.navigateTo(EmailFlowScreen.passwordlessStart);
      expect(own.canNavigateBack, isTrue);
      own.navigateBack();

      expect(own.currentScreen, EmailFlowScreen.login);
    },
  );

  test(
    'Given a resend cooldown on the start screen, '
    'when navigating to another screen, '
    'then the cooldown notice is reset.',
    () async {
      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.resendCooldown,
      );
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      expect(controller.resendCooldownActive, isTrue);

      controller.navigateTo(EmailFlowScreen.login);

      expect(controller.resendCooldownActive, isFalse);
    },
  );

  for (final reason in [
    idp.EmailPasswordlessLoginExceptionReason.invalidEmail,
    idp.EmailPasswordlessLoginExceptionReason.unknown,
  ]) {
    test(
      'Given the server fails with ${reason.name}, '
      'when starting the login, '
      'then a user facing error is reported.',
      () async {
        client.email!.startError = idp.EmailPasswordlessLoginException(
          reason: reason,
        );
        controller.emailController.text = 'user@example.com';

        await controller.startPasswordlessLogin();

        expect(controller.state, EmailAuthState.error);
        expect(errors.single.toString(), isNotEmpty);
        expect(
          errors.single,
          isNot(isA<idp.EmailPasswordlessLoginException>()),
        );
      },
    );
  }
  group('Given the server refuses a new code within its resend cooldown', () {
    final cooldown = idp.EmailPasswordlessLoginException(
      reason: idp.EmailPasswordlessLoginExceptionReason.resendCooldown,
    );
    final firstId = UuidValue.fromString(
      '00000000-0000-4000-8000-0000000000aa',
    );

    setUp(() async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      client.email!.startError = cooldown;
    });

    test(
      'when resending the code, '
      'then the stored request id is kept, the verify screen stays, and the '
      'cooldown is not reported as an error.',
      () async {
        await controller.resendVerificationCode();

        expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
        expect(controller.state, EmailAuthState.idle);
        expect(controller.resendCooldownActive, isTrue);
        expect(errors, isEmpty);

        client.email!.startError = null;
        controller.verificationCodeController.text = '123456';
        await controller.finishPasswordlessLogin();
        expect(client.email!.finishedRequests.single.id, firstId);
      },
    );

    test(
      'when the same email is entered again on the start screen, '
      'then the verify screen is shown and finishing uses the earlier id.',
      () async {
        controller.navigateTo(EmailFlowScreen.passwordlessStart);

        await controller.startPasswordlessLogin();

        expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
        expect(controller.resendCooldownActive, isTrue);
        expect(errors, isEmpty);

        client.email!.startError = null;
        controller.verificationCodeController.text = '123456';
        await controller.finishPasswordlessLogin();
        expect(client.email!.finishedRequests.single.id, firstId);
      },
    );

    test(
      'when the same email is entered in another case with spaces, '
      'then it is still the same email address.',
      () async {
        controller.navigateTo(EmailFlowScreen.passwordlessStart);
        controller.emailController.text = ' User@Example.com ';

        await controller.startPasswordlessLogin();

        expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
      },
    );

    test(
      'when another email is entered on the start screen, '
      'then the start screen stays with the cooldown notice, without an error '
      'and without replacing the stored id.',
      () async {
        controller.navigateTo(EmailFlowScreen.passwordlessStart);
        controller.emailController.text = 'other@example.com';

        await controller.startPasswordlessLogin();

        expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
        expect(controller.state, EmailAuthState.idle);
        expect(controller.resendCooldownActive, isTrue);
        expect(errors, isEmpty);

        controller.emailController.text = 'other2@example.com';
        expect(controller.resendCooldownActive, isFalse);
      },
    );

    test(
      'when the next request succeeds, '
      'then the notice is gone and the new id replaces the stored one.',
      () async {
        await controller.resendVerificationCode();
        final newId = UuidValue.fromString(
          '00000000-0000-4000-8000-0000000000dd',
        );
        client.email!
          ..startError = null
          ..nextRequestId = newId;

        await controller.resendVerificationCode();
        controller.verificationCodeController.text = '123456';
        await controller.finishPasswordlessLogin();

        expect(controller.resendCooldownActive, isFalse);
        expect(client.email!.finishedRequests.single.id, newId);
      },
    );
  });

  test(
    'Given a stored request, '
    'when a later request fails with another error, '
    'then the stored request id is kept.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.rateLimited,
      );
      client.email!.nextRequestId = UuidValue.fromString(
        '00000000-0000-4000-8000-0000000000ee',
      );

      await controller.resendVerificationCode();
      expect(controller.state, EmailAuthState.error);

      client.email!.startError = null;
      controller.verificationCodeController.text = '123456';
      await controller.finishPasswordlessLogin();

      expect(
        client.email!.finishedRequests.single.id,
        UuidValue.fromString('00000000-0000-4000-8000-0000000000aa'),
      );
    },
  );

  test(
    'Given the server used up the request, '
    'when finishing fails with tooManyAttempts, '
    'then entering the same email within the cooldown does not return to it.',
    () async {
      controller.emailController.text = 'user@example.com';
      await controller.startPasswordlessLogin();
      client.email!.finishError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.tooManyAttempts,
      );
      await controller.finishPasswordlessLogin();
      controller.navigateTo(EmailFlowScreen.passwordlessStart);
      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.resendCooldown,
      );

      await controller.startPasswordlessLogin();

      expect(controller.currentScreen, EmailFlowScreen.passwordlessStart);
    },
  );

  group('Given an action in progress', () {
    test(
      'when startPasswordlessLogin is called again, '
      'then the second call is ignored.',
      () async {
        final gate = Completer<void>();
        client.email!.startGate = gate;
        controller.emailController.text = 'user@example.com';

        final first = controller.startPasswordlessLogin();
        final second = controller.startPasswordlessLogin();
        gate.complete();
        await Future.wait([first, second]);

        expect(client.email!.startedEmails, hasLength(1));
        expect(controller.currentScreen, EmailFlowScreen.passwordlessVerify);
      },
    );

    test(
      'when finishPasswordlessLogin is called again, '
      'then the second call is ignored and onAuthenticated is called once.',
      () async {
        controller.emailController.text = 'user@example.com';
        await controller.startPasswordlessLogin();
        controller.verificationCodeController.text = '123456';
        final gate = Completer<void>();
        client.email!.finishGate = gate;

        final first = controller.finishPasswordlessLogin();
        final second = controller.finishPasswordlessLogin();
        final resend = controller.resendVerificationCode();
        gate.complete();
        await Future.wait([first, second, resend]);

        expect(client.email!.finishedRequests, hasLength(1));
        expect(client.email!.startedEmails, hasLength(1));
        expect(authenticatedCount, 1);
      },
    );
  });

  group('Given a disposed controller', () {
    late EmailAuthController own;
    late int ownAuthenticated;
    late List<Object> ownErrors;

    setUp(() {
      ownAuthenticated = 0;
      ownErrors = [];
      own = EmailAuthController(
        client: client,
        startScreen: EmailFlowScreen.passwordlessStart,
        onAuthenticated: () => ownAuthenticated++,
        onError: ownErrors.add,
      );
    });

    test(
      'when a startPasswordlessLogin call completes after dispose, '
      'then nothing is notified and nothing throws.',
      () async {
        final gate = Completer<void>();
        client.email!.startGate = gate;
        own.emailController.text = 'user@example.com';
        var notified = 0;
        own.addListener(() => notified++);

        final call = own.startPasswordlessLogin();
        final notifiedBeforeDispose = notified;
        own.dispose();
        gate.complete();
        await call;

        expect(notified, notifiedBeforeDispose);
      },
    );

    test(
      'when a failing call completes after dispose, '
      'then onError is not called.',
      () async {
        final gate = Completer<void>();
        client.email!
          ..startGate = gate
          ..startError = idp.EmailPasswordlessLoginException(
            reason: idp.EmailPasswordlessLoginExceptionReason.rateLimited,
          );
        own.emailController.text = 'user@example.com';

        final call = own.startPasswordlessLogin();
        own.dispose();
        gate.complete();
        await call;

        expect(ownErrors, isEmpty);
      },
    );

    test(
      'when finishPasswordlessLogin completes after dispose, '
      'then the user is signed in and onAuthenticated is still called.',
      () async {
        own.emailController.text = 'user@example.com';
        await own.startPasswordlessLogin();
        own.verificationCodeController.text = '123456';
        final gate = Completer<void>();
        client.email!.finishGate = gate;

        final call = own.finishPasswordlessLogin();
        own.dispose();
        gate.complete();
        await call;

        expect(client.auth.isAuthenticated, isTrue);
        expect(ownAuthenticated, 1);
      },
    );
  });

  testWidgets(
    'Given a network error, '
    'when the controller is disposed right away, '
    'then no timer is left running.',
    (tester) async {
      final own = EmailAuthController(
        client: client,
        startScreen: EmailFlowScreen.passwordlessStart,
      );
      client.email!.startError = const ServerpodClientNetworkException(
        'offline',
      );
      own.emailController.text = 'user@example.com';
      await own.startPasswordlessLogin();
      expect(own.state, EmailAuthState.error);

      own.dispose();
      await tester.pump(const Duration(seconds: 2));
    },
  );

  testWidgets(
    'Given an edited email address, '
    'when the controller is disposed before the debounce has elapsed, '
    'then no timer is left running and nothing throws.',
    (tester) async {
      final own = EmailAuthController(
        client: client,
        startScreen: EmailFlowScreen.passwordlessStart,
      );
      own.emailController.text = 'user@example.com';

      own.dispose();
      await tester.pump(const Duration(seconds: 2));
    },
  );
}
