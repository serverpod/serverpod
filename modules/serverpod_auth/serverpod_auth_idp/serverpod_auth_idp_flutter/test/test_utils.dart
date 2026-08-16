import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Hosts a widget with an optional shared [SignInButtonStyle] and an asset
/// bundle so brand SVGs resolve in tests.
class SignInButtonHost extends StatelessWidget {
  const SignInButtonHost({required this.child, this.style, super.key});

  final Widget child;
  final SignInButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    Widget tree = SignInLocalizationProvider(child: child);
    final style = this.style;
    if (style != null) {
      tree = SignInButtonStyleProvider(style: style, child: tree);
    }
    return DefaultAssetBundle(
      bundle: _SvgAssetBundle(),
      child: MaterialApp(home: Scaffold(body: tree)),
    );
  }
}

class _SvgAssetBundle extends CachingAssetBundle {
  static const _svgContent =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<rect width="24" height="24" fill="#000000"/>'
      '</svg>';

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(utf8.encode(_svgContent));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return _svgContent;
  }
}
