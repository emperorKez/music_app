import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/database.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart' as blocs;
// import 'package:music_app/main.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:music_app/player/utils/control_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import '../widget/enhancement_control.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({required this.player, super.key});
  final AudioPlayer player;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with WidgetsBindingObserver {
  // final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  // final _equalizer = AndroidEqualizer();

  // final _loudnessEnhancer = AndroidLoudnessEnhancer();

  // final _bassBoast = AndroidAudioEffect()

  // late final player = AudioPlayer(
  //     audioPipeline: AudioPipeline(androidAudioEffects: [
  //   _loudnessEnhancer,
  // ]));

  // late AudioPlayer player;

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

    //    player = AudioPlayer(
    //     audioPipeline: AudioPipeline(androidAudioEffects: [
    //   _loudnessEnhancer,
    // ]));

    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());

    // await session.configure(const AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playback,
    //       avAudioSessionMode: AVAudioSessionMode.defaultMode,
    //       androidAudioAttributes: const AndroidAudioAttributes(
    //         contentType: AndroidAudioContentType.music,
    //         usage: AndroidAudioUsage.media,
    //       ),
    //       androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    //       androidWillPauseWhenDucked: false
    // ));

    // Listen to errors during playback.
    widget.player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    // Try to load audio from a source and catch any errors.
    try {
      widget.player.play();

      // if (
      //   // widget.player.playing == false &&
      //  widget.player.playerState.processingState == ProcessingState.idle) {

      //   await widget.player.setAudioSource( defaultPlaylist(),

      //       initialIndex: widget.songIndex);
      // } else if (
      //   // widget.player.playing == true
      //   widget.player.playerState.processingState == ProcessingState.idle
      //   && widget.playlist != null) {
      //   widget.player.stop();
      //   await widget.player
      //       .setAudioSource(widget.playlist!, initialIndex: widget.songIndex);
      //   widget.player.play();
      // }
    } catch (_) {}
  }

  // @override
  // void dispose() {
  //   ambiguate(WidgetsBinding.instance)!.removeObserver(this);
  //   // Release decoders and buffers back to the operating system making them
  //   // available for other apps to use.
  //   widget.player.dispose();
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Release the player's resources when not in use. We use "stop" so that
  //     // if the app resumes later, it will still remember what position to
  //     // resume from.
  //     widget.player.stop();
  //   }
  // }

  @override
  void didChangeDependencies() {}

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.player.positionStream,
          widget.player.bufferedPositionStream,
          widget.player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    // final sequence = player.sequence;
    // final source = sequence![player.currentIndex!];
    // final metadata = source.tag as AudioMetadata;

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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ))
              ],
            ),
            body: body()));
  }

  Widget body() {
    return BlocBuilder<blocs.PlayerBloc, blocs.PlayerState>(
      builder: (context, state) {
        if (state is blocs.PlayerLoaded) {
          final AudioPlayer player = state.player!;

          return StreamBuilder<SequenceState?>(
              stream: state.player!.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }

                final metadata = state!.currentSource!.tag as MediaItem;

                // count song as played
                DatabaseProvider()
                    .updatePlayedCount(songId: int.parse(metadata.id));

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: artworkWidget(
                                  audioId: int.parse(metadata.id),
                                  artworkType: ArtworkType.AUDIO)),
                        ),
                      ),

                      //const Spacer(),
                      // widget.player.playerState.processingState != ProcessingState.idle ?
                      songDetail(metadata),
                      // : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      // widget.player.playerState.processingState == ProcessingState.idle ?
                      BlocBuilder<LibraryBloc, LibraryState>(
                        builder: (context, state) {
                          if (state is LibraryLoaded) {
                            // print('playlist length =   ${widget.playlist?.length}');

                            // if(widget.player.playerState.processingState != ProcessingState.idle){
                            // print(state.songs[state.songs.indexWhere(
                            //             (e) => e.id == int.parse(metadata.id))]);
                            // }

                            print('metadata Id = ${metadata.id}');
                            print('metadata Title = ${metadata.title}');
                            print('metadata Artist = ${metadata.artist}');

                            return EnhancementControl(
                              player: player,
                              // song: widget.playlist != null
                              //     ? state.songs[state.songs.indexWhere(
                              //         (e) => e.id == int.parse(metadata.id))]
                              //     : null
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      // : const SizedBox(),
                      songProgressBar(player),
                      const SizedBox(
                        height: 20,
                      ),
                      ControlButtons(player: player)
                    ],
                  ),
                );
              });
        } else if (state is blocs.PlayerError) {
          return Text(state.err);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget songDetail(MediaItem metadata) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
            repeatForever: true,
            pause: Duration.zero,
            animatedTexts: [
              TyperAnimatedText(
                metadata.title,
                speed: const Duration(milliseconds: 250),
                curve: Curves.linear,
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ]),
        Text(metadata.artist!,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall)
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
  // final metadata = source.tag as AudioMetadata;
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
