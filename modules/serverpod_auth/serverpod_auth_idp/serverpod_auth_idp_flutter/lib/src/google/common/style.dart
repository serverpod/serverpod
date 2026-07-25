/// The brand color preset of the Google Sign-In button.
///
/// Applies only when the button stands on its own; inside a [SignInWidget] the
/// shared common style takes over.
enum GoogleButtonStyle {
  /// White background with a light border and dark text (Google's default).
  outline,

  /// Google-blue background with white text.
  filledBlue,

  /// Black background with white text.
  filledBlack,
}
