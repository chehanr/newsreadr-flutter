import 'dart:async';
import 'dart:io';

import 'package:newsreadr/model/articles.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDbHelper {
  static final ArticleDbHelper _database = ArticleDbHelper._internal();

  Database db;
  bool didInit = false;

  ArticleDbHelper._internal();

  Future<List<SavedArticle>> getArticles() async {
    var db = await _getDb();
    var results = await db.rawQuery(
        'SELECT * FROM Article ORDER BY DATETIME(savedDateTime) DESC');
    if (results == null) return [];
    List<SavedArticle> savedArticles = [];
    for (Map<String, dynamic> item in results) {
      savedArticles.add(SavedArticle.fromMap(item));
    }
    return savedArticles;
  }

  Future init() async {
    return await _init();
  }

  Future insertArticle(Article article) async {
    var savedDateTime = DateTime.now().toString();
    var db = await _getDb();

    await db.rawInsert(
        'INSERT INTO Article (body, title, thumbnailUrl, url, savedDateTime, hashCode) VALUES('
        '"${article.body?.replaceAll('"', '\\"')}", '
        '"${article.title?.replaceAll('"', '\\"')}", '
        '"${article.thumbnailUrl?.replaceAll('"', '\\"')}", '
        '"${article.url?.replaceAll('"', '\\"')}", '
        '"$savedDateTime", '
        '${article.hashCode}'
        ')');
  }

  Future removeArticle(Article article) async {
    var db = await _getDb();

    await db
        .rawDelete('DELETE FROM Article WHERE hashCode = ${article.hashCode};');
  }

  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'database.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Article ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'body TEXT, '
          'title TEXT, '
          'thumbnailUrl TEXT, '
          'url TEXT, '
          'savedDateTime TEXT, '
          'hashCode INTEGER'
          ')');
    });

    didInit = true;
  }

  static ArticleDbHelper get() {
    return _database;
  }
}
