import 'dart:io';

import 'package:package_config/package_config.dart';

class PackageBuilder {
  String _name = 'package_name';
  Uri _root = Directory.current.uri;
  Uri _packageUri = Uri.directory('lib/');

  /// Specifies the name of the package.
  PackageBuilder withName(String name) {
    _name = name;
    return this;
  }

  /// Specifies the root URI of the package.
  /// This must be a directory URI (ending with `/`).
  ///
  /// These can be built using the `Uri.directory` method.
  PackageBuilder withRoot(Uri rootDirectory) {
    _root = rootDirectory;
    return this;
  }

  /// Specifies the package URI, this is the path to the package within the root.
  /// For example, if the root is `lib/` and the package URI is `src/`, then
  /// the package will be located at `lib/src/`.
  PackageBuilder withPackageUri(Uri packageUri) {
    _packageUri = packageUri;
    return this;
  }

  Package build() {
    return Package(
      _name,
      _root,
      packageUriRoot: _root.resolveUri(_packageUri),
      relativeRoot: false,
    );
  }
}

class PackageConfigBuilder {
  final List<Package> _packages = [];

  PackageConfigBuilder addPackage(Package package) {
    _packages.add(package);
    return this;
  }

  PackageConfigBuilder withPackages(List<Package> packages) {
    _packages.addAll(packages);
    return this;
  }

  PackageConfig build() {
    return PackageConfig(_packages);
  }
}
