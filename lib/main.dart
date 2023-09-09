// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/bloc/app_bloc/app_bloc.dart';
import 'package:music_app/app/common/theme.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/services.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';

import 'app/app.dart';

Future<void> main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.example.music_app.channel.audio',
  //   androidNotificationChannelName: 'Music playback',
  //   androidNotificationOngoing: true,
  // );

  await AudioService.init(
    // builder: () => MyAudioHandler(),
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_app.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

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
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(create: (context) => PlayerBloc() ..add(PlayerInitialize()), lazy: false,),
        BlocProvider(
          create: (context) => LibraryBloc(appRepo: LibraryRepository())
            ..add(FetchLibraryData()),
          lazy: false,
        ),
      ],
      child: 
      MaterialApp(
        title: 'Music App',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  // TODO: Override needed methods
  final _player = AudioPlayer();

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}
