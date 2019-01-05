import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool automaticallyImplyLeading;
  final IconThemeData iconTheme;
  final List<Widget> actions;
  final PreferredSizeWidget bottom;
  final Widget leading;
  final Widget flexibleSpace;

  const CustomAppBar({
    Key key,
    @required this.title,
    this.automaticallyImplyLeading: true,
    this.iconTheme,
    this.actions,
    this.bottom,
    this.leading,
    this.flexibleSpace,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
      bottom: bottom,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: flexibleSpace,
      leading: leading,
      title: title,
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: actions,
      iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
    );
  }
}
