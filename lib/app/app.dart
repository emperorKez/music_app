import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/player/utils/common.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  final equalizer = AndroidEqualizer();
  final loudnessEnhancer = AndroidLoudnessEnhancer();
  // final _bassBoast = AndroidAudioEffect()

  late final player = AudioPlayer(
      //   audioPipeline: AudioPipeline(androidAudioEffects: [equalizer,
      // loudnessEnhancer,
      // ])
      );

  // late AudioPlayer player;

  @override
  initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    //    player = AudioPlayer(
    //     audioPipeline: AudioPipeline(androidAudioEffects: [equalizer,
    //   loudnessEnhancer,
    // ]));

    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  // Future<void> _init() async {

  // //    player = AudioPlayer(
  // //     audioPipeline: AudioPipeline(androidAudioEffects: [
  // //   _loudnessEnhancer,
  // // ]));

  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.music());
  //   // await session.configure(const AudioSessionConfiguration(
  //   //   avAudioSessionCategory: AVAudioSessionCategory.playback,
  //   //       avAudioSessionMode: AVAudioSessionMode.defaultMode,
  //   //       androidAudioAttributes: const AndroidAudioAttributes(
  //   //         contentType: AndroidAudioContentType.music,
  //   //         usage: AndroidAudioUsage.media,
  //   //       ),
  //   //       androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  //   //       androidWillPauseWhenDucked: false
  //   // ));

  //   // Listen to errors during playback.
  //   widget.player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //     print('A stream error occurred: $e');
  //   });
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
  //     await widget.player.setAudioSource(widget.playlist,
  //         initialIndex: widget.songIndex);

  //     widget.player.play();

  //   } catch (e) {
  //     print("Error loading audio source: $e");
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
