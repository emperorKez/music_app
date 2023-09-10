import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/view/screen/all_playlist.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/screen/all_artist_screen.dart';
import 'package:music_app/library/view/screen/genre_screen.dart';
import 'package:music_app/library/view/screen/all_songs.dart';
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
        final PlaylistModel emptyPlaylist;
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
          children: [
            topContainerItems(context,
                color: Colors.red,
                icon: Icons.music_note,
                title: 'All Songs',
                page: const AllSongsScreen()),
            topContainerItems(context,
                color: Colors.green,
                icon: Icons.my_library_music,
                title: 'Artists',
                page: AllArtistScreen(
                  artists: state.artists,
                )),
            topContainerItems(context,
                color: Colors.brown,
                icon: Icons.playlist_play,
                title: 'Playlists',
                page: const PlaylistScreen()),
            // topContainerItems(context,
            //     color: Colors.white,
            //     icon: Icons.playlist_play,
            //     title: 'Most Played',
            //     page: PlaylistSongScreen(
            //       playlist: state.playlists?[0],
            //       songList: [],
            //     )),
            // topContainerItems(context,
            //     color: Colors.blue,
            //     icon: Icons.playlist_play,
            //     title: 'Recently Added',
            //     page: PlaylistSongScreen(
            //       playlist: state.playlists![0],
            //       songList: [],
            //     )),
            // topContainerItems(context,
            //     color: Colors.green,
            //     icon: Icons.favorite,
            //     title: 'Favorites',
            //     page: PlaylistSongScreen(
            //       playlist: state.playlists![0],
            //       songList: [],
            //     ))
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
    {required Color color,
    required IconData icon,
    required String title,
    required Widget page}) {
  return GestureDetector(
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Icon(icon),
            ),
          ),
        ),
        Text(title)
      ],
    ),
  );
}

class FavoriteSongsContainer extends StatelessWidget {
  const FavoriteSongsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryError) {
          ErrorSnackbar(error: state.error, context: context);
        }
      },
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LibraryLoaded) {
          // if (audioList.isEmpty) {
            return const Center(
              child: Text('No Song in this Playlist'),
            );
          // } else {
          //   return Container(
          //     margin: const EdgeInsets.symmetric(vertical: 10),
          //     padding: const EdgeInsets.symmetric(horizontal: 15),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text('Your Favourites'),
          //             GestureDetector(
          //               onTap: () => Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const PlaylistSongScreen(
          //                             playlist: null,
          //                             songList: [],
          //                           ))),
          //               child: const Text('All Songs'),
          //             )
          //           ],
          //         ),
          //         const SizedBox(
          //           height: 15,
          //         ),
          //         ListView.builder(
          //           padding: EdgeInsets.zero,
          //           shrinkWrap: true,
          //           itemCount: favouriteSongs.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return ListTile(
          //                 // onTap: () => Navigator.push(
          //                 //     context,
          //                 //     MaterialPageRoute(
          //                 //         builder: (context) =>
          //                 //             NowPlaying(song: favouriteSongs[index]))),
          //                 contentPadding: EdgeInsets.zero,
          //                 leading: AspectRatio(
          //                   aspectRatio: 1,
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(5),
          //                     child: Image.asset(
          //                       favouriteSongs[index].artwork,
          //                       fit: BoxFit.fill,
          //                     ),
          //                   ),
          //                 ),
          //                 title: Text(
          //                   songlist[index].title,
          //                   style: const TextStyle(
          //                       fontSize: 18, color: Colors.white),
          //                 ),
          //                 subtitle: Text(
          //                   songlist[index].artiste,
          //                   style: const TextStyle(
          //                       fontSize: 14, color: Colors.grey),
          //                 ),
          //                 trailing: Text(
          //                   '${songlist[index].duration}',
          //                   style: const TextStyle(
          //                       fontSize: 16, color: Colors.white),
          //                 ));
          //           },
          //         ),
          //       ],
          //     ),
          //   );
          // }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
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
