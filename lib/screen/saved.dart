import 'package:flutter/material.dart';
import 'package:newsreadr/database/database_helper.dart';
import 'package:newsreadr/model/articles.dart';
import 'package:newsreadr/widget/article_item_row.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<SavedArticle>>(
          future: fetchArticles(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  Center(
                    child: Text('An error occurred!'),
                  );
                  debugPrint('${snapshot.error}');
                }
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ArticleItemRow(
                          article: snapshot.data[index].article,
                          articleRowType: ArticleRowType.saved,
                        );
                      });
                } else {
                  return Center(
                    child: Text('You haven\'t saved any articles.'),
                  );
                }
                break;
              default:
                return null;
            }
          }),
    );
  }

  Future<List<SavedArticle>> fetchArticles() async {
    Future<List<SavedArticle>> articles = ArticleDbHelper.get().getArticles();
    return articles;
  }
}
