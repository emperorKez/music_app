import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/database.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/library/view/widget/show_dialog.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostPlayedSongsScreen extends StatefulWidget {
  const MostPlayedSongsScreen({super.key});

  @override
  State<MostPlayedSongsScreen> createState() => _MostPlayedSongsScreenState();
}

class _MostPlayedSongsScreenState extends State<MostPlayedSongsScreen> {
  // late List<PlayedCountData> countData;

  @override
  void initState() {
    super.initState();
    DatabaseProvider().initializeDb().whenComplete(() async {
      DatabaseProvider().fetchCountData();
    });
  }

  Future initDb() async {
    await DatabaseProvider().initializeDb();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          return FutureBuilder(
              future: DatabaseProvider().fetchCountData(),
              builder:
                  (context, AsyncSnapshot<List<PlayedCountData>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: const Text('Top Played')),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: snapshot.data!.length > 10
                                ? 10
                                : snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final List<SongModel> songList = List.generate(
                                  snapshot.data!.length > 10
                                      ? 10
                                      : snapshot.data!.length,
                                  (index) => state.songs[state.songs.indexWhere(
                                      (e) =>
                                          e.id ==
                                          snapshot.data![index].songId)]);
                              return ListTile(
                                onTap: () {
                                  context.read<PlayerBloc>().add(ChangePlaylist(
                                      playlist: createNowPlaylist(songList),
                                      songIndex: index));
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NowPlayingScreen(
                                                    player: context
                                                          .read<PlayerBloc>()
                                                          .state
                                                          .player!,
                                                      )));
                                },
                                onLongPress: () {
                      //Todo
                      showOnPressedDialog(context: context, song: songList[index]);
                    },
                                leading: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: artworkWidget(
                                          audioId: songList[index].id,
                                          artworkType: ArtworkType.AUDIO)),
                                ),
                                title: Text(
                                  songList[index].title,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                subtitle: Text(
                                  songList[index].artist!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: durationWidget(
                                    context: context,
                                    duration: songList[index].duration!),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                horizontalTitleGap: 10,
                                minVerticalPadding: 0,
                              );
                            })
                      ]);
                } else {
                  return const SizedBox();
                }
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
