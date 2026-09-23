import 'exceptions.dart';
import 'push_provider.dart';
import 'push_provider_builder.dart';

/// Global registry of [PushProvider]s used by enqueue and the dispatcher.
class PushService {
  /// Returns the singleton instance.
  static PushService get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError(
        'PushService is not set. Call PushService.set() to initialize it '
        'before accessing the instance.',
      );
    }
    return localInstance;
  }

  static PushService? _instance;

  /// Creates a new [PushService] and sets it as the global instance.
  static void set({
    required final List<PushProviderBuilder> providers,
  }) {
    _instance = PushService(providers: providers);
  }

  /// Clears the global instance. Intended for tests.
  static void reset() {
    _instance = null;
  }

  /// Creates a service from [providers]. Prefer [PushService.set] in
  /// application code.
  PushService({
    required final List<PushProviderBuilder> providers,
  }) {
    for (final builder in providers) {
      final provider = builder.build();
      if (provider.provider.isEmpty) {
        throw StateError(
          'Push provider ${provider.runtimeType} has an empty provider id.',
        );
      }
      final existing = _providers[provider.provider];
      if (existing != null) {
        throw StateError(
          'Push provider "${provider.provider}" is already registered by '
          '${existing.runtimeType}; cannot register ${provider.runtimeType}.',
        );
      }
      _providers[provider.provider] = provider;
    }
  }

  final Map<String, PushProvider> _providers = {};

  /// Registered providers.
  Iterable<PushProvider> get providers => _providers.values;

  /// Looks up a provider by id, or throws [PushUnknownProviderException].
  PushProvider providerByIdOrThrow(final String providerId) {
    final provider = _providers[providerId];
    if (provider == null) {
      throw PushUnknownProviderException(providerId);
    }
    return provider;
  }

  /// Looks up a provider by id, or `null` if it is not registered.
  PushProvider? providerById(final String providerId) => _providers[providerId];
}
