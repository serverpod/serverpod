import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';
import 'package:storybook/utils/client.dart';
import 'package:storybook/utils/notification.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final emailStories = [
  Story(
    name: 'Email/Sign In/Login Screen',
    description: 'Login form with email and password fields.',
    builder: (context) => _buildEmailStory(context, EmailFlowScreen.login),
  ),
  Story(
    name: 'Email/Sign Up/Register Screen',
    description: 'Registration form with email and password fields.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.startRegistration),
  ),
  Story(
    name: 'Email/Sign Up/Verification Screen',
    description: 'Verification form with verification code field.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.verifyRegistration),
  ),
  Story(
    name: 'Email/Sign Up/Set Account Password Screen',
    description: 'Set account password form with password field.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.completeRegistration),
  ),
  Story(
    name: 'Email/Forgot Password/Password Reset Request Screen',
    description: 'Password reset request form with email field.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.requestPasswordReset),
  ),
  Story(
    name: 'Email/Forgot Password/Password Reset Verification Screen',
    description:
        'Password reset verification form with verification code field.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.verifyPasswordReset),
  ),
  Story(
    name: 'Email/Forgot Password/Complete Password Reset Screen',
    description: 'Complete password reset form with new password field.',
    builder: (context) =>
        _buildEmailStory(context, EmailFlowScreen.completePasswordReset),
  ),
  Story(
    name: 'Email/Widgets/Verification Code Input',
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

Widget _buildEmailStory(BuildContext context, EmailFlowScreen screen) {
  final width = context.knobs.sliderInt(
    label: 'Column width',
    initial: 300,
    min: 270,
    max: 400,
  );

  final showTermsAndPrivacyPolicy = context.knobs.boolean(
    label: 'Show "Terms and Conditions" and "Privacy Policy" checkbox notice.',
    initial: true,
  );

  return wrapWidgetInDefaultColumn([
    Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: EmailSignInWidget(
        client: context.read<Client>(),
        startScreen: screen,
        onError: (error) {
          context.showErrorSnackBar(error.toString());
        },
        onAuthenticated: () {
          context.showSuccessSnackBar('Authenticated with email!');
        },
        onTermsAndConditionsPressed: showTermsAndPrivacyPolicy ? () {} : null,
        onPrivacyPolicyPressed: showTermsAndPrivacyPolicy ? () {} : null,
      ),
    ),
  ], width: width.toDouble());
}
