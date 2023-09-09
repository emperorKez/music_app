// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/screen/equalizer_screen.dart';
import 'package:music_app/player/utils/common.dart';



class EnhancementControl extends StatelessWidget {
  const EnhancementControl({
    Key? key,
    required this.player,
    // required this.equalizer,
    // required this.loudnessEnhancer,
  }) : super(key: key);
  final AudioPlayer player;
  // final AndroidEqualizer equalizer;
  // final AndroidLoudnessEnhancer loudnessEnhancer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _volumeSlider(context: context),
        _equalizer(context),
        const Spacer(),
        _addToPlaylist(),
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
          side: Side.left
        );
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
            side: Side.right
          );
        },
      ),
    );
  }

  Widget _equalizer(BuildContext context) {
    return IconButton(
        onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (context) => EqualizerScreen(
                // equalizer: AppState().equalizer,
                // loudnessEnhancer: AppState().loudnessEnhancer,
                )),
        icon: const Icon(Icons.equalizer));
  }

  Widget _addToPlaylist() {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.playlist_add));
  }
}
