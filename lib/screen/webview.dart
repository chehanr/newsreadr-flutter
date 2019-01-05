import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:newsreadr/widget/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewScreen extends StatefulWidget {
  final String url;

  WebviewScreen({
    @required this.url,
  });

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();

  String _webviewTitle = 'Browser';
  StreamSubscription<String> _onUrlChanged;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: CustomAppBar(
        title: Text(
          _webviewTitle.isEmpty ? widget.url : _webviewTitle,
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_new),
            tooltip: 'Open externally',
            onPressed: () {
              _launchExternalBrowser(widget.url);
            },
          ),
        ],
      ),
      url: widget.url,
      withLocalStorage: true,
    );
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen((url) async {
      _webviewTitle =
          await _flutterWebviewPlugin.evalJavascript('window.document.title');
      _webviewTitle = _webviewTitle.replaceAll('\"', '');
      if (mounted) setState(() => {});
    });
  }

  void _launchExternalBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
