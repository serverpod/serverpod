import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

/// Wraps the child in a MaterialApp with the appropriate theme and localization.
///
/// This function is temporary to fix the canvas color issue in the storybook.
/// It will be removed in favor of the default wrapper builder after it's fixed.
Widget wrapperBuilder(BuildContext context, Widget? child) {
  final LocalizationData localization = context
      .watch<LocalizationNotifier>()
      .value;
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
    ),
    darkTheme: ThemeData.dark().copyWith(
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
    ),
    debugShowCheckedModeBanner: false,
    supportedLocales: localization.supportedLocales.values,
    localizationsDelegates: localization.delegates,
    locale: localization.currentLocale,
    builder: defaultMediaQueryBuilder,
    home: Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        body: Center(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
}
