// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';


class GenreScreen extends StatefulWidget {
  const GenreScreen({
    Key? key,
    required this.genre,
  }) : super(key: key);
  final GenreModel genre;

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  late AudioPlayer player;
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.genre.genre),
        centerTitle: true,
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
          List<SongModel> audioList = [];
          // for (var audioItem in state.songs){
          //   state.songs.where((e) => e.genreId == widget.genre.id)

          // }
          audioList.addAll(state.songs.where((e) => e.genreId == widget.genre.id));
          if (audioList.isEmpty) {
            return const Center(
              child: Text('No Song in this Genre'),
            );
          } else {
            return isGridView
                ? gridViewWidget(audioList)
                : listViewWidget(audioList);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  
}
