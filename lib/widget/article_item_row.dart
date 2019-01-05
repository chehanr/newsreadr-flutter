import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsreadr/database/database_helper.dart';
import 'package:newsreadr/model/articles.dart';
import 'package:newsreadr/screen/article_view.dart';
import 'package:newsreadr/util/thumbnail_utils.dart';
import 'package:newsreadr/util/url_utils.dart';
import 'package:share/share.dart';

class ArticleItemRow extends StatelessWidget {
  final Article article;
  final ArticleRowType articleRowType;

  const ArticleItemRow({
    Key key,
    @required this.article,
    this.articleRowType = ArticleRowType.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int heroCardId = article.hashCode ^ Random().nextInt(100);

    // Do not return a card if the title and the url is `null`.
    if (article.title != null && article.url != null) {
      return Hero(
        tag: 'card-$heroCardId',
        child: Card(
          child: InkWell(
            child: _buildCardContent(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleViewScreen(
                        article: article,
                        heroCardId: heroCardId,
                      ),
                ),
              );
            },
            onLongPress: () {
              _buildShowModalBottomSheet(context);
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container _buildCardContent(BuildContext context) {
    ThumbnailUtils thumbnailUtils = ThumbnailUtils(article);
    UrlUtils urlUtils = UrlUtils(article.url);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    article.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.title.color,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                urlUtils.isUrl
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          urlUtils.hostAddress != null
                              ? urlUtils.hostAddress.toUpperCase()
                              : null,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle.color,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Container(),
                Text(
                  article.body,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          thumbnailUtils.isAvailable
              ? Container(
                  height: 80.0,
                  width: 80.0,
                  margin: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUtils.url,
                    placeholder: Icon(Icons.image),
                    errorWidget: Icon(Icons.broken_image),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future _buildShowModalBottomSheet(BuildContext context) {
    UrlUtils urlUtils = UrlUtils(article.url);

    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        switch (articleRowType) {
          case ArticleRowType.normal:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.save),
                  title: Text('Save'),
                  onTap: () {
                    ArticleDbHelper.get().insertArticle(article);
                    Navigator.of(context).pop(); // Close the modal.
                  },
                ),
                urlUtils.isUrl
                    ? ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the modal.
                          Share.share(article.url);
                        },
                      )
                    : Container(),
              ],
            );
            break;
          case ArticleRowType.saved:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove'),
                  onTap: () {
                    ArticleDbHelper.get().removeArticle(article);
                    Navigator.of(context).pop(); // Close the modal.
                  },
                ),
                urlUtils.isUrl
                    ? ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the modal.
                          Share.share(article.url);
                        },
                      )
                    : Container(),
              ],
            );
            break;
        }
      },
    );
  }
}

enum ArticleRowType { normal, saved }
