import 'package:flutter/material.dart';
import 'package:newsreadr/api.dart';
import 'package:newsreadr/constants.dart';
import 'package:newsreadr/model/archive.dart';
import 'package:newsreadr/screen/feed.dart';

class ArchivesScreen extends StatelessWidget {
  final ArchiveApi _api = ArchiveApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Archives>(
          future: _api.getArchives(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Text('An error occurred!');
              debugPrint('${snapshot.error}');
            }
            if (snapshot.hasData) {
              return _buildExpansionList(snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  ListView _buildExpansionList(Archives archives) {
    return ListView.builder(
        itemCount: archives.archives.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(archives.archives[index].year.toString()),
            children: _buildExpansionListChildren(
              context,
              archives.archives[index],
            ),
          );
        });
  }

  List<Widget> _buildExpansionListChildren(
      BuildContext context, Archive archive) {
    var monthTiles = <Widget>[];

    for (var month in archive.months) {
      monthTiles.add(
        ListTile(
          title: Text(month.title),
          onTap: () {
            String apiUrl =
                '$kApiBaseUrl/archives/find?year=${archive.year}&month=${month.title}&page={pageNumber}';
            String screenTitle = 'Archives';
            String screenSubTitle = '${month.title}, ${archive.year}';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedScreen(
                      apiUrl: apiUrl,
                      screenTitle: screenTitle,
                      screenSubTitle: screenSubTitle,
                    ),
              ),
            );
          },
        ),
      );
    }

    return monthTiles;
  }
}
