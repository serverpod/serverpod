import 'package:flutter/widgets.dart';

import '../anonymous/anonymous_sign_in_texts.dart';
import '../apple/apple_sign_in_texts.dart';
import '../email/email_sign_in_texts.dart';
import '../github/github_sign_in_texts.dart';
import '../google/google_sign_in_texts.dart';
import 'basic_sign_in_texts.dart';

/// Inherited widget that provides customizable sign-in texts.
class SignInLocalizationProvider extends InheritedWidget {
  /// Creates a new [SignInLocalizationProvider].
  const SignInLocalizationProvider({
    this.basic = BasicSignInTexts.defaults,
    this.email = EmailSignInTexts.defaults,
    this.apple = AppleSignInTexts.defaults,
    this.google = GoogleSignInTexts.defaults,
    this.github = GitHubSignInTexts.defaults,
    this.anonymous = AnonymousSignInTexts.defaults,
    required super.child,
    super.key,
  });

  /// Basic sign-in texts.
  final BasicSignInTexts basic;

  /// Texts for the email sign-in flow.
  final EmailSignInTexts email;

  /// Texts for the Apple Sign-In button.
  final AppleSignInTexts apple;

  /// Texts for the Google Sign-In button.
  final GoogleSignInTexts google;

  /// Texts for the GitHub Sign-In button.
  final GitHubSignInTexts github;

  /// Texts for anonymous sign-in.
  final AnonymousSignInTexts anonymous;

  /// Returns the nearest localization provider in the widget tree, if any.
  static SignInLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SignInLocalizationProvider>();
  }

  /// Returns the nearest localization provider in the widget tree.
  ///
  /// Throws a [StateError] if no provider is found.
  static SignInLocalizationProvider of(BuildContext context) {
    final localizations = maybeOf(context);
    if (localizations == null) {
      throw StateError('No SignInLocalizationProvider found in context');
    }
    return localizations;
  }

  @override
  bool updateShouldNotify(SignInLocalizationProvider oldWidget) {
    return oldWidget.basic != basic ||
        oldWidget.email != email ||
        oldWidget.apple != apple ||
        oldWidget.google != google ||
        oldWidget.github != github ||
        oldWidget.anonymous != anonymous;
  }
}
