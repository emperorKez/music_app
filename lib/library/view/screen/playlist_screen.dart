// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/app/view/widget/data.dart';


class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen(
      {required this.playlistTitle, this.playlistArtwork,required this.player, super.key});
  final String? playlistArtwork;
  final String playlistTitle;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ))),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            artworkContainer(context),
            Expanded(child: songsContainer())
          ]),
    ));
  }

  Widget songsContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: songlist.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              // onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => NowPlaying(song: songlist[index]))),
              contentPadding: EdgeInsets.zero,
              leading: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  songlist[index].artwork,
                  fit: BoxFit.fill,
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
    );
  }

  Widget artworkContainer(context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: ClipRRect(
            child: Image.asset(
              playlistArtwork ?? 'assets/images/default_artwork.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
            bottom: 60,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(playlistTitle),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ))
                ],
              ),
            ))
      ],
    );
  }
}
