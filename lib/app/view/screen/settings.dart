import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/bloc/app_bloc/app_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  // RxBool darkMode = false.obs;
  Color? tileColor;
  var tileShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0));
  Icon trailingIcon = const Icon(CupertinoIcons.chevron_right_circle_fill);

  bool hideProfile = false;

  @override
  Widget build(BuildContext context) {
    tileColor = Theme.of(context).colorScheme.secondaryContainer;
    return SafeArea(
        child: Scaffold(
            // backgroundColor: Color(0xffe5e5e5),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context)
                  // Navigator.popUntil(context, ModalRoute.withName('/'))
                  ),
              title: const Text('Settings'),
              centerTitle: true,
            ),
            body: BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ListView(padding: const EdgeInsets.all(10), children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    tileColor: tileColor,
                    shape: tileShape,
                    trailing: const Text('English'),
                    onTap: () {},
                    iconColor: Theme.of(context).primaryColor,
                  ),
                  ListTile(
                    leading: const Icon(Icons.hide_image_sharp),
                    title: const Text('Hide from Search'),
                    tileColor: tileColor,
                    shape: tileShape,
                    trailing: Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: hideProfile,
                        onChanged: (value) {
                          hideProfile = value;
                        }),
                    iconColor: Theme.of(context).primaryColor,
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded),
                    title: const Text('Dark Mode'),
                    tileColor: tileColor,
                    shape: tileShape,
                    trailing: Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: state.darkMode,
                        onChanged: (value) {
                          context
                              .read<AppBloc>()
                              .add(ChangeTheme(isDark: value));
                        }),
                    iconColor: Theme.of(context).primaryColor,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Version'),
                    subtitle: Text(state.packageInfo?.version ?? '1.0.0'),
                    tileColor: tileColor,
                    shape: tileShape,
                    trailing: TextButton(
                        onPressed: () => _launchAppStoreUrl(),
                        child: const Text('Update')),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('legal'),
                    tileColor: tileColor,
                    shape: tileShape,
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Rate the App'),
                    tileColor: tileColor,
                    shape: tileShape,
                    onTap: () {},
                  ),
                ]);
              },
            )));
  }

  Future<void> _launchAppStoreUrl() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'com.buzymart' : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
