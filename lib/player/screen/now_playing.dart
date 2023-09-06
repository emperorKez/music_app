import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:music_app/player/utils/control_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({required this.song, required this.playlist, this.songIndex, super.key});
  final SongModel song;
  final ConcatenatingAudioSource playlist;
  final int? songIndex;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
  
}

class _NowPlayingState extends State<NowPlaying> with WidgetsBindingObserver {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _equalizer = AndroidEqualizer();
  final _loudnessEnhancer = AndroidLoudnessEnhancer();
  late final player = AudioPlayer(
    audioPipeline: AudioPipeline(
      androidAudioEffects: [
        _loudnessEnhancer,
        _equalizer
      ]
    )
  );
  

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await player.setAudioSource(
        widget.playlist, initialIndex: widget.songIndex
      );

        // AudioSource.
        //   file(widget.song.data));
          // uri(Uri.parse(
          //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }

    // Show a snackbar whenever reaching the end of an item in the playlist.
    // player.positionDiscontinuityStream.listen((discontinuity) {
    //   if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
    //     showItemFinished(discontinuity.previousEvent.currentIndex);
    //   }
    // });
    // player.processingStateStream.listen((state) {
    //   if (state == ProcessingState.completed) {
    //     showItemFinished(player.currentIndex);
    //   }
    // });
  }




  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print(widget.song.uri);
    print(widget.song.track);
    print(widget.song.fileExtension);
    print(widget.song.data);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  )),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ))
              ],
            ),
            body: body()));
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: QueryArtworkWidget(
                    id: widget.song.id,
                    type: ArtworkType.AUDIO,
                  ),
                  // Image.asset(
                  //   song.artwork,
                  //   fit: BoxFit.fill,
                  // ),
                ),
              ),
            ),
          ),
          //const Spacer(),
          songDetail(),
          const SizedBox(
            height: 20,
          ),
          songProgressBar(player),
          const SizedBox(
            height: 20,
          ),
          ControlButtons(player: player)
        ],
      ),
    );
  }

  Widget songDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.song.title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline))
          ],
        ),
        Text(widget.song.artist!)
      ],
    );
  }

  // Widget player() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         IconButton(
  //             onPressed: () {},
  //             icon: const Icon(
  //               Icons.shuffle,
  //               color: Colors.white,
  //             )),
  //         IconButton(
  //             onPressed: () {},
  //             icon: const Icon(Icons.fast_rewind, color: Colors.white)),
  //         ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //                 shape: const CircleBorder(),
  //                 padding: const EdgeInsets.all(20)),
  //             onPressed: () {},
  //             child: const Icon(
  //               Icons.pause,
  //               color: Colors.white,
  //             )),
  //         IconButton(
  //             onPressed: () {},
  //             icon: const Icon(Icons.fast_forward, color: Colors.white)),
  //         IconButton(
  //             onPressed: () {},
  //             icon: const Icon(Icons.sync, color: Colors.white)),
  //       ],
  //     ),
  //   );
  // }

  Widget songProgressBar(AudioPlayer player) {
    // Display seek bar. Using StreamBuilder, this widget rebuilds
    // each time the position, buffered position or duration changes.
    return StreamBuilder<PositionData>(
      stream: positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return SeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: player.seek,
        );
      },
    );
  }



  // void showItemFinished(int? index) {
  //   if (index == null) return;
  //   final sequence = player.sequence;
  //   if (sequence == null) return;
  //   final source = sequence[index];
  //   // final metadata = source.tag as AudioMetadata;
  //   _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
  //     content: Text('Finished playing ${metadata.title}'),
  //     duration: const Duration(seconds: 1),
  //   ));
  // }


}




// class AudioMetadata {
//   final String album;
//   final String title;
//   final String artwork;

//   AudioMetadata({
//     required this.album,
//     required this.title,
//     required this.artwork,
//   });
// }
