import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/library/view/widget/show_dialog.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../player/bloc/player_bloc/player_bloc.dart';

Widget durationWidget({required BuildContext context, required int duration}) {
  final Duration songDuration = Duration(milliseconds: duration);
  return Text(
      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
              .firstMatch("$songDuration")
              ?.group(1) ??
          '$songDuration',
      style: Theme.of(context).textTheme.bodySmall);
}

createNowPlaylist(List<SongModel> songList) {
  return ConcatenatingAudioSource(
      children: List.generate(songList.length, (index) {
    return AudioSource.file(songList[index].data,
        tag: MediaItem(
          id: '${songList[index].id}',
          album: songList[index].album!,
          artist: songList[index].artist!,
          title: songList[index].title,
          //  artUri: Uri.dataFromBytes(LibraryRepository().fetchArtwork(songList[index].id) )
          //  artUri: Uri.
        ));
  }));
}

Widget gridViewWidget(List<SongModel> songList) {
  return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
              context.read<PlayerBloc>().add(ChangePlaylist(playlist: createNowPlaylist(songList), songIndex: index));
               Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(player: context.read<PlayerBloc>().state.player!,)));},
                  onLongPress: () {
                      //Todo
                      showOnPressedDialog(context: context, song: songList[index]);
                    },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: artworkWidget(
                      audioId: songList[index].id,
                      artworkType: ArtworkType.AUDIO),
                ),
              ),
              Text(
                songList[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      songList[index].artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: durationWidget(
                          context: context,
                          duration: songList[index].duration!))
                ],
              )
            ],
          ),
        );
      });
}

Widget listViewWidget(List<SongModel> songList) {
  return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: songList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            context.read<PlayerBloc>().add(ChangePlaylist(playlist: createNowPlaylist(songList), songIndex: index));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(player: context.read<PlayerBloc>().state.player!,)));
          },
          onLongPress: () {
                      //Todo
                      showOnPressedDialog(context: context, song: songList[index]);
                    },
          leading: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: artworkWidget(
                    audioId: songList[index].id,
                    artworkType: ArtworkType.AUDIO)),
          ),
          title: Text(
            songList[index].title,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          subtitle: Text(
            songList[index].artist!,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: durationWidget(
              context: context, duration: songList[index].duration!),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          horizontalTitleGap: 10,
          minVerticalPadding: 0,
        );
      });
}
