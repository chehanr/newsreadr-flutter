import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsreadr/model/articles.dart';
import 'package:newsreadr/screen/webview.dart';
import 'package:newsreadr/util/thumbnail_utils.dart';
import 'package:newsreadr/util/url_utils.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleViewScreen extends StatefulWidget {
  final Article article;
  final int heroCardId;

  const ArticleViewScreen({
    Key key,
    @required this.article,
    @required this.heroCardId,
  }) : super(key: key);

  @override
  _ArticleViewScreenState createState() => _ArticleViewScreenState();
}

class _ArticleViewScreenState extends State<ArticleViewScreen> {
  bool _prefUseExternalBrowser = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'card-${widget.heroCardId}',
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildHeaderContainer(context),
                _buildButtonContainer(context),
                _buildContentContainer(context),
              ],
            ),
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

  Container _buildButtonContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Share button.
          RawMaterialButton(
            child: Column(
              children: <Widget>[
                Icon(Icons.share),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            shape: CircleBorder(),
            padding: const EdgeInsets.all(18.0),
            onPressed: () {
              Share.share(widget.article.url);
            },
          ),
          // Browser button.
          RawMaterialButton(
            child: Column(
              children: <Widget>[
                Icon(Icons.open_in_browser),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Open article',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            shape: CircleBorder(),
            padding: const EdgeInsets.all(18.0),
            onPressed: () {
              _prefUseExternalBrowser
                  ? _launchExternalBrowser(widget.article.url)
                  : _launcWebview(widget.article.url);
            },
          ),
        ],
      ),
    );
  }

  Container _buildContentContainer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              widget.article.body,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle.color,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildHeaderContainer(BuildContext context) {
    ThumbnailUtils thumbnailUtils = ThumbnailUtils(widget.article);
    UrlUtils urlUtils = UrlUtils(widget.article.url);

    return Container(
      height: 180.0,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
          ),
          Container(
            child: thumbnailUtils.isAvailable
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter:
                            ColorFilter.mode(Colors.blueGrey, BlendMode.color),
                        image: CachedNetworkImageProvider(thumbnailUtils.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.article.title,
                    maxLines: 4,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      background: Paint()..color = Color(Colors.black38.value),
                      color: Theme.of(context).primaryTextTheme.title.color,
                      fontSize: 21.0,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    urlUtils?.hostAddress?.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      background: Paint()..color = Color(Colors.black38.value),
                      color: Theme.of(context).primaryTextTheme.subtitle.color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchExternalBrowser(String url) async {
    UrlUtils urlUtils = UrlUtils(url);
    String _url = urlUtils.uri.toString();

    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launcWebview(String url) async {
    UrlUtils urlUtils = UrlUtils(url);
    String _url = urlUtils.uri.toString();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(url: _url),
      ),
    );
  }

  void _loadState() async {
    var prefs = await _prefs;
    setState(() {
      _prefUseExternalBrowser = prefs.getBool('useExternalBrowser') ?? false;
    });
  }
}
