// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/screen/artist_screen.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllArtistScreen extends StatefulWidget {
  const AllArtistScreen({
    Key? key,
    required this.artists,
  }) : super(key: key);
  final List<ArtistModel> artists;

  @override
  State<AllArtistScreen> createState() => _AllArtistScreenState();
}

class _AllArtistScreenState extends State<AllArtistScreen> {
  late AudioPlayer player;
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Browse Artists',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isGridView == true ? isGridView = false : isGridView = true;
                });
              },
              icon: isGridView == true
                  ? Icon(
                      Icons.grid_view,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(Icons.view_list,
                      color: Theme.of(context).primaryColor))
        ],
      ),
      body: body(),
    ));
  }

  Widget body() {
    return BlocConsumer<LibraryBloc, LibraryState>(listener: (context, state) {
      if (state is LibraryError) {
        ErrorSnackbar(error: state.error, context: context);
      }
    }, builder: (context, state) {
      if (state is LibraryLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is LibraryLoaded) {
        if (state.artists.isEmpty) {
          return const Center(
            child: Text('There is no Song on your device'),
          );
        } else {
          return isGridView == true
              ? gridViewWidget(state.artists)
              : listViewWidget(state.artists);
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget gridViewWidget(List<ArtistModel> artistList) {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: artistList.length,
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
                    builder: (context) => ArtistScreen(
                          artist: artistList[index],
                        ))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: artworkWidget(
                        audioId: artistList[index].id,
                        artworkType: ArtworkType.ARTIST),
                  ),
                ),
                Text(
                  artistList[index].artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${artistList[index].numberOfAlbums!} Albums',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${artistList[index].numberOfTracks!} Tracks',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget listViewWidget(List<ArtistModel> artistList) {
    return ListView.builder(
        itemCount: artistList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArtistScreen(
                          artist: artistList[index],
                        ))),
            leading: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: artworkWidget(
                      audioId: artistList[index].id,
                      artworkType: ArtworkType.AUDIO)),
            ),
            title: Text(
              artistList[index].artist,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              '${artistList[index].numberOfAlbums} Albums',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(
              '${artistList[index].numberOfTracks} Tracks',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        });
  }
}
