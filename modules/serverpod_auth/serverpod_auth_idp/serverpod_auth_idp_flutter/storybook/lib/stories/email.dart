import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/email_flow_story.dart';
import '../utils/story.dart';

final emailStories = [
  Story(
    name: 'Email/Password Only/Sign In/Login Screen',
    description:
        'Login form with email and password fields. Sign in with '
        '$storyEmail and $storyPassword.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.login,
      scenarios: _loginScenarios,
    ),
  ),
  Story(
    name: 'Email/Password Only/Sign Up/Register Screen',
    description: 'Registration form with email field and terms checkbox.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.startRegistration,
      scenarios: _registrationScenarios,
    ),
  ),
  Story(
    name: 'Email/Password Only/Sign Up/Verification Screen',
    description:
        'Verification form with verification code field. The code is '
        '$storyVerificationCode.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.startRegistration,
      scenarios: _verifyRegistrationScenarios,
    ),
  ),
  Story(
    name: 'Email/Password Only/Sign Up/Set Account Password Screen',
    description: 'Set account password form with password field.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.startRegistration,
      scenarios: _completeRegistrationScenarios,
    ),
  ),
  Story(
    name: 'Email/Password Only/Forgot Password/Password Reset Request Screen',
    description: 'Password reset request form with email field.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.login,
      scenarios: _requestPasswordResetScenarios,
    ),
  ),
  Story(
    name:
        'Email/Password Only/Forgot Password/Password Reset Verification Screen',
    description:
        'Password reset verification form with verification code field. The '
        'code is $storyVerificationCode.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.login,
      scenarios: _verifyPasswordResetScenarios,
    ),
  ),
  Story(
    name: 'Email/Password Only/Forgot Password/Complete Password Reset Screen',
    description: 'Complete password reset form with new password field.',
    builder: (context) => _buildEmailStory(
      context,
      startScreen: EmailFlowScreen.login,
      scenarios: _completePasswordResetScenarios,
    ),
  ),
  Story(
    name: 'Email/Verification Code Input',
    description: 'Verification code input field with varying lengths.',
    builder: (context) {
      return buildIsolatedElementsForStory(context, {
        '6 digits': [
          VerificationCodeInput(
            verificationCodeController: TextEditingController(),
            onCompleted: () {},
            isLoading: false,
            length: 6,
          ),
        ],
        '8 digits': [
          VerificationCodeInput(
            verificationCodeController: TextEditingController(),
            onCompleted: () {},
            isLoading: false,
            length: 8,
          ),
        ],
      });
    },
  ),
];

typedef _Scenario = EmailFlowScenario<EmailAuthController>;

Widget _buildEmailStory(
  BuildContext context, {
  required EmailFlowScreen startScreen,
  required List<_Scenario> scenarios,
}) {
  return buildEmailFlowStory<EmailAuthController>(
    context,
    scenarios: scenarios,
    configureServer: (server) =>
        server.seedAccount(email: storyEmail, password: storyPassword),
    createController: (client) => EmailAuthController(
      client: client,
      startScreen: startScreen,
      onAuthenticated: context.onStoryAuthenticated,
      onError: context.onStoryError,
    ),
    builder: (controller, onTermsAndConditionsPressed, onPrivacyPolicyPressed) {
      return EmailSignInWidget(
        controller: controller,
        onTermsAndConditionsPressed: onTermsAndConditionsPressed,
        onPrivacyPolicyPressed: onPrivacyPolicyPressed,
      );
    },
  );
}

final _loginScenarios = [
  _Scenario('Empty', (controller, server) async {}),
  _Scenario('Invalid email', (controller, server) async {
    await enterEmail(controller, 'not-an-email');
  }),
  _Scenario('Wrong password', (controller, server) async {
    await enterEmail(controller);
    controller.passwordController.text = 'WrongPassword1!';
    await controller.login();
  }),
  _Scenario('Signing in', (controller, server) async {
    await enterEmail(controller);
    controller.passwordController.text = storyPassword;
    startPending(server, controller.login);
  }),
];

