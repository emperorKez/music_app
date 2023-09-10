import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/common/bottom_navigation.dart';
import 'package:music_app/app/view/screen/playlist_songs.dart';
import 'package:music_app/app/view/widget/error_snackbar.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        centerTitle: true,
      ),
      floatingActionButton: floatingActionWidget(),
      bottomNavigationBar: const BottomNavBar(activeIndex: 2),
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
          return state.playlists == null || state.playlists!.isEmpty
              ? const Center(
                  child: Text('You have no Playlist'),
                )
              : GridView.builder(
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
                              builder: (context) => PlaylistSongScreen(
                                    playlist: state.playlists![index],
                                    songList: const [],
                                  ))),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.playlists![index].playlist,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text('${state.playlists![index].numOfSongs}',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                      ),
                    );
                  });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget floatingActionWidget() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.playlist_add),
    );
  }
}
