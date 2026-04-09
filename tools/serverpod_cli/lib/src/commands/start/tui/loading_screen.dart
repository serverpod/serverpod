import 'dart:async';

import 'package:nocterm/nocterm.dart';

import 'shimmer.dart';

/// Splash screen showing ASCII art "Serverpod" with shimmer effect.
/// Fades out when [visible] becomes false.
class LoadingScreen extends StatefulComponent {
  const LoadingScreen({super.key, this.visible = true});

  final bool visible;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  static const _steps = 8;
  static const _stepDuration = Duration(milliseconds: 60);

  int _step = _steps; // Start fully visible.
  Timer? _timer;
  bool _fadingOut = false;

  @override
  void didUpdateComponent(LoadingScreen oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (!component.visible && oldComponent.visible && !_fadingOut) {
      _startFadeOut();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startFadeOut() {
    _timer?.cancel();
    _fadingOut = true;
    _timer = Timer.periodic(_stepDuration, (_) {
      setState(() {
        _step--;
        if (_step <= 0) {
          _step = 0;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Component build(BuildContext context) {
    if (_step <= 0 && _fadingOut) return const SizedBox.shrink();

    final t = _step / _steps;
    final baseColor = Color.lerp(Color.defaultColor, Colors.brightWhite, t)!;
    final highlightColor = Color.lerp(Color.defaultColor, Colors.cyan, t)!;

    return Center(
      child: Shimmer(
        highlightColor: highlightColor,
        baseColor: baseColor,
        child: AsciiText(
          'Serverpod',
          font: AsciiFont.standard,
          style: TextStyle(color: baseColor),
        ),
      ),
    );
  }
}
