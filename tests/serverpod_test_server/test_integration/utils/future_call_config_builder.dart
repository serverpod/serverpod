import 'package:serverpod_shared/serverpod_shared.dart';

class FutureCallConfigBuilder {
  int? _concurrencyLimit = 1;
  Duration _scanInterval = const Duration(milliseconds: 5000);

  FutureCallConfigBuilder();

  FutureCallConfig build() {
    return FutureCallConfig(
      concurrencyLimit: _concurrencyLimit,
      scanInterval: _scanInterval,
    );
  }

  FutureCallConfigBuilder withConcurrencyLimit(int? concurrencyLimit) {
    _concurrencyLimit = concurrencyLimit;
    return this;
  }

  FutureCallConfigBuilder withScanInterval(Duration scanInterval) {
    _scanInterval = scanInterval;
    return this;
  }
}
