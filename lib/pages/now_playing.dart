import 'package:flutter/material.dart';
import 'package:music_app/data.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({required this.song, super.key});
  final Song song;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      song.artwork,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            //const Spacer(),
            songDetail(),
            const SizedBox(
              height: 20,
            ),
            songProgress(),
            const SizedBox(
              height: 20,
            ),
            player()
          ],
        ),
      ),
    ));
  }

  Widget songDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              song.title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline))
          ],
        ),
        Text(song.artiste)
      ],
    );
  }

  Widget player() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shuffle,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.fast_rewind, color: Colors.white)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20)),
              onPressed: () {},
              child: const Icon(
                Icons.pause,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.fast_forward, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sync, color: Colors.white)),
        ],
      ),
    );
  }

  Widget songProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LinearProgressIndicator(
          value: 0.45,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('1:28'),
            Text('3:58'),
          ],
        )
      ],
    );
  }
}
