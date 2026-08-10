import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

void main() {
  testWidgets(
    'Given a theme with a custom body text color, '
    'when building TermsAndPrivacyText, '
    'then the plain text runs inherit the themed color.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          home: Scaffold(
            body: TermsAndPrivacyText(
              onTermsAndConditionsPressed: () {},
              onPrivacyPolicyPressed: () {},
              onCheckboxChanged: (_) {},
              isChecked: false,
            ),
          ),
        ),
      );

      const texts = EmailSignInTexts.defaults;
      expect(_textStyleOf(tester, texts.termsIntro)?.color, Colors.white);
      expect(_textStyleOf(tester, texts.andText)?.color, Colors.white);
    },
  );

  testWidgets(
    'Given the default theme, '
    'when building TermsAndPrivacyText, '
    'then texts and link labels render at the bodySmall font size.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TermsAndPrivacyText(
              onTermsAndConditionsPressed: () {},
              onPrivacyPolicyPressed: () {},
              onCheckboxChanged: (_) {},
              isChecked: false,
            ),
          ),
        ),
      );

      const texts = EmailSignInTexts.defaults;
      final context = tester.element(find.byType(TermsAndPrivacyText));
      final bodySmallSize = Theme.of(context).textTheme.bodySmall?.fontSize;
      expect(bodySmallSize, isNotNull);
      expect(
        _textStyleOf(tester, texts.termsIntro)?.fontSize,
        bodySmallSize,
      );
      expect(
        _textStyleOf(tester, texts.termsAndConditions)?.fontSize,
        bodySmallSize,
      );
      expect(
        _textStyleOf(tester, texts.privacyPolicy)?.fontSize,
        bodySmallSize,
      );
    },
  );
}

/// Effective style of the [RichText] rendered by the [Text] matching [text].
TextStyle? _textStyleOf(WidgetTester tester, String text) {
  final richText = tester.widget<RichText>(
    find.descendant(of: find.text(text), matching: find.byType(RichText)),
  );
  return richText.text.style;
}
