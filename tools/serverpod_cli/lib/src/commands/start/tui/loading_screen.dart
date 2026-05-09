import 'package:nocterm/nocterm.dart';
// ignore: implementation_imports
import 'package:nocterm/src/components/render_ascii_text.dart'
    show AsciiLayoutEngine;
import 'package:serverpod_cli/src/commands/tui/components.dart';
import 'package:serverpod_cli/src/commands/tui/shimmer.dart';
import 'package:serverpod_cli/src/commands/tui/unconstrained_box.dart';

/// Splash screen showing the Serverpod logo and ASCII art title
/// with shimmer effect, plus a subtitle with gradient on "ultimate".
class LoadingScreen extends StatefulComponent {
  const LoadingScreen({super.key, this.visible = true});

  final bool visible;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  static const _fadeDuration = Duration(milliseconds: 480);
  static const _chromeMargin = 6;
  static final _asciiSize = () {
    final r = AsciiLayoutEngine.layout(
      'Serverpod',
      const AsciiLayoutConfig(font: AsciiFont.standard),
    );
    return Size(r.width.toDouble(), r.height.toDouble());
  }();

  late final AnimationController _controller;
  bool _fadingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _fadeDuration,
      value: 1,
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void didUpdateComponent(LoadingScreen oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (!component.visible && oldComponent.visible && !_fadingOut) {
      _fadingOut = true;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final t = _controller.value;
    if (t <= 0 && _fadingOut) return const SizedBox.shrink();

    final baseColor = Color.lerp(Color.defaultColor, Colors.brightBlue, t)!;
    final highlightColor = Color.lerp(Color.defaultColor, Colors.white, t)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final neededWidth = _asciiSize.width + _chromeMargin;
        final neededHeight = (_asciiSize.height) + _chromeMargin;
        final fits =
            constraints.maxWidth >= neededWidth &&
            constraints.maxHeight >= neededHeight;

        final splash = fits
            ? _buildFancySplash(
                t: t,
                baseColor: baseColor,
                highlightColor: highlightColor,
              )
            : _buildPlainSplash(
                t: t,
                baseColor: baseColor,
                highlightColor: highlightColor,
              );

        return Center(
          child: BorderedBox(backgroundColor: Colors.black, child: splash),
        );
      },
    );
  }

  Component _buildFancySplash({
    required double t,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            highlightColor: highlightColor,
            baseColor: baseColor,
            child: UnconstrainedBox(
              child: AsciiText(
                'Serverpod',
                font: AsciiFont.standard,
                style: TextStyle(color: baseColor),
              ),
            ),
          ),
          const SizedBox(height: 1),
          _buildSubtitle(t),
        ],
      ),
    );
  }

  Component _buildPlainSplash({
    required double t,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer(
          highlightColor: highlightColor,
          baseColor: baseColor,
          child: Text(
            'Serverpod',
            style: TextStyle(color: baseColor, fontWeight: FontWeight.bold),
          ),
        ),
        _buildSubtitle(t),
      ],
    );
  }

  Component _buildSubtitle(double t) {
    final white = Color.lerp(Color.defaultColor, Colors.brightWhite, t)!;
    final dim = Color.lerp(Color.defaultColor, Colors.gray, t)!;

    const gradientColors = [
      Color.fromRGB(180, 140, 200),
      Color.fromRGB(200, 130, 180),
      Color.fromRGB(220, 120, 160),
      Color.fromRGB(230, 120, 150),
      Color.fromRGB(220, 130, 160),
      Color.fromRGB(200, 140, 180),
      Color.fromRGB(180, 150, 190),
      Color.fromRGB(170, 155, 195),
    ];

    final ultimateSpans = <InlineSpan>[
      for (var i = 0; i < 'ultimate'.length; i++)
        TextSpan(
          text: 'ultimate'[i],
          style: TextStyle(
            color: Color.lerp(Color.defaultColor, gradientColors[i], t),
            fontStyle: FontStyle.italic,
          ),
        ),
    ];

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: ' The ',
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
