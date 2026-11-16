import 'dart:js_interop';

const _styleId = 'serverpod-auth-one-time-code-input';

/// Gives the browser inputs of one-time codes a 16px font.
///
/// iOS Safari zooms the page into a tapped input whose font is smaller than
/// 16px. Flutter copies the font of a focused text field to its browser input,
/// and Pinput gives its hidden text field a 1px font, so tapping the pins zooms
/// the page in up to 5 times. Flutter marks the browser input with the autofill
/// hint of the text field, which lets this rule change only one-time codes. The
/// text of these inputs is transparent, so the size has no visible effect.
const _style =
    'flt-text-editing-host input[autocomplete="one-time-code"] '
    '{ font-size: 16px !important; }';

/// Keeps iOS Safari from zooming into the inputs of one-time codes.
///
/// Adds a style to the page, unless it is already there.
void ensureOneTimeCodeInputStyle() {
  if (_document.getElementById(_styleId) != null) return;
  final style = _document.createElement('style')
    ..id = _styleId
    ..textContent = _style;
  _document.head?.append(style);
}

@JS('document')
external _Document get _document;

extension type _Document._(JSObject _) implements JSObject {
  external _Element? get head;
  external _Element createElement(String tagName);
  external _Element? getElementById(String id);
}

extension type _Element._(JSObject _) implements JSObject {
  external set id(String value);
  external set textContent(String value);
  external void append(_Element node);
}
