import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/blocs/audio_query_bloc/audio_query_bloc.dart';
import 'package:music_app/screens/now_playing.dart';
import 'package:music_app/widgets/error_snackbar.dart';
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
    return BlocConsumer<AudioQueryBloc, AudioQueryState>(
      listener: (context, state) {
        if (state is AudioQueryError) {
          ErrorSnackbar(error: state.error, context: context);
        }
      },
      builder: (context, state) {
        if (state is AudioQueryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AudioQueryLoaded) {
          return state.songs == null || state.songs!.isEmpty
              ? const Center(
                  child: Text('you do not have any song on your device'),
                )
              : ListView.builder(
                  itemCount: state.songs!.length,
                  itemBuilder: (context, index) {
                    
                    return ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NowPlaying(song: state.songs![index]))),
                      leading: QueryArtworkWidget(
                        id: state.songs![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(
                        state.songs![index].title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(state.songs![index].artist!),
                      // trailing: Text('$songDuration'),
                      trailing: Text('${state.songs![index].duration}'),
                    );
                  });
        } else if (state is AudioQueryError) {
          return Center(child: Text(state.error));
        } else {
          return 
          Center(child: Text('yoioyoyioio')
              // CircularProgressIndicator(),
              );
        }
      },
    );
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
