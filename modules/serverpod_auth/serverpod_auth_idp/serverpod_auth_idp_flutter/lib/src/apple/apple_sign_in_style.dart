/// The brand color preset of the Apple Sign-In button.
///
/// Applies only when the button stands on its own; inside a [SignInWidget] the
/// shared common style takes over.
enum AppleButtonStyle {
  /// Black background with a white logo and text (Apple's default).
  black,

  /// White background with a black logo and text.
  white,

  /// White background with a black logo and text, plus a black outline.
  whiteOutlined,
}
