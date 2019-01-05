class Archive {
  final int year;
  final List<ArchiveMonth> months;

  Archive({
    this.year,
    this.months,
  });

  factory Archive.fromJson(Map<String, dynamic> json) {
    var monthList = json['months'] as List;

    return Archive(
      year: json['year'] as int,
      months: monthList?.map((i) => ArchiveMonth.fromJson(i))?.toList() ?? [],
    );
  }
}

class ArchiveMonth {
  final String title;
  final String monthUri;

  ArchiveMonth({
    this.title,
    this.monthUri,
  });

  factory ArchiveMonth.fromJson(Map<String, dynamic> json) {
    return ArchiveMonth(
      title: json['month'],
      monthUri: json['month-uri'],
    );
  }
}

class Archives {
  final int remoteStatusCode;
  final List<Archive> archives;
  final String pageUrl;
  final String requestType;

  Archives({
    this.remoteStatusCode,
    this.archives,
    this.pageUrl,
    this.requestType,
  });

  factory Archives.fromJson(Map<String, dynamic> json) {
    var archiveList = json['archives-list'] as List;

    return Archives(
      remoteStatusCode: json['remote-status-code'] as int,
      archives: archiveList?.map((i) => Archive.fromJson(i))?.toList() ?? [],
      pageUrl: json['page-url'],
      requestType: json['request-type'],
    );
  }
}
