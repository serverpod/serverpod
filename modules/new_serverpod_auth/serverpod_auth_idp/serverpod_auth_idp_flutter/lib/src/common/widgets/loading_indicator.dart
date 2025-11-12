import 'package:flutter/material.dart';

/// A small circular progress indicator used to indicate background work.
///
/// This widget shows a compact [CircularProgressIndicator] sized to fit
/// inline with text or form controls.
class LoadingIndicator extends StatelessWidget {
  /// Creates a [LoadingIndicator].
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
