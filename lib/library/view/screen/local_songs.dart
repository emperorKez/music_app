import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                    song: state.songs[index],
                                    playlist: defaultPlaylist(state.songs),
                                    songIndex: index,
                                  ))),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: QueryArtworkWidget(
                            id: state.songs[index].id,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                      ),
                      title: Text(
                        state.songs[index].title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(state.songs[index].artist!),
                      // trailing: Text('$songDuration'),
                      trailing: Text('${state.songs[index].duration}'),
                    );
                  });
        }
        // else if (state is LibraryError) {
        //   return Center(child: Text(state.error));
        // }
        else {
          return Center(child: Text('yoioyoyioio')
              // CircularProgressIndicator(),
              );
        }
      },
    );
  }

  defaultPlaylist(List<SongModel> songList) {
    return ConcatenatingAudioSource(
        children: List.generate(songList.length,
            (index) => AudioSource.file(songList[index].data)));
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
  //   )
  // }
}
