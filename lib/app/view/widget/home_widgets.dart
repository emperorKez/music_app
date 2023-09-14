import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/view/screen/all_playlist.dart';
import 'package:music_app/app/view/screen/playlist_songs.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/artwork_cubit/artwork_cubit.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/screen/all_artist_screen.dart';
import 'package:music_app/library/view/screen/all_genre.dart';
import 'package:music_app/library/view/screen/genre_screen.dart';
import 'package:music_app/library/view/screen/all_songs.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/library/view/widget/show_dialog.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart' as blocs;
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

topContainer() {
  return BlocConsumer<LibraryBloc, LibraryState>(
    listener: (context, state) {
      if (state is LibraryError) {
        ErrorSnackbar(error: state.error, context: context);
      }
    },
    builder: (context, state) {
      if (state is LibraryLoaded) {
        context.read<ArtworkCubit>().saveArtworkToFile(songs: state.songs);

        //default playlist
        ConcatenatingAudioSource defaultList = ConcatenatingAudioSource(
            children: List.generate(state.songs.length, (index) {
          return AudioSource.file(state.songs[index].data,
              tag: MediaItem(
                id: '${state.songs[index].id}',
                album: state.songs[index].album!,
                artist: state.songs[index].artist!,
                title: state.songs[index].title,
              ));
        }));
        context.read<blocs.PlayerBloc>().add(blocs.PlayerInitialize(
            defaultList: defaultList, libraryLength: state.songs.length));

        // final PlaylistModel emptyPlaylist;
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            topContainerItems(context,
                icon: Icons.music_note,
                title: 'All Songs',
                page: const AllSongsScreen()),
            topContainerItems(context,
                icon: Icons.my_library_music,
                title: 'Artists',
                page: AllArtistScreen(
                  artists: state.artists,
                )),
            topContainerItems(context,
                icon: Icons.playlist_play,
                title: 'Playlists',
                page: const PlaylistScreen()),
            topContainerItems(context,
                icon: Icons.favorite,
                title: 'Favorites',
                page: PlaylistSongScreen(
                  playlist: state.playlists![0],
                  songList: const [],
                )),
            topContainerItems(context,
                icon: Icons.playlist_play,
                title: 'Genre',
                page: const AllGenreScreen()),
            topContainerItems(context,
                icon: Icons.playlist_play,
                title: 'Recently Added',
                page: const AllSongsScreen(
                  sortBy: SortSong.dateAdded,
                )),
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

topContainerItems(BuildContext context,
    {required IconData icon, required String title, required Widget page}) {
  return GestureDetector(
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          maxLines: 2,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    ),
  );
}

// class FavoriteSongsContainer extends StatelessWidget {
//   const FavoriteSongsContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LibraryBloc, LibraryState>(
//       listener: (context, state) {
//         if (state is LibraryError) {
//           ErrorSnackbar(error: state.error, context: context);
//         }
//       },
//       builder: (context, state) {
//         if (state is LibraryLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is LibraryLoaded) {
//           // if (audioList.isEmpty) {
//           return const SizedBox();

//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }

Widget recentlyAdded() {
  return BlocConsumer<LibraryBloc, LibraryState>(listener: (context, state) {
    if (state is LibraryError) {
      ErrorSnackbar(error: state.error, context: context);
    }
  }, builder: (context, state) {
    if (state is LibraryLoaded) {
      final List<SongModel> songList = state.songs;
      if (songList.isEmpty) {
        return const SizedBox();
      } else {
        songList.sort(
          (a, b) => b.dateAdded!.compareTo(a.dateAdded!),
        );
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recently Added'),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllSongsScreen(
                                    sortBy: SortSong.dateAdded,
                                  ))),
                      child: const Text('view all'))
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: songList.length > 10 ? 10 : songList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      context.read<blocs.PlayerBloc>().add(blocs.ChangePlaylist(
                          playlist: createNowPlaylist(songList),
                          songIndex: index));
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
                        context: context, duration: songList[index].duration!),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 10,
                    minVerticalPadding: 0,
                  );
                }),
          ],
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  });
}

Widget genreContainer() {
  return Container(
    // margin: const EdgeInsets.symmetric(vertical: 10),
    // padding: const EdgeInsets.symmetric(horizontal: 15),
    height: 150,
    child: BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.3),
            itemCount: state.genres.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GenreScreen(genre: state.genres[index]))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: artworkWidget(
                            audioId: state.genres[index].id,
                            artworkType: ArtworkType.GENRE)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(state.genres[index].genre,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}

Widget playlistContainer() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    height: 200,
    child: BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.3),
            itemCount: state.genres.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                // => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PlaylistScreen(player: widget.player,
                //             playlistTitle: playlists[index].title,
                //             playlistArtwork: playlists[index].artwork))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: artworkWidget(
                            audioId: state.genres[index].id,
                            artworkType: ArtworkType.GENRE)
                        //                 ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: Image.asset(
                        //     playlists[index].artwork,
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(state.genres[index].genre,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}
