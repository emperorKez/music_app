import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/explore/view/screen/explore_screen.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/screen/all_songs.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart' as blocs;
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
  late AudioPlayer player;
  late ConcatenatingAudioSource playlist;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          return BlocBuilder<blocs.PlayerBloc, blocs.PlayerState>(
            builder: (context, state) {
              if (state is blocs.PlayerLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dockedPlayer(player: state.player!),
                    bottomNavWidget(context),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget bottomNavWidget(context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        // Theme.of(context).colorScheme.onPrimary,
        currentIndex: widget.activeIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: Theme.of(context).colorScheme.onPrimary),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.onPrimary),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music,
                  color: Theme.of(context).colorScheme.onPrimary),
              label: 'Library'),
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
                          builder: (context) => ExploreScreen(
                              player: context
                                  .read<blocs.PlayerBloc>()
                                  .state
                                  .player!)));
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

  Widget dockedPlayer({required AudioPlayer player}) {
    return StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }

          final metadata = state!.currentSource!.tag as MediaItem;

          return SizedBox(
            height: 60,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(
                              player: context
                                  .read<blocs.PlayerBloc>()
                                  .state
                                  .player!,
                            )));
              },
              leading: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset('assets/images/default_artwork.jpg')),
              ),
              title: Text(
                metadata.title,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                metadata.artist!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: playButton(context: context, player: player),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              horizontalTitleGap: 10,
              minVerticalPadding: 0,
            ),
          );
        });
  }

  Widget playButton(
      {required BuildContext context, required AudioPlayer player}) {
    final playButton = Icon(
      Icons.play_arrow,
      color: Theme.of(context).primaryColor,
      size: 32,
    );
    final pauseButton = Icon(
      Icons.pause,
      color: Theme.of(context).primaryColor,
      size: 32,
    );
    return StreamBuilder<PlayerState>(
        stream: player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return IconButton(
                iconSize: 50.0, onPressed: () {}, icon: playButton);
          } else if (playing != true) {
            return IconButton(
                iconSize: 50.0, onPressed: player.play, icon: playButton);
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
                iconSize: 50.0, onPressed: player.pause, icon: pauseButton);
          } else {
            return IconButton(
                iconSize: 50.0, onPressed: () {}, icon: pauseButton);
          }
        });
  }
}
