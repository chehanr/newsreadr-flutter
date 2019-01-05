import 'package:flutter/material.dart';
import 'package:newsreadr/custom_theme.dart';
import 'package:newsreadr/screen/home.dart';
import 'package:newsreadr/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

final ThemeData darkTheme = CustomTheme.darkTheme;
final ThemeData lightTheme = CustomTheme.lightTheme;
final _themeGlobalKey = GlobalKey(debugLabel: 'app_theme');

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class MyApp extends StatefulWidget {
  MyApp() : super(key: _themeGlobalKey);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeData _theme = lightTheme;

  set theme(ThemeData newTheme) {
    if (newTheme != _theme) {
      setState(() {
        _theme = newTheme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      appThemeKey: _themeGlobalKey,
      child: MaterialApp(
        title: 'newsreadr',
        theme: _theme,
        home: MainScreen(),
      ),
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }

  @override
  void initState() {
    _setTheme();
    super.initState();
  }

  void _setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkMode') ?? false;
    ThemeController.of(context).appTheme =
        darkMode ? AppThemeOption.dark : AppThemeOption.light;
  }
}
