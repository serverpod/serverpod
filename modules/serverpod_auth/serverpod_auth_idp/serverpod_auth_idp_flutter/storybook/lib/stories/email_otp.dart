import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/email_flow_story.dart';

final emailOtpStories = [
  Story(
    name: 'Email/OTP and Password/Start Screen',
    description:
        'Passwordless start form requesting a one-time password, with an '
        'optional password sign-in ($storyEmail / $storyPassword). The code '
        'is $storyOtpCode.',
    builder: (context) => _buildEmailOtpStory(
      context,
      scenarios: _startScenarios,
    ),
  ),
  Story(
    name: 'Email/OTP and Password/Verification Screen',
    description:
        'One-time password verification form, after a code was requested. '
        'The code is $storyOtpCode.',
    builder: (context) => _buildEmailOtpStory(
      context,
      scenarios: _verifyScenarios,
    ),
  ),
  Story(
    name: 'Email/OTP and Password/Create Account Screen',
    description:
        'Account creation after verifying a one-time password for an email '
        'without account.',
    builder: (context) => _buildEmailOtpStory(
      context,
      scenarios: _createAccountScenarios,
      accountExists: false,
    ),
  ),
  Story(
    name: 'Email/OTP and Password/Password Reset Screen',
    description:
        'Password reset opened from the password sign-in of the start screen. '
        'Going back to sign in returns to the start screen.',
    builder: (context) => _buildEmailOtpStory(
      context,
      scenarios: _passwordResetScenarios,
    ),
  ),
];

typedef _Scenario = EmailFlowScenario<EmailOtpAuthController>;

/// Builds a story of the [EmailOtpSignInWidget].
///
/// If [accountExists] is null, a knob chooses whether the entered email has an
/// account.
Widget _buildEmailOtpStory(
  BuildContext context, {
  required List<_Scenario> scenarios,
  bool? accountExists,
}) {
  final allowPasswordSignIn = context.knobs.boolean(
    label: 'Allow password sign-in.',
    initial: true,
  );

  final hasAccount =
      accountExists ??
      context.knobs.boolean(
        label: 'The email has an account.',
        description:
            'Existing accounts are signed in after verifying the code, new '
            'ones continue to account creation.',
        initial: true,
      );

  final allowPasswordOnRegistration = context.knobs.boolean(
    label: 'Server allows setting a password on account creation.',
    initial: false,
  );

  return buildEmailFlowStory<EmailOtpAuthController>(
    context,
    scenarios: scenarios,
    restartWhenChanged: [
      allowPasswordSignIn,
      hasAccount,
      allowPasswordOnRegistration,
    ],
    configureServer: (server) {
      server.allowPasswordOnOtpRegistration = allowPasswordOnRegistration;
      if (hasAccount) {
        server.seedAccount(email: storyEmail, password: storyPassword);
      }
    },
    createController: (client) => EmailOtpAuthController(
      client: client,
      allowPasswordSignIn: allowPasswordSignIn,
      onAuthenticated: context.onStoryAuthenticated,
      onError: context.onStoryError,
    ),
    builder: (controller, onTermsAndConditionsPressed, onPrivacyPolicyPressed) {
      return EmailOtpSignInWidget(
        controller: controller,
        onTermsAndConditionsPressed: onTermsAndConditionsPressed,
        onPrivacyPolicyPressed: onPrivacyPolicyPressed,
      );
    },
  );
}

final _startScenarios = [
  _Scenario('Empty', (controller, server) async {}),
  _Scenario('Email entered', (controller, server) async {
    await enterEmail(controller);
  }),
  _Scenario('Invalid email', (controller, server) async {
    await enterEmail(controller, 'not-an-email');
  }),
  _Scenario('Sending code', (controller, server) async {
    await enterEmail(controller);
    startPending(server, controller.startOtpLogin);
  }),
  _Scenario('Password sign-in', (controller, server) async {
    controller.togglePasswordSignIn();
    await enterEmail(controller);
  }),
  _Scenario('Password sign-in, wrong password', (controller, server) async {
    controller.togglePasswordSignIn();
    await enterEmail(controller);
    controller.passwordController.text = 'WrongPassword1!';
    await controller.login();
  }),
  _Scenario('Signing in with password', (controller, server) async {
    controller.togglePasswordSignIn();
    await enterEmail(controller);
    controller.passwordController.text = storyPassword;
    startPending(server, controller.login);
  }),
];

Future<void> _requestCode(
  EmailOtpAuthController controller, [
  String email = storyEmail,
]) async {
  await enterEmail(controller, email);
  await controller.startOtpLogin();
}

final _verifyScenarios = [
  _Scenario('Waiting for code', (controller, server) async {
    await _requestCode(controller);
  }),
  _Scenario('Wrong code', (controller, server) async {
    await _requestCode(controller);
    controller.verificationCodeController.text = '111111';
    await controller.verifyOtpCode();
  }),
  _Scenario('Verifying code', (controller, server) async {
    await _requestCode(controller);
    controller.verificationCodeController.text = storyOtpCode;
    startPending(server, controller.verifyOtpCode);
  }),
  _Scenario('Code no longer valid', (controller, server) async {
    server
      ..seedAccount(email: storyEmail, password: storyPassword)
      ..rejectNextOtpLogin = true;
    await _requestCode(controller);
    controller.verificationCodeController.text = storyOtpCode;
    await controller.verifyOtpCode();
  }),
];

Future<void> _verifyCodeForNewAccount(EmailOtpAuthController controller) async {
  await _requestCode(controller, 'new.user@serverpod.dev');
  controller.verificationCodeController.text = storyOtpCode;
  await controller.verifyOtpCode();
}

final _createAccountScenarios = [
  _Scenario('Terms not accepted', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
  }),
  _Scenario('Terms accepted', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
    controller.legalNoticeAcceptedNotifier.value = true;
  }),
  _Scenario('Password field shown', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
    controller.legalNoticeAcceptedNotifier.value = true;
    controller.toggleRegistrationPassword();
  }),
  _Scenario('Password not meeting requirements', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
    controller.legalNoticeAcceptedNotifier.value = true;
    controller.toggleRegistrationPassword();
    controller.passwordController.text = 'weak';
  }),
  _Scenario('Valid password', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
    controller.legalNoticeAcceptedNotifier.value = true;
    controller.toggleRegistrationPassword();
    controller.passwordController.text = storyPassword;
  }),
  _Scenario('Creating account', (controller, server) async {
    await _verifyCodeForNewAccount(controller);
    controller.legalNoticeAcceptedNotifier.value = true;
    startPending(server, controller.finishOtpRegistration);
  }),
];

final _passwordResetScenarios = [
  _Scenario('Empty', (controller, server) async {
    controller.togglePasswordSignIn();
    controller.navigateTo(EmailOtpFlowScreen.requestPasswordReset);
  }),
  _Scenario('Sending code', (controller, server) async {
    controller.togglePasswordSignIn();
    controller.navigateTo(EmailOtpFlowScreen.requestPasswordReset);
    await enterEmail(controller);
    startPending(server, controller.startPasswordReset);
  }),
];
