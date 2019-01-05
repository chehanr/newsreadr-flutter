class UrlUtils {
  final String url;

  UrlUtils(this.url);

  String get hostAddress {
    /** 
     * Return the host address without the sub-domain (www.).
     * Returns `null` if [uri] is `null`.
   */

    if (uri?.host != null) {
      if (uri.host.startsWith(RegExp(r'[wW]{3}.'))) {
        return uri.host.replaceFirst(RegExp(r'[wW]{3}.'), '');
      }

      return uri.host;
    }
    return null;
  }

  bool get isUrl => uri == null ? false : true;

  Uri get uri {
    Uri uri;

    if (url == null) return null;

    try {
      String _url = Uri.encodeFull(url);
      uri = Uri.parse(_url);
    } catch (e) {
      throw e;
    }

    return uri;
  }
}
