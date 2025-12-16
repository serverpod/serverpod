/*
 * This file is adapted from the original source on the `google_sign_ìn_web`
 * package and licensed under a BSD-style license.
 * Source: https://github.com/flutter/packages/blob/main/packages/google_sign_in/google_sign_in_web/lib/src/button_configuration.dart
 *
 * The scope of the below license ("Software") is limited to this file only,
 * which is a derivative work of the original package. The license does
 * not apply to any other part of the codebase.
 *
 * Copyright 2013 The Flutter Authors
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Google Inc. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
library;

import 'package:flutter/material.dart';

/// Stub for other platforms than web. To be used on conditional imports.
Widget renderButton({GSIButtonConfiguration? configuration}) {
  throw StateError('Can only call "renderButton" for Google sign-in on web.');
}

/// A class to configure the Google Sign-In Button for web.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#GsiButtonConfiguration
class GSIButtonConfiguration {
  /// Constructs a button configuration object.
  GSIButtonConfiguration({
    this.type,
    this.theme,
    this.size,
    this.text,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    this.locale,
  }) : assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  /// The button type: icon, or standard button.
  final GSIButtonType? type;

  /// The button theme.
  ///
  /// For example, filledBlue or filledBlack.
  final GSIButtonTheme? theme;

  /// The button size.
  ///
  /// For example, small or large.
  final GSIButtonSize? size;

  /// The button text.
  ///
  /// For example "Sign in with Google" or "Sign up with Google".
  final GSIButtonText? text;

  /// The button shape.
  ///
  /// For example, rectangular or circular.
  final GSIButtonShape? shape;

  /// The Google logo alignment: left or center.
  final GSIButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double? minimumWidth;

  /// The pre-set locale of the button text.
  ///
  /// If not set, the browser's default locale or the Google session user's
  /// preference is used.
  ///
  /// Different users might see different versions of localized buttons, possibly
  /// with different sizes.
  final String? locale;
}

/// The type of button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#type
enum GSIButtonType {
  /// A button with text or personalized information.
  standard,

  /// An icon button without text.
  icon,
}

/// The theme of the button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#theme
enum GSIButtonTheme {
  /// A standard button theme.
  outline,

  /// A blue-filled button theme.
  filledBlue,

  /// A black-filled button theme.
  filledBlack,
}

/// The size of the button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#size
enum GSIButtonSize {
  /// A large button (about 40px tall).
  large,

  /// A medium-sized button (about 32px tall).
  medium,

  /// A small button (about 20px tall).
  small,
}

/// The button text.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#text
enum GSIButtonText {
  /// The button text is "Sign in with Google".
  signinWith,

  /// The button text is "Sign up with Google".
  signupWith,

  /// The button text is "Continue with Google".
  continueWith,

  /// The button text is "Sign in".
  signin,
}

/// The button shape.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#shape
enum GSIButtonShape {
  /// The rectangular-shaped button.
  rectangular,

  /// The circle-shaped button.
  pill,
}

/// The alignment of the Google logo. The default value is left.
/// This attribute only applies to the standard button type.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#logo_alignment
enum GSIButtonLogoAlignment {
  /// Left-aligns the Google logo.
  left,

  /// Center-aligns the Google logo.
  center,
}
