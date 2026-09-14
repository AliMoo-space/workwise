import 'package:flutter/material.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(context.l10n.drawerHeader),
          ),
          ListTile(title: Text(context.l10n.drawerItem1)),
          ListTile(title: Text(context.l10n.drawerItem2)),
          ListTile(title: Text(context.l10n.drawerItem3)),
        ],
      ),
    );
  }
}