final _registrationScenarios = [
  _Scenario('Empty', (controller, server) async {}),
  _Scenario('Invalid email', (controller, server) async {
    await enterEmail(controller, 'not-an-email');
  }),
  _Scenario('Ready to continue', (controller, server) async {
    await enterEmail(controller, 'new.user@serverpod.dev');
    controller.legalNoticeAcceptedNotifier.value = true;
  }),
  _Scenario('Sending code', (controller, server) async {
    await enterEmail(controller, 'new.user@serverpod.dev');
    controller.legalNoticeAcceptedNotifier.value = true;
    startPending(server, controller.startRegistration);
  }),
];

Future<void> _startRegistration(EmailAuthController controller) async {
  await enterEmail(controller, 'new.user@serverpod.dev');
  controller.legalNoticeAcceptedNotifier.value = true;
  await controller.startRegistration();
}

final _verifyRegistrationScenarios = [
  _Scenario('Waiting for code', (controller, server) async {
    await _startRegistration(controller);
  }),
  _Scenario('Wrong code', (controller, server) async {
    await _startRegistration(controller);
    controller.verificationCodeController.text = 'zzzzzzzz';
    await controller.verifyRegistrationCode();
  }),
  _Scenario('Verifying code', (controller, server) async {
    await _startRegistration(controller);
    controller.verificationCodeController.text = storyVerificationCode;
    startPending(server, controller.verifyRegistrationCode);
  }),
];

Future<void> _verifyRegistration(EmailAuthController controller) async {
  await _startRegistration(controller);
  controller.verificationCodeController.text = storyVerificationCode;
  await controller.verifyRegistrationCode();
}

final _completeRegistrationScenarios = [
  _Scenario('Empty', (controller, server) async {
    await _verifyRegistration(controller);
  }),
  _Scenario('Password not meeting requirements', (controller, server) async {
    await _verifyRegistration(controller);
    controller.passwordController.text = 'weak';
  }),
  _Scenario('Valid password', (controller, server) async {
    await _verifyRegistration(controller);
    controller.passwordController.text = storyPassword;
  }),
  _Scenario('Creating account', (controller, server) async {
    await _verifyRegistration(controller);
    controller.passwordController.text = storyPassword;
    startPending(server, controller.finishRegistration);
  }),
];

final _requestPasswordResetScenarios = [
  _Scenario('Empty', (controller, server) async {
    controller.navigateTo(EmailFlowScreen.requestPasswordReset);
  }),
  _Scenario('Sending code', (controller, server) async {
    controller.navigateTo(EmailFlowScreen.requestPasswordReset);
    await enterEmail(controller);
    startPending(server, controller.startPasswordReset);
  }),
];

Future<void> _startPasswordReset(EmailAuthController controller) async {
  controller.navigateTo(EmailFlowScreen.requestPasswordReset);
  await enterEmail(controller);
  await controller.startPasswordReset();
}

final _verifyPasswordResetScenarios = [
  _Scenario('Waiting for code', (controller, server) async {
    await _startPasswordReset(controller);
  }),
  _Scenario('Wrong code', (controller, server) async {
    await _startPasswordReset(controller);
    controller.verificationCodeController.text = 'zzzzzzzz';
    await controller.verifyPasswordResetCode();
  }),
  _Scenario('Verifying code', (controller, server) async {
    await _startPasswordReset(controller);
    controller.verificationCodeController.text = storyVerificationCode;
    startPending(server, controller.verifyPasswordResetCode);
  }),
];

Future<void> _verifyPasswordReset(EmailAuthController controller) async {
  await _startPasswordReset(controller);
  controller.verificationCodeController.text = storyVerificationCode;
  await controller.verifyPasswordResetCode();
}

final _completePasswordResetScenarios = [
  _Scenario('Empty', (controller, server) async {
    await _verifyPasswordReset(controller);
  }),
  _Scenario('Valid password', (controller, server) async {
    await _verifyPasswordReset(controller);
    controller.passwordController.text = 'NewPassword123!';
  }),
  _Scenario('Saving password', (controller, server) async {
    await _verifyPasswordReset(controller);
    controller.passwordController.text = 'NewPassword123!';
    startPending(server, controller.finishPasswordReset);
  }),
];
