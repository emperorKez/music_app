import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: ListView(
        shrinkWrap: true,
        children: const [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    ));
  }
}
