import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsreadr/constants.dart';
import 'package:newsreadr/model/archive.dart';
import 'package:newsreadr/model/articles.dart';

class ArchiveApi {
  static const String _apiUrl = '$kApiBaseUrl/archives';

  final http.Client _client = http.Client();

  Future<Archives> getArchives() async {
    Archives archives;

    await _client
        .get(_apiUrl)
        .then((response) => response.body)
        .then(json.decode)
        .then((json) => archives = Archives.fromJson(json));

    return archives;
  }
}

class ArticleApi {
  static const String _apiUrl = '$kApiBaseUrl/articles?page={pageNumber}';

  final http.Client _client = http.Client();

  Future<Articles> getPage({String apiUrl, int pageNumber}) async {
    Articles articles;

    String _url = apiUrl != null ? apiUrl : _apiUrl;
    int _pageNumber = pageNumber != null ? pageNumber : 0;

    await _client
        .get(Uri.parse(
            _url.replaceFirst('{pageNumber}', _pageNumber.toString())))
        .then((response) => response.body)
        .then(json.decode)
        .then((json) => articles = Articles.fromJson(json));

    return articles;
  }
}
