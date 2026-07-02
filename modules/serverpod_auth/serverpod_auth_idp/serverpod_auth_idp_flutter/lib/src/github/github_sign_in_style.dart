/// The type of GitHub Sign-In button to render.
enum GitHubButtonType {
  /// A standard button with text and logo.
  standard,

  /// An icon-only button with just the GitHub logo.
  icon,
}

/// The brand color preset of the GitHub Sign-In button.
///
/// Applies only when the button stands on its own; inside a [SignInWidget] the
/// shared common style takes over.
enum GitHubButtonStyle {
  /// Black background with white text (GitHub's default).
  black,

  /// White background with black text.
  white,
}
