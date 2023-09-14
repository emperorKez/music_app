import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/app/bloc/app_bloc/app_bloc.dart';
import 'package:music_app/app/common/theme.dart';
import 'package:music_app/app/repository/app_repo.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/bloc/search_bloc/search_bloc.dart';
import 'package:music_app/library/repository/services.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';

final player = AudioPlayer();

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.music_app.channel.audio',
    androidNotificationChannelName: 'Music playback',
    androidNotificationOngoing: true,
  );

  // _audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.example.music_app.channel.audio',
  //     androidNotificationChannelName: 'Music playback',
  //     androidNotificationOngoing: true,
  //     androidStopForegroundOnPause: true,
  //   ),
  // );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc(appRepo: AppRepository())),
        BlocProvider(
          create: (context) => PlayerBloc()..add(PlayerInitialize()),
          lazy: false,
        ),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(
          create: (context) => LibraryBloc(appRepo: LibraryRepository())
            ..add(FetchLibraryData()),
          lazy: false,
        ),
        // BlocProvider(
        //     create: (context) => ArtworkCubit(repo: LibraryRepository())),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Music App',
            theme: state.darkMode == true ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

// class AudioPlayerHandler extends BaseAudioHandler {
//   // TODO: Override needed methods

//   final player = AudioPlayer(
//       audioPipeline: AudioPipeline(androidAudioEffects: [
//     equalizer,
//     loudnessEnhancer,
//   ]));

//   final _player = AudioPlayer();

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> skipToNext() => _player.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);
// }
