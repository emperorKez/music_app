// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:music_app/data.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({required this.playlistTitle, this.playlistArtwork, super.key});
  final String? playlistArtwork;
  final String playlistTitle;



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () =>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios))),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), 
        padding: const EdgeInsets.symmetric(horizontal: 10),
       children: [
        artworkContainer(),
        songsContainer()]
      ),
    ));
  }
  
  Widget songsContainer() {
    return Container(
      padding: const EdgeInsets.all(10), margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: songlist.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: AspectRatio(aspectRatio: 1, child: Image.asset(songlist[index].artwork, fit: BoxFit.fill,),),
            title: Text(songlist[index].title, style: const TextStyle(fontSize: 18, color: Colors.white),),
            subtitle: Text(songlist[index].artiste, style: const TextStyle(fontSize: 14, color: Colors.grey),),
            trailing: Text('${songlist[index].duration}', style: const TextStyle(fontSize: 16, color: Colors.white),)
          );
        },
      ),
    );
  }
  
  Widget artworkContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), image: DecorationImage(image: AssetImage(playlistArtwork ?? 'assets/images/default_artwork.png'))
      ),
      child: Positioned(bottom: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(playlistTitle),
            ElevatedButton(style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(10)
            ),
              onPressed: (){}, child: const Icon(Icons.play_arrow, color: Colors.white,))
          ],
        )),
    );
  }
}

