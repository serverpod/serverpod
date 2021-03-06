import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextWithLinks extends StatefulWidget {
  final String text;
  final Color linkColor;
  final TextStyle style;
  final bool selectable;

  const TextWithLinks(
    this.text, {
    required this.linkColor,
    required this.style,
    this.selectable = false,
    Key? key,
  }) : super(key: key);

  @override
  _TextWithLinksState createState() => _TextWithLinksState();
}

class _TextWithLinksState extends State<TextWithLinks> {
  @override
  Widget build(BuildContext context) {
    var textSpan = _buildTextSpanForText(widget.text, widget.style);
    if (widget.selectable)
      return SelectableText.rich(textSpan);
    else
      return RichText(text: textSpan);
  }

  final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    if (_recognizers.isEmpty) return;
    final localRecognizers = List<GestureRecognizer>.from(_recognizers);
    _recognizers.clear();
    for (var recognizer in localRecognizers) recognizer.dispose();
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

      final recognizer = TapGestureRecognizer()
        ..onTap = () {
          print('Tapped: $href');
          launch(href);
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
