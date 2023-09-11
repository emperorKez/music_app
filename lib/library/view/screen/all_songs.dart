// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/common/bottom_navigation.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/bloc/search_bloc/search_bloc.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/library/view/widget/search_form.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

enum SortSong { dateAdded, title }

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({
    Key? key,
    this.sortBy = SortSong.title,
  }) : super(key: key);
  final SortSong sortBy;

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  // final AudioPlayer playerInstance ;
  late AudioPlayer player;
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SearchForm(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isGridView == true ? isGridView = false : isGridView = true;
                });
              },
              icon: isGridView == true
                  ? const Icon(Icons.grid_view)
                  : const Icon(Icons.view_list))
        ],
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBar(
        activeIndex: 2,
      ),
      body: body(),
    ));
  }

  Widget body() {
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
          final List<SongModel> songList = state.songs;
          if (widget.sortBy == SortSong.dateAdded) {
            state.songs.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
          } else {
            state.songs.sort((a, b) => a.title.compareTo(b.title));
          }
          return state.songs.isEmpty
              ? const Center(
                  child: Text('you do not have any song on your device'),
                )
              : songView(songList: songList);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget songView({required List<SongModel> songList}) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.isSearching) {
          return isGridView
              ? gridViewWidget(state.songs ?? [])
              : listViewWidget(state.songs ?? []);
        } else {
          return isGridView
              ? gridViewWidget(songList)
              : listViewWidget(songList);
        }
      },
    );
  }

//  Widget gridViewWidget(audioList) {
//     return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//             childAspectRatio: 0.75),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => NowPlayingScreen(
//                           player: player,
//                           playlist: defaultPlaylist(audioList),
//                           songIndex: index,
//                         ))),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AspectRatio(
//                   aspectRatio: 1,
//                   child: artworkWidget(
//                       audioId: audioList[index].id,
//                       artworkType: ArtworkType.AUDIO),
//                 ),
//                 Text(
//                   audioList[index].title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         audioList[index].artist!,
//                         overflow: TextOverflow.clip,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ),
//                     Expanded(
//                         flex: 1,
//                         child: durationWidget(
//                             context: context,
//                             duration: audioList[index].duration!))
//                   ],
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   Widget listViewWidget(audioList) {
//     return ListView.builder(
//                   itemCount: state.songs.length,
//                   itemBuilder: (context, index) {
//                     ListTile(
//                       onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => NowPlayingScreen(
//                                     player: player,
//                                     playlist: defaultPlaylist(state.songs),
//                                     songIndex: index,
//                                   ))),
//                       leading: AspectRatio(
//                         aspectRatio: 1,
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: artworkWidget(
//                                 audioId: state.songs[index].id,
//                                 artworkType: ArtworkType.AUDIO)),
//                       ),
//                       title: Text(
//                         state.songs[index].title,
//                         softWrap: true,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodySmall,
//                         //style: const TextStyle(color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         state.songs[index].artist!,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       trailing: durationWidget(
//                           context: context,
//                           duration: state.songs[index].duration!),
//                       // trailing: Text('${state.songs[index].duration}'),
//                     );
//                   });
//   }
}
