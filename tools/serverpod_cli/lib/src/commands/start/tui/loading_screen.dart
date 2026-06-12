import 'package:nocterm/nocterm.dart';
// ignore: implementation_imports
import 'package:nocterm/src/components/render_ascii_text.dart'
    show AsciiLayoutEngine;
import 'package:serverpod_tui/serverpod_tui.dart';

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
    final theme = ServerpodTheme.of(context);
    final t = _controller.value;
    // Hidden when not visible, unless a fade-out is still in flight. The
    // explicit !visible check matters: ancestors changing their tree shape
    // (e.g. the Ctrl-C hint row appearing, or NoctermApp wrapping the app
    // once theme detection lands) remount this component, and a fresh mount
    // with visible=false never sees the true->false transition that arms
    // the fade - without this guard it would render the splash forever.
    if (!component.visible && (!_fadingOut || t <= 0)) {
      return const SizedBox.shrink();
    }

    final baseColor = Color.lerp(Color.defaultColor, theme.primary, t)!;
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
          child: BorderedBox(
            backgroundColor: Color.defaultColor,
            child: splash,
          ),
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
      child: Shimmer(
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
    );
  }

  Component _buildPlainSplash({
    required double t,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Shimmer(
        highlightColor: highlightColor,
        baseColor: baseColor,
        child: Text(
          'Serverpod',
          style: TextStyle(color: baseColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
