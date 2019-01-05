import 'package:flutter/material.dart';
import 'package:newsreadr/screen/about.dart';
import 'package:newsreadr/theme_controller.dart';
import 'package:newsreadr/widget/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _prefDarkMode = false;
  bool _prefUseExternalBrowser = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'General settings',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                title: Text('Open articles externally'),
                secondary: Icon(Icons.open_in_new),
                value: _prefUseExternalBrowser,
                onChanged: (newVal) {
                  setState(() {
                    _prefUseExternalBrowser = newVal;
                    _updatePrefs();
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: Text('Dark mode'),
                secondary: Icon(Icons.brightness_4),
                value: _prefDarkMode,
                onChanged: (newVal) {
                  setState(() {
                    _prefDarkMode = newVal;
                    ThemeController.of(context).appTheme = _prefDarkMode
                        ? AppThemeOption.dark
                        : AppThemeOption.light;
                    _updatePrefs();
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Other',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _loadState();
    super.initState();
  }

  void _loadState() async {
    var prefs = await _prefs;
    setState(() {
      _prefDarkMode = prefs.getBool('darkMode') ?? false;
      _prefUseExternalBrowser = prefs.getBool('useExternalBrowser') ?? false;
    });
  }

  void _updatePrefs() async {
    var prefs = await _prefs;
    prefs.setBool('darkMode', _prefDarkMode);
    prefs.setBool('useExternalBrowser', _prefUseExternalBrowser);
  }
}
