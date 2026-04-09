import 'dart:async';

import 'package:nocterm/nocterm.dart';

import 'shimmer.dart';

/// Loading screen shown during startup.
///
/// Displays ASCII art "Serverpod", an indeterminate progress bar, and a
/// status message describing the current startup step.
class LoadingScreen extends StatefulComponent {
  const LoadingScreen({super.key, required this.stage});

  final String stage;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Trigger rebuilds for the progress bar animation.
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Shimmer(
            highlightColor: Colors.cyan,
            baseColor: Colors.brightWhite,
            child: AsciiText('Serverpod', font: AsciiFont.standard),
          ),
          const SizedBox(height: 1),
          const SizedBox(
            width: 60,
            child: ProgressBar(indeterminate: true),
          ),
          const SizedBox(height: 1),
          Text(
            component.stage,
            style: const TextStyle(fontWeight: FontWeight.dim),
          ),
        ],
      ),
    );
  }
}
