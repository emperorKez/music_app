// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/services.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../app/app.dart';

class SongListScreen extends StatelessWidget {
  SongListScreen({
    Key? key,
    //  required this.playerInstance,
  }) : super(key: key);

  // final AudioPlayer playerInstance ;
  late AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Songs'),
        centerTitle: true,
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
          return state.songs == null || state.songs.isEmpty
              ? const Center(
                  child: Text('you do not have any song on your device'),
                )
              : ListView.builder(
                  itemCount: state.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlaying(
                                    player: player,
                                    playlist: defaultPlaylist(state.songs),
                                    songIndex: index,
                                  ))),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: artworkWidget(
                                audioId: state.songs[index].id,
                                artworkType: ArtworkType.AUDIO)),
                      ),
                      title: Text(
                        state.songs[index].title,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                        //style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        state.songs[index].artist!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: durationWidget(
                          context: context,
                          duration: state.songs[index].duration!),
                      // trailing: Text('${state.songs[index].duration}'),
                    );
                  });
        }
        // else if (state is LibraryError) {
        //   return Center(child: Text(state.error));
        // }
        else {
          return const Center(child: Text('yoioyoyioio')
              // CircularProgressIndicator(),
              );
        }
      },
    );
  }

  Widget durationWidget(
      {required BuildContext context, required int duration}) {
    final Duration songDuration = Duration(milliseconds: duration);
    return Text(
        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                .firstMatch("$songDuration")
                ?.group(1) ??
            '$songDuration',
        style: Theme.of(context).textTheme.bodySmall);
  }

  defaultPlaylist(List<SongModel> songList) {
    return ConcatenatingAudioSource(
        children: List.generate(
            songList.length,
            (index) => AudioSource.file(songList[index].data,
                tag: MediaItem(
                  id: '${songList[index].id}',
                  album: songList[index].album!,
                  artist: songList[index].artist!,
                  title: songList[index].title,
                  //artUri: Uri.parse(String.fromCharCodes(LibraryRepository().fetchArtwork()))
                  // artwork: artworkWidget(
                  //     audioId: songList[index].id,
                  //     artworkType: ArtworkType.AUDIO),
                ))));
  }

  // Widget songItem(SongModel song){
  //   return ListTile(
  //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NowPlaying(song: song))),
  //     leading: QueryArtworkWidget(
  //                         id: song.id,
  //                         type: ArtworkType.AUDIO,
  //                       ),
  //                       title: Text(song.title),
  //                       subtitle: Text(song.artist!),
  //                       trailing: Text('${song.duration}'),
  //   );
  // }
}

// class AudioMetadata {
//   final String title;
//   final String? album;
//   final String artist;
//   final Widget? artwork;

//   AudioMetadata({
//     required this.title,
//     required this.artist,
//     this.album,
//     this.artwork,
//   });
// }
