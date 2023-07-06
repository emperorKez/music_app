
import 'package:flutter/material.dart';
import 'package:music_app/data.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({required this.song, super.key});
  final Song song;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Scaffold(appBar: AppBar(
      leading: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz, color: Colors.white,))
      ],
    ),
    body: Column(
      mainAxisSize: MainAxisSize.max  ,
      crossAxisAlignment: CrossAxisAlignment.start  ,
      children: [
AspectRatio(aspectRatio: 1, child: ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.asset(song.artwork),
),),
const Spacer(),
songDetail(),
const SizedBox(height: 20,),
songProgress(),
const SizedBox(height: 20,),
player()
      ],
    ),
    ));
  }
  
  Widget songDetail() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
    children: [
      Text(song.title, style: const TextStyle(fontSize: 16, color: Colors.white),), IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_outline))
    ],
  ), 
  Text(song.artiste)
],);
  }
  
  Widget player() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.shuffle)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.fast_rewind)),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white,
            shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
            onPressed: (){}, child: const Icon(Icons.pause)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.fast_forward)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.sync)),

        ],
      ),
    );
  }
  
  Widget songProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LinearProgressIndicator(
          color: Colors.grey, 
          value: 0.45,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: const [
          Text('1:28'),
          Text('3:58'),
        ],)
      ],
    );
  }
}