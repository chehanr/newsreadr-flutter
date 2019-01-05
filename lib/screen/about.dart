import 'package:flutter/material.dart';
import 'package:newsreadr/app_meta.dart';
import 'package:newsreadr/screen/webview.dart';
import 'package:newsreadr/widget/custom_appbar.dart';

class AboutScreen extends StatelessWidget {
  final AppMeta _appMeta = AppMeta();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'About',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'App',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About app'),
                onTap: () {
                  _showAboutDialog(context: context);
                },
              ),
              ListTile(
                leading: Icon(Icons.public),
                title: Text('API'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebviewScreen(
                            url: _appMeta.apiUrl,
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.public),
                title: Text('Source code on GitHub'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebviewScreen(
                            url: _appMeta.repoUrl,
                          ),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Contributors',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Chehan Ratnasiri (@chehanr)'),
                subtitle: Text('Creator'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebviewScreen(
                            url: 'https://twitter.com/chehanr',
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Nishith Pinnawala (@icogi)'),
                subtitle: Text('App icon designer'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebviewScreen(
                            url: 'https://twitter.com/icogi',
                          ),
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

  void _showAboutDialog({
    @required BuildContext context,
  }) {
    assert(context != null);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: _appMeta.appName,
          applicationVersion: 'V${_appMeta.appVersion}',
          applicationIcon: _appMeta.appIcon,
          applicationLegalese: null,
          children: <Widget>[
            ListTile(
              title: Text(_appMeta.appInfo),
            )
          ],
        );
      },
    );
  }
}
