import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A [Text] widget with tappable links. The [text] is parsed and url links are
/// styled and made tappable. On tap, they will open the url in the default
/// browser.
class TextWithLinks extends StatefulWidget {
  /// The text to render.
  final String text;

  /// Color of the links.
  final Color linkColor;

  /// Style of the text.
  final TextStyle style;

  /// If true, the text will be selectable.
  final bool selectable;

  /// Creates a new [TextWithLinks].
  const TextWithLinks(
    this.text, {
    required this.linkColor,
    required this.style,
    this.selectable = false,
    super.key,
  });

  @override
  TextWithLinksState createState() => TextWithLinksState();
}

/// The state of [TextWithLinks].
class TextWithLinksState extends State<TextWithLinks> {
  @override
  Widget build(BuildContext context) {
    var textSpan = _buildTextSpanForText(widget.text, widget.style);
    if (widget.selectable) {
      return SelectableText.rich(textSpan);
    } else {
      return RichText(text: textSpan);
    }
  }

  final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    if (_recognizers.isEmpty) return;
    var localRecognizers = List<GestureRecognizer>.from(_recognizers);
    _recognizers.clear();
    for (var recognizer in localRecognizers) {
      recognizer.dispose();
    }
  }

  TextSpan _buildTextSpanForText(String text, TextStyle style) {
    // Dispose any old recognizers
    _disposeRecognizers();

    var exp = RegExp('(https?://[^\\s]+)');
    Iterable<Match> matches = exp.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(
        text: text,
        style: style,
      );
    }

    var segments = <TextSpan>[];
    var lastPos = 0;

    for (var m in matches) {
      // Add non link
      segments.add(TextSpan(text: text.substring(lastPos, m.start)));

      // Add link
      var href = text.substring(m.start, m.end);

      var recognizer = TapGestureRecognizer()
        ..onTap = () {
          launchUrl(Uri.parse(href));
        };
      _recognizers.add(recognizer);

      segments.add(TextSpan(
        text: text.substring(m.start, m.end),
        style: TextStyle(color: widget.linkColor),
        recognizer: recognizer,
      ));

      lastPos = m.end;
    }

    // Add ending
    if (lastPos != text.length) {
      segments.add(TextSpan(text: text.substring(lastPos, text.length)));
    }

    return TextSpan(
      children: segments,
      style: style,
    );
  }
}
