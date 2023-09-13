import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/view/screen/genre_screen.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllGenreScreen extends StatelessWidget {
  const AllGenreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Browse Genre'),
            ),
            body: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoaded) {
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 40,
                            childAspectRatio: 0.8),
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
                                  artworkType: ArtworkType.GENRE),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(state.genres[index].genre,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
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
            )));
  }
}
