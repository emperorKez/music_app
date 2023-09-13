// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/common/bottom_navigation.dart';
import 'package:music_app/app/common/drawer.dart';
import 'package:music_app/app/view/screen/settings.dart';
import 'package:music_app/app/view/widget/home_widgets.dart';
import 'package:music_app/app/view/widget/most_played.dart';

import '../../../library/bloc/artwork_cubit/artwork_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    // required this.player,
  }) : super(key: key);
  //final AudioPlayer player;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final _formkey = GlobalKey<FormState>();
  final TextEditingController searchTerm = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Musika'),
              actions: [
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen())),
                    icon: const Icon(Icons.settings))
              ],
            ),
            drawer: const AppDrawer(),
            bottomNavigationBar: const BottomNavBar(
              activeIndex: 0,
            ),
            body: body()));
  }

  Widget body() {
    return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          topContainer(),
          const SizedBox(
            height: 20,
          ),
          genreContainer(),
          // const SizedBox(
          //   height: 20,
          // ),
          // const FavoriteSongsContainer(),
          const SizedBox(
            height: 20,
          ),
          const MostPlayedSongsScreen(),
          const SizedBox(
            height: 20,
          ),
          recentlyAdded()
        ]);
  }
}
