class Article {
  final String body;
  final String title;
  final String thumbnailUrl;
  final String url;

  Article({
    this.body,
    this.title,
    this.thumbnailUrl,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      body: json['body'],
      title: json['title'],
      thumbnailUrl: json['thumbnail-url'],
      url: json['url'],
    );
  }
  
  @override
  int get hashCode => title.hashCode ^ url.hashCode;

  bool operator ==(o) => identical(this, o) ||
      o.runtimeType == runtimeType && o.title == title && o.url == url;
}

class Articles {
  final int availablePages;
  final int page;
  final int remoteStatusCode;
  final List<Article> articles;
  final String pageUrl;
  final String requestType;

  Articles({
    this.availablePages,
    this.page,
    this.remoteStatusCode,
    this.articles,
    this.pageUrl,
    this.requestType,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    var articleList = json['articles'] as List;

    return Articles(
      availablePages: json['available-pages'] as int,
      page: json['page'] as int,
      remoteStatusCode: json['remote-status-code'] as int,
      articles: articleList?.map((i) => Article.fromJson(i))?.toList() ?? [],
      pageUrl: json['page-url'],
      requestType: json['request-type'],
    );
  }
}

class SavedArticle {
  int hashCode;
  Article article;
  String savedDateTime;

  SavedArticle({
    this.hashCode,
    this.article,
    this.savedDateTime,
  });

  factory SavedArticle.fromMap(Map<String, dynamic> map) {
    return SavedArticle(
      article: Article(
        title: map['title'] == 'null' ? null : map['title'],
        body: map['body'] == 'null' ? null : map['body'],
        thumbnailUrl:
            map['thumbnailUrl'] == 'null' ? null : map['thumbnailUrl'],
        url: map['url'] == 'null' ? null : map['url'],
      ),
      savedDateTime: map['savedDateTime'],
      hashCode: map['hashCode'],
    );
  }
}
