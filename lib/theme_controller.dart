import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsreadr/main.dart';

enum AppThemeOption { light, dark }

class ThemeController extends InheritedWidget {
  final ThemeData theme;
  final GlobalKey _appThemeKey;

  ThemeController({appThemeKey, this.theme, child})
      : _appThemeKey = appThemeKey,
        super(child: child);

  set appTheme(AppThemeOption theme) {
    switch (theme) {
      case AppThemeOption.light:
        (_appThemeKey.currentState as MyAppState)?.theme = lightTheme;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   statusBarColor: Colors.white,
        //   statusBarIconBrightness: Brightness.dark,
        //   systemNavigationBarColor: Colors.white,
        //   systemNavigationBarDividerColor: Colors.black,
        //   systemNavigationBarIconBrightness: Brightness.dark,
        // ));
        break;
      case AppThemeOption.dark:
        (_appThemeKey.currentState as MyAppState)?.theme = darkTheme;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   statusBarColor: const Color(0xFF212121),
        //   statusBarIconBrightness: Brightness.light,
        //   systemNavigationBarColor: const Color(0xFF303030),
        //   systemNavigationBarDividerColor: Colors.white,
        //   systemNavigationBarIconBrightness: Brightness.light,
        // ));
        break;
    }
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) =>
      oldWidget.theme == theme;

  static ThemeController of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ThemeController);
  }
}
