import 'push_provider.dart';

/// Builds a [PushProvider] with its runtime dependencies.
abstract class PushProviderBuilder<T extends PushProvider> {
  /// Creates a builder.
  const PushProviderBuilder();

  /// The type of the provider this builder creates.
  Type get type => T;

  /// Builds a new provider instance.
  T build();
}

/// A builder that returns a pre-built provider.
class PreBuiltPushProviderBuilder<T extends PushProvider>
    extends PushProviderBuilder<T> {
  /// The already-constructed provider.
  final T provider;

  /// Creates a builder around [provider].
  const PreBuiltPushProviderBuilder(this.provider);

  @override
  T build() => provider;
}
