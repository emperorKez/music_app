// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistSongScreen extends StatefulWidget {
  const PlaylistSongScreen(
      {Key? key, required this.songList, required this.playlist})
      : super(key: key);
  final List<SongModel> songList;
  final PlaylistModel playlist;

  @override
  State<PlaylistSongScreen> createState() => _PlaylistSongScreenState();
}

class _PlaylistSongScreenState extends State<PlaylistSongScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    // final player = context.read<PlayerBloc>().state.player!;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.playlist.playlist),
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
          if (widget.songList.isEmpty) {
            return const Center(
              child: Text('No Song in this Genre'),
            );
          } else {
            return isGridView
                ? gridViewWidget(widget.songList)
                : listViewWidget(widget.songList);
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
