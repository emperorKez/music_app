import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/utils/equaliser_control.dart';
import 'package:music_app/player/utils/loudness_enhancer.dart';

class EqualizerScreen extends StatelessWidget {
  const EqualizerScreen(
      {
      // required this.equalizer, required this.loudnessEnhancer,
      super.key});
  // final AndroidEqualizer equalizer;
  // final AndroidLoudnessEnhancer loudnessEnhancer;

  // AndroidEqualizer()

  // final AudioPlayer player = context.read<PlayerBloc>();

  @override
  Widget build(BuildContext context) {
    final AudioPlayer? player = context.read<PlayerBloc>().state.player;
    // final loudnessEnhancer = AndroidLoudnessEnhancer();
    // final equalizer = AndroidEqualizer();
    final AndroidEqualizer equalizer =
        context.read<PlayerBloc>().state.equalizer!;

    final AndroidLoudnessEnhancer loudnessEnhancer =
        context.read<PlayerBloc>().state.loudnessEnhancer!;
    equalizer.parameters;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<bool>(
            stream: loudnessEnhancer.enabledStream,
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return SwitchListTile(
                title: const Text('Loudness Enhancer'),
                value: enabled,
                onChanged: loudnessEnhancer.setEnabled,
              );
            },
          ),
          LoudnessEnhancerControls(loudnessEnhancer: loudnessEnhancer),
          StreamBuilder<bool>(
            stream: equalizer.enabledStream,
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return SwitchListTile(
                title: const Text('Equalizer'),
                value: enabled,
                onChanged: equalizer.setEnabled,
              );
            },
          ),
          Expanded(
            child: EqualizerControls(equalizer: equalizer),
          ),
        ]);
  }
}
