import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/utils/equaliser_control.dart';
import 'package:music_app/player/utils/loudness_enhancer.dart';

class EqualizerScreen extends StatelessWidget {
  const EqualizerScreen({required this.equalizer, required this.loudnessEnhancer, super.key});
  final AndroidEqualizer equalizer;
  final AndroidLoudnessEnhancer loudnessEnhancer;
  // final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    

    
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
              ),]);
  }
}