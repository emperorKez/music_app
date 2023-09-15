// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_app/library/repository/services.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:path_provider/path_provider.dart';

// part 'artwork_state.dart';

// class ArtworkCubit extends Cubit<ArtworkState> {
//   final LibraryRepository repo;
//   ArtworkCubit({required this.repo}) : super(ArtworkInitial());

//   saveArtworkToFile({required List<SongModel> songs}) async {
//     List<ArtworkFile> artworkList = [];
//     Directory dir = await getApplicationDocumentsDirectory();
    // getApplicationCacheDirectory();

    // await File(path).create(recursive: true, exclusive: false);

    // for (var song in songs) {
    //   // // if(

    //   // print(dir);
    //   // print(await Directory('${dir.path}').exists());

    //   if (await File('${dir.path}/default.png').exists()
    //       // await Directory('${dir.path}/default.png').exists() == false
    //       ) {
    //     String imageFile = Directory('${dir.path}/default.png').path;
    //     //  print(imageFile);
    //     // var pf =
    //     //     await File(imageFile).create(recursive: true, exclusive: false);

        
//     //   } else {
//     //   }
//       // //   {

//       // // }

//       String imageFile;
//       // if (await Directory('${dir.path}/${song.id}.png').exists() == false) {
//       //   print('ooooooookinrrjrrrjrjr');
//       //   var data = await repo.fetchArtwork(song.id);
//       //   imageFile = Directory('${dir.path}/${song.id}.png').path;
//       //   print('2222222222  $data');
//       //  if (data != null){
//       //    await File(imageFile).create(recursive: true, exclusive: false);
//       //   await File(imageFile).writeAsBytes(data!);
//       //   artworkList.add(ArtworkFile(uri: imageFile, songId: song.id));
//       //  }
//       // }
//     }
//     emit(ArtworkLoaded(artwork: artworkList));
//   }
// }
