// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/app.dart';
import 'package:music_app/app/common/drawer.dart';
import 'package:music_app/app/view/widget/data.dart';
import 'package:music_app/library/view/screen/local_songs.dart';
import 'package:music_app/library/view/screen/playlist_screen.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../library/bloc/library_fetch_bloc/library_fetch_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    // required this.player,
  }) : super(key: key);
  //final AudioPlayer player;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController searchTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: searchBar(),
            ),
            drawer: const AppDrawer(),
            body: body()));
  }

  Widget body() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [playlistContainer(), Expanded(child: favoritesContainer())]);
  }

  Widget searchBar() {
    return Form(
      key: _formkey,
      child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          onChanged: (value) {},
          decoration: const InputDecoration(
              isDense: true,
              filled: true,
              hintText: 'Search Songs, Playlists, artistes ...',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.grey,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          validator: (value) {}),
    );
  }

  Widget playlistContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 200,
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoaded) {
            return GridView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.3),
              itemCount: state.genres.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  // => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PlaylistScreen(player: widget.player,
                  //             playlistTitle: playlists[index].title,
                  //             playlistArtwork: playlists[index].artwork))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                          aspectRatio: 1,
                          child: artworkWidget(
                              audioId: state.genres[index].id,
                              artworkType: ArtworkType.GENRE)
                          //                 ClipRRect(
                          //   borderRadius: BorderRadius.circular(10),
                          //   child: Image.asset(
                          //     playlists[index].artwork,
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(state.genres[index].genre,
                      overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget favoritesContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Favourites'),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SongListScreen())),
                child: const Text('All Songs'),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: favouriteSongs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  // onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             NowPlaying(song: favouriteSongs[index]))),
                  contentPadding: EdgeInsets.zero,
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        favouriteSongs[index].artwork,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(
                    songlist[index].title,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  subtitle: Text(
                    songlist[index].artiste,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    '${songlist[index].duration}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
