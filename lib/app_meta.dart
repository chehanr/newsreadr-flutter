import 'package:flutter/material.dart';

/// Contains meta information about the application.

class AppMeta {
  final String appName = 'newsreadr';
  final String appVersion = '0.1.0+1';
  final String appInfo = 'An unofficial flutter client for infolanka.com/news';
  final String creatorInfo = 'Created by Chehan Ratnasiri (@chehanr).';
  final String apiUrl = 'https://newsreadr.herokuapp.com/api/';
  final String repoUrl = 'https://github.com/chehanr/newsreadr-flutter';
  final Image appIcon = Image(
    image: AssetImage('assets/images/icon/icon.png'),
    width: 60.0,
    height: 60.0,
    fit: BoxFit.scaleDown,
    alignment: FractionalOffset.center,
  );
}
