// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class ShowDialog extends StatelessWidget {
//   const ShowDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void showOnPressedDialog(
    {required BuildContext context, required SongModel song}) {
  final deviceWidth = MediaQuery.of(context).size.width;
  final deviceHeight = MediaQuery.of(context).size.height;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
        backgroundColor: Colors.grey,
        contentPadding: const EdgeInsets.all(20),
        insetPadding: EdgeInsets.only(
            left: 50, right: 50, top: deviceHeight - 250, bottom: 30),
        // title: Text(title, textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton.icon(
            onPressed: () => deleteSong(context, song: song),
            icon: const Icon(Icons.playlist_add),
            label: const Text('Add To Playlist'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () => deleteSong(context, song: song),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete Permanently'),
          )
        ])),
  );
}

deleteSong(BuildContext context, {required SongModel song}) async {
  var deleteResponse = await confirmDelete(context);
  if (deleteResponse) {
    File(song.data).delete(recursive: true);
  }
}

confirmDelete(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Song Removal'),
          content: const Text(
              'Are you sure you want to permanently delete this song from your device?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10)),
                child: const Text('Delete')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10)),
                child: const Text('Cancel'))
          ],
        );
      });
}
