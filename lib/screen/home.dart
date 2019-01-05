import 'package:flutter/material.dart';
import 'package:newsreadr/screen/archives.dart';
import 'package:newsreadr/screen/feed.dart';
import 'package:newsreadr/screen/saved.dart';
import 'package:newsreadr/screen/settings.dart';
import 'package:newsreadr/widget/custom_appbar.dart';

class DrawerItem {
  final String drawerTitle;
  final Icon drawerIcon;
  final String screenTitle;

  DrawerItem(
    this.drawerTitle,
    this.drawerIcon,
    this.screenTitle,
  );
}

class HomeScreen extends StatefulWidget {
  get drawerItems => [
        DrawerItem('Articles', null, 'newsreadr'),
        DrawerItem('Archives', null, 'Archives'),
        DrawerItem('Saved', null, 'Saved'),
      ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = <Widget>[];
    var drawerItems = widget.drawerItems;

    // Add the drawer items.
    for (var item in drawerItems) {
      int itemIndex = drawerItems.indexOf(item);

      drawerOptions.add(ListTile(
        leading: item.drawerIcon,
        title: Text(item.drawerTitle),
        selected: itemIndex == _selectedDrawerItemIndex,
        onTap: () => _onSelectItem(itemIndex),
      ));
    }

    // Build the navbar.
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          drawerItems[_selectedDrawerItemIndex].screenTitle,
          style: Theme.of(context).textTheme.title,
        ),
        actions: _buildPopupMenuActions(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('newsreadr'),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(children: drawerOptions),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _getDrawerItem(_selectedDrawerItemIndex),
    );
  }

  List<Widget> _buildPopupMenuActions() {
    return <Widget>[
      PopupMenuButton(
        tooltip: 'Actions',
        onSelected: (selection) {
          switch (selection) {
            case 'settings':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
              break;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
      ),
    ];
  }

  _getDrawerItem(int index) {
    switch (index) {
      case 0:
        return FeedScreen();
      case 1:
        return ArchivesScreen();
      case 2:
        return SavedScreen();
      default:
        return debugPrint('Drawer item index out of bounds!');
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerItemIndex = index);
    Navigator.of(context).pop(); // Close the drawer.
  }
}
