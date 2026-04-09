import 'dart:async';

import 'package:nocterm/nocterm.dart';

import 'shimmer.dart';

/// Splash screen showing ASCII art "Serverpod" with shimmer effect
/// and a subtitle with gradient on "ultimate".
class LoadingScreen extends StatefulComponent {
  const LoadingScreen({super.key, this.visible = true});

  final bool visible;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  static const _steps = 8;
  static const _stepDuration = Duration(milliseconds: 60);

  int _step = _steps;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer(
            highlightColor: highlightColor,
            baseColor: baseColor,
            child: AsciiText(
              'Serverpod',
              font: AsciiFont.standard,
              style: TextStyle(color: baseColor),
            ),
          ),
          const SizedBox(height: 1),
          _buildSubtitle(t),
        ],
      ),
    );
  }

  Component _buildSubtitle(double t) {
    final white = Color.lerp(Color.defaultColor, Colors.brightWhite, t)!;
    final dim = Color.lerp(Color.defaultColor, Colors.gray, t)!;

    // Gradient colors for "ultimate" (pink/purple spectrum).
    const gradientColors = [
      Color.fromRGB(180, 140, 200), // lavender
      Color.fromRGB(200, 130, 180), // pink-lavender
      Color.fromRGB(220, 120, 160), // rose
      Color.fromRGB(230, 120, 150), // pink
      Color.fromRGB(220, 130, 160), // rose
      Color.fromRGB(200, 140, 180), // pink-lavender
      Color.fromRGB(180, 150, 190), // lavender
      Color.fromRGB(170, 155, 195), // soft lavender
    ];

    final ultimateSpans = <InlineSpan>[
      for (var i = 0; i < 'ultimate'.length; i++)
        TextSpan(
          text: 'ultimate'[i],
          style: TextStyle(
            color: Color.lerp(
              Color.defaultColor,
              gradientColors[i],
              t,
            ),
            fontStyle: FontStyle.italic,
          ),
        ),
    ];

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'The ',
            style: TextStyle(color: white),
          ),
          ...ultimateSpans,
          TextSpan(
            text: ' backend for ',
            style: TextStyle(color: dim),
          ),
          TextSpan(
            text: 'Flutter',
            style: TextStyle(color: white),
          ),
        ],
      ),
    );
  }
}
