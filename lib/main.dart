import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/blocs/app_bloc/app_bloc.dart';
import 'package:music_app/blocs/audio_query_bloc/audio_query_bloc.dart';
import 'package:music_app/repositories/services.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/utils/theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(
          create: (context) => AudioQueryBloc(appRepo: AppRepository()) ..add(FetchLocalSongs()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
          title: 'Music App',
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        ),
    );
  }
}