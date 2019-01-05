import 'package:newsreadr/model/articles.dart';

class ThumbnailUtils {
  final Article article;

  ThumbnailUtils(this.article);

  bool get isAvailable => url != null ? true : false;

  String get url {
    // TODO add youtube thumbnail grabbing.
    String url;

    if (article.thumbnailUrl != null && article.thumbnailUrl.isNotEmpty) {
      url = article.thumbnailUrl;
    }

    return url;
  }
}
