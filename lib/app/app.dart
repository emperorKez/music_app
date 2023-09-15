import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

createDefaultArtwork() async {
  Directory dir = await getApplicationDocumentsDirectory();
  if (await File('${dir.path}/default_artwork.jpg').exists() == false) {
    File imageFile = await File('${dir.path}/default_artwork.jpg')
        .create(recursive: true, exclusive: false);

    // ByteData byteData =
    //     await rootBundle.load('assets/images/default_artwork.jpg');

    // imageFile.writeAsBytes(byteData.buffer
    //     .asInt8List(byteData.offsetInBytes, byteData.lengthInBytes));

    imageFile.writeAsString('assets/images/default_artwork.jpg');

    // return imageFile;
  }
}
