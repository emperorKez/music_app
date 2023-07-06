import 'package:flutter/material.dart';
import 'package:music_app/data.dart';
import 'package:music_app/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController searchTerm = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: searchBar(),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:[
          playlistContainer(),
          favoritesContainer()
          ]
        )],
      ),
    ));
  }

  Widget searchBar() {
    return Form(key: _formkey,
      child: TextFormField(
              keyboardType: TextInputType.text,
              autofocus: true,
              onChanged: (value) {},
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Search Osngs, Playlists, artistes ...',
                hintStyle: TextStyle(
                  //color: Colors.black,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding: EdgeInsets.all(10),

                fillColor: Colors.white,
                border: InputBorder.none,
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
              validator: (value) {}
            ),
      );
  }

  Widget playlistContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1
        ),
        itemCount: playlists.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage(playlists[index].artwork,))
            ),
            child: Positioned(bottom: 20,
              child: Text(playlists[index].title, style: const TextStyle(fontSize: 16, color: Colors.white),)),
          );
        },
      ),
    );
  }

  Widget favoritesContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), 
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const Text('Your favourites'),
          const SizedBox(height: 15,) ,
          ListView.builder(
            itemCount: favouriteSongs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: AspectRatio(aspectRatio: 1, child: ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(favouriteSongs[index].artwork, fit: BoxFit.fill,),),),
                title: Text(songlist[index].title, style: const TextStyle(fontSize: 18, color: Colors.white),),
            subtitle: Text(songlist[index].artiste, style: const TextStyle(fontSize: 14, color: Colors.grey),),
            trailing: Text('${songlist[index].duration}', style: const TextStyle(fontSize: 16, color: Colors.white),)
              );
            },
          ),
        ],
      ),
    );
  }
}