import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/library/view/screen/all_songs.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key, required this.activeIndex}) : super(key: key);
  final int activeIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(builder: (context, state) {
      if (state is PlayerLoaded) {
        // final player = state.player;
        return bottomNavWidget();
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget bottomNavWidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        currentIndex: widget.activeIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Theme.of(context).primaryColor), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor), label: 'Now Playing'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music, color: Theme.of(context).primaryColor), label: 'Library'),
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;

              String activeState = _currentIndex.toString();
              switch (activeState) {
                case '0':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                  break;
                case '1':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NowPlayingScreen(
                              player: context
                                  .read<PlayerBloc>()
                                  .state
                                  .player!))); //Category Screen
                  break;
                case '2':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllSongsScreen()));
                  break;
              }
            },
          );
        });
  }
}
