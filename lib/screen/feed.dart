import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsreadr/api.dart';
import 'package:newsreadr/model/articles.dart';
import 'package:newsreadr/widget/article_item_row.dart';
import 'package:newsreadr/widget/custom_appbar.dart';
import 'package:newsreadr/widget/loading_indicator.dart';

class FeedScreen extends StatefulWidget {
  final String apiUrl;
  final String screenTitle;
  final String screenSubTitle;

  const FeedScreen({
    Key key,
    this.apiUrl,
    this.screenTitle,
    this.screenSubTitle,
  }) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;
  static const int EMPTY = 4;

  int _pageNumber = 0;
  int _status = IDLE;
  int _loadingIndicatorStatus = LoadingIndicator.IDLE;
  double _lastOffset = 0.0;
  Completer<Null> _completer;
  List<Article> _articleList;
  ScrollController _controller;
  String _message;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.screenTitle != null
          ? CustomAppBar(
              title: widget.screenSubTitle != null
                  ? RichText(
                      text: TextSpan(
                        text: '${widget.screenTitle} ',
                        style: Theme.of(context).textTheme.title,
                        children: [
                          TextSpan(
                            text: '${widget.screenSubTitle}',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                  : Text(widget.screenTitle),
            )
          : null,
      body: SafeArea(
        child: _buildFeedScreenContent(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _status = LOADING;
    _controller = ScrollController();
    _controller.addListener(() {
      if (_loadingIndicatorStatus == LoadingIndicator.IDLE &&
          _controller.offset > _lastOffset &&
          _controller.position.maxScrollExtent - _controller.offset < 100) {
        _loadMore();
      }
      _lastOffset = _controller.offset;
    });
    _getArticlePage();
  }

  Widget _buildFeedScreenContent() {
    switch (_status) {
      case IDLE:
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: _articleList.length + 1,
            itemBuilder: (context, index) {
              if (index == _articleList.length) {
                return LoadingIndicator(
                  retry: () {
                    _loadMore();
                  },
                  state: _loadingIndicatorStatus,
                );
              } else {
                return ArticleItemRow(
                  article: _articleList[index],
                );
              }
            },
            controller: _controller,
          ),
        );
      case LOADING:
        return Center(child: CircularProgressIndicator());
      case ERROR:
        return Center(child: Text(_message ?? 'An error occurred!'));
      case EMPTY:
        return Center(child: Text('No articles available!'));
      default:
        return Center(child: Text('Unknown error occurred!'));
    }
  }

  Future _getArticlePage() async {
    _pageNumber = 0;

    Articles articles = await ArticleApi().getPage(
      apiUrl: widget.apiUrl,
    );

    if (!mounted) {
      return;
    }

    _articleList = articles?.articles;

    if (_completer != null) {
      _completer.complete();
      _completer = null;
    }

    setState(() {
      if (articles?.remoteStatusCode != 200) {
        _status = ERROR;
      } else if (_articleList?.isEmpty ?? false) {
        _status = EMPTY;
      } else {
        _pageNumber++;
        _status = IDLE;
      }
    });
  }

  Future _loadMore() async {
    setState(() {
      _loadingIndicatorStatus = LoadingIndicator.LOADING;
    });

    Articles articles = await ArticleApi().getPage(
      apiUrl: widget.apiUrl,
      pageNumber: _pageNumber,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      if (articles?.articles?.isNotEmpty ?? false) {
        _pageNumber++;
      }

      _articleList.addAll(articles?.articles);
      _loadingIndicatorStatus = LoadingIndicator.IDLE;
    });
  }

  Future<Null> _onRefresh() {
    _completer = new Completer<Null>();
    _getArticlePage();
    return _completer.future;
  }
}
