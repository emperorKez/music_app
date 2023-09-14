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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<LoopMode>(
            stream: widget.player.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
            final icons = [
                const Icon(Icons.repeat, color: Colors.grey,  size: 20,),
                Icon(Icons.repeat, color: Theme.of(context).primaryColor,  size: 20,),
                Icon(Icons.repeat_one, color: Theme.of(context).primaryColor,  size: 20,),
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
              icon: Icon(
                Icons.skip_previous,
                size: 24,
                color: Theme.of(context).primaryColor,
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
                return IconButton(
                    iconSize: 50.0,
                    onPressed: (){},
                    icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: Colors.white,
                        )
                        ));
              } else if (playing != true) {
                return IconButton(
                    iconSize: 50.0,
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
                    iconSize: 50.0,
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
              } 
              // else if (processingState == ProcessingState.idle) {
              //   widget.player.play();
              //   return IconButton(
              //       icon: Container(
              //           decoration: const BoxDecoration(
              //               shape: BoxShape.circle, color: Colors.green),
              //           child: const Icon(
              //             Icons.pause,
              //             size: 32,
              //           )),
              //       iconSize: 48.0,
              //       onPressed: widget.player.pause,
              //       color: Colors.white);
              // }
               else {
                return IconButton(
                  onPressed: () => widget.player.seek(Duration.zero),
                  icon: Icon(
                    Icons.replay,
                    size: 32,
                    color: Theme.of(context).primaryColor,
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
              icon: Icon(
                Icons.skip_next,
                size: 24,
                color: Theme.of(context).primaryColor,
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
                    ? Icon(Icons.shuffle, color: Theme.of(context).primaryColor, size: 20,)
                    : const Icon(Icons.shuffle, color: Colors.grey, size: 20,),
              );
            },
          ),
        ],
      ),
    );
  }
}
