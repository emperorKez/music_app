


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/library/view/widget/show_dialog.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

Widget searchListView(List<SongModel> songList) {
  return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: songList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            context.read<PlayerBloc>().add(ChangePlaylist(
                playlist: createNowPlaylist(songList: songList, context: context), songIndex: index));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                          player: context.read<PlayerBloc>().state.player!,
                        )));
          },
          onLongPress: () {
            //Todo
            showOnPressedDialog(context: context, song: songList[index]);
          },
          // leading: AspectRatio(
          //   aspectRatio: 1,
          //   child: ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: artworkWidget(
          //           audioId: songList[index].id,
          //           artworkType: ArtworkType.AUDIO)),
          // ),
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