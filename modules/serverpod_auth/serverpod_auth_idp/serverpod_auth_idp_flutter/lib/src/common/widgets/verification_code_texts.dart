import 'package:flutter/widgets.dart';

import '../../localization/sign_in_localization_provider_widget.dart';

/// Localized strings shared by verification code controls in both email flows.
@immutable
class VerificationCodeTexts {
  /// Creates [VerificationCodeTexts].
  const VerificationCodeTexts({required this.resendCode});

  /// Default English strings.
  static const defaults = VerificationCodeTexts(
    resendCode: "Didn't receive? Send a new code",
  );

  /// Text for requesting a new code, followed by the remaining countdown.
  final String resendCode;

  /// Creates a copy with the given fields replaced.
  VerificationCodeTexts copyWith({String? resendCode}) {
    return VerificationCodeTexts(resendCode: resendCode ?? this.resendCode);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationCodeTexts && other.resendCode == resendCode;
  }

  @override
  int get hashCode => resendCode.hashCode;
}

/// Convenience getter for [VerificationCodeTexts] on [BuildContext].
extension VerificationCodeTextsBuildContextExtension on BuildContext {
  /// Returns the verification code texts from context or defaults.
  VerificationCodeTexts get verificationCodeTexts =>
      SignInLocalizationProvider.maybeOf(this)?.verificationCodeTexts ??
      VerificationCodeTexts.defaults;
}
