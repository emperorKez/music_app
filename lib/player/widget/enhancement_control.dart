// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/services.dart';
import 'package:music_app/player/screen/equalizer_screen.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class EnhancementControl extends StatelessWidget {
  const EnhancementControl(
      {Key? key,
      required this.player,
      // required this.equalizer,
      // required this.loudnessEnhancer,
      this.song})
      : super(key: key);
  final AudioPlayer player;
  final SongModel? song;
  // final AndroidEqualizer equalizer;
  // final AndroidLoudnessEnhancer loudnessEnhancer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _volumeSlider(context: context),
        _equalizer(context),
        const Spacer(),
        song != null
            ? _addToPlaylist(context, songId: song!.id)
            : const SizedBox(),
        _speedSlider()
      ],
    );
  }

  Widget _volumeSlider({required BuildContext context}) {
    // Opens volume slider dialog
    return IconButton(
      onPressed: () {
        showVerticalSliderDialog(
            context: context,
            // title: "Adjust volume",
            // divisions: 9,
            min: 0.0,
            max: 1.0,
            value: player.volume,
            stream: player.volumeStream,
            onChanged: player.setVolume,
            side: Side.left);
      },
      icon: const Icon(Icons.volume_up),
    );
  }

  Widget _speedSlider() {
    // Opens speed slider dialog
    return StreamBuilder<double>(
      stream: player.speedStream,
      builder: (context, snapshot) => IconButton(
        icon: Text("${snapshot.data?.toStringAsFixed(2)}x",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          showVerticalSliderDialog(
              context: context,
              // title: "Adjust speed",
              divisions: 7,
              min: 0.25,
              max: 2,
              value: player.speed,
              stream: player.speedStream,
              onChanged: player.setSpeed,
              side: Side.right);
        },
      ),
    );
  }

  Widget _equalizer(BuildContext context) {
    return IconButton(
        onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (context) => const EqualizerScreen(
                // equalizer: AppState().equalizer,
                // loudnessEnhancer: AppState().loudnessEnhancer,
                )),
        icon: const Icon(Icons.equalizer));
  }

  Widget _addToPlaylist(BuildContext context, {required int songId}) {
    return IconButton(
        onPressed: () {
          return showContentDialog(context: context, songId: songId);
        },
        icon: const Icon(Icons.playlist_add));
  }

  void showContentDialog({required BuildContext context, required int songId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.only(
            left: 30,
            right: 40,
          ),
          // title: Text(title, textAlign: TextAlign.center),
          content:
              BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
            if (state is LibraryLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    state.playlists!.length,
                    (index) => GestureDetector(
                          onTap: () => LibraryRepository().addToPlaylist(
                              playlistId: state.playlists![index].id,
                              audioId: songId),
                        )),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }
}
