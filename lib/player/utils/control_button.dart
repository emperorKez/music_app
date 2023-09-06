import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/utils/common.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({required this.player, super.key});
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Opens volume slider dialog
        GestureDetector(
          onTap: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
          child: const Icon(Icons.volume_up),
        ),

        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(Icons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return GestureDetector(
              onTap: () {
                player.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
              child: icons[index],
            );
          },
        ),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => GestureDetector(
            onTap: player.hasPrevious ? player.seekToPrevious : null,
            child: const Icon(
              Icons.skip_previous,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return GestureDetector(
                  // iconSize: 48.0,
                  onTap: player.play,
                  // color: Colors.white);
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 32,
                      )));
            } else if (processingState != ProcessingState.completed) {
              return GestureDetector(
                  // iconSize: 48.0,
                  onTap: player.pause,
                  // color: Colors.white);
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: const Icon(
                        Icons.pause,
                        size: 32,
                      )));
            } else if (processingState == ProcessingState.idle) {
              player.play();
              return IconButton(
                  icon: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: const Icon(
                        Icons.pause,
                        size: 32,
                      )),
                  iconSize: 48.0,
                  onPressed: player.pause,
                  color: Colors.white);
            } else {
              return GestureDetector(
                onTap: () => player.seek(Duration.zero),
                child: const Icon(
                  Icons.replay,
                  size: 32,
                  color: Colors.white,
                ),
              );
            }
          },
        ),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => GestureDetector(
            onTap: player.hasNext ? player.seekToNext : null,
            child: const Icon(
              Icons.skip_next,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),

        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return GestureDetector(
              onTap: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await player.shuffle();
                }
                await player.setShuffleModeEnabled(enable);
              },
              child: shuffleModeEnabled
                  ? const Icon(Icons.shuffle, color: Colors.orange)
                  : const Icon(Icons.shuffle, color: Colors.grey),
            );
          },
        ),

        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 12,
                min: 0.25,
                max: 2,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
