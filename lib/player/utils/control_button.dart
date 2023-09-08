import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({required this.player, super.key});
  final AudioPlayer player;

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder<LoopMode>(
            stream: widget.player.loopModeStream,
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
              return IconButton(
                onPressed: () {
                  widget.player.setLoopMode(cycleModes[
                      (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                },
                icon: icons[index],
              );
            },
          ),

          StreamBuilder<SequenceState?>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              onPressed: widget.player.hasPrevious
                  ? widget.player.seekToPrevious
                  : null,
              icon: const Icon(
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
            stream: widget.player.playerStateStream,
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
                return IconButton(
                    iconSize: 48.0,
                    onPressed: widget.player.play,
                    icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: Colors.white,
                        )));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    iconSize: 48.0,
                    onPressed: widget.player.pause,
                    // color: Colors.white);
                    icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(
                          Icons.pause,
                          size: 32,
                          color: Colors.white,
                        )));
              } else if (processingState == ProcessingState.idle) {
                widget.player.play();
                return IconButton(
                    icon: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(
                          Icons.pause,
                          size: 32,
                        )),
                    iconSize: 48.0,
                    onPressed: widget.player.pause,
                    color: Colors.white);
              } else {
                return IconButton(
                  onPressed: () => widget.player.seek(Duration.zero),
                  icon: const Icon(
                    Icons.replay,
                    size: 32,
                    color: Colors.white,
                  ),
                );
              }
            },
          ),

          StreamBuilder<SequenceState?>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              onPressed:
                  widget.player.hasNext ? widget.player.seekToNext : null,
              icon: const Icon(
                Icons.skip_next,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          StreamBuilder<bool>(
            stream: widget.player.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffleModeEnabled = snapshot.data ?? false;
              return IconButton(
                onPressed: () async {
                  final enable = !shuffleModeEnabled;
                  if (enable) {
                    await widget.player.shuffle();
                  }
                  await widget.player.setShuffleModeEnabled(enable);
                },
                icon: shuffleModeEnabled
                    ? const Icon(Icons.shuffle, color: Colors.orange)
                    : const Icon(Icons.shuffle, color: Colors.grey),
              );
            },
          ),
        ],
      ),
    );
  }
}
