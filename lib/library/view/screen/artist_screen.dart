// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({
    Key? key,
    required this.artist,
  }) : super(key: key);
  final ArtistModel artist;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  late AudioPlayer player;
  bool isGridView = false;
  int selectedAlbum = -1;
  List<SongModel> audioList = [];
  List<AlbumModel> albumList = [];

  @override
  Widget build(BuildContext context) {
    player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.artist.artist),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           isGridView == true ? isGridView = false : isGridView = true;
        //         });
        //       },
        //       icon: isGridView == true
        //           ? const Icon(Icons.grid_view)
        //           : const Icon(Icons.view_list))
        // ],
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
          audioList
              .addAll(state.songs.where((e) => e.artistId == widget.artist.id));
          albumList.addAll(
              state.albums.where((e) => e.artistId == widget.artist.id));
          return ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [albumView(albumList), songView(audioList)],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget albumView(List<AlbumModel> albumList) {
    return albumList.isEmpty
        ? const Center(
            child: Text('No Album'),
          )
        : GridView.builder(
            itemCount: albumList.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() {
                  selectedAlbum = index;
                }),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // fit: StackFit.expand,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: artworkWidget(
                          audioId: albumList[index].id,
                          artworkType: ArtworkType.ALBUM),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(albumList[index].album),
                        Text('${albumList[index].numOfSongs} Songs')
                      ],
                    ),
                    selectedAlbum == index
                        ? Container(
                            color: Colors.grey.withOpacity(0.6),
                          )
                        : const SizedBox()
                  ],
                ),
              );
            });
  }

  Widget songView(List<SongModel> songList) {
    List<SongModel> songs = [];
    selectedAlbum >= 0
        ? songs.addAll(
            songList.where((e) => e.albumId == albumList[selectedAlbum].id))
        : songs.addAll(songList);
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedAlbum >= 0
                ? Text(albumList[selectedAlbum].album)
                : const Text('All Songs'),
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
        ),
        const SizedBox(
          height: 15,
        ),
        isGridView == true ? gridViewWidget(songs) : listViewWidget(songs)
      ],
    );
  }

  Widget gridViewWidget(List<SongModel> audioList) {
    return GridView.builder(
        itemCount: audioList.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                          player: player,
                          playlist: createPlaylist(audioList),
                          songIndex: index,
                        ))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: artworkWidget(
                      audioId: audioList[index].id,
                      artworkType: ArtworkType.AUDIO),
                ),
                Text(
                  audioList[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        audioList[index].artist!,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: durationWidget(
                            context: context,
                            duration: audioList[index].duration!))
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget listViewWidget(List<SongModel> audioList) {
    return ListView.builder(
        itemCount: audioList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                          player: player,
                          playlist: createPlaylist(audioList),
                          songIndex: index,
                        ))),
            leading: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: artworkWidget(
                      audioId: audioList[index].id,
                      artworkType: ArtworkType.AUDIO)),
            ),
            title: Text(
              audioList[index].title,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              audioList[index].artist!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: durationWidget(
                context: context, duration: audioList[index].duration!),
          );
        });
  }
}
