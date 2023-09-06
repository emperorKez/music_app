import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/bloc/app_bloc/app_bloc.dart';
import 'package:music_app/app/view/screen/home_screen.dart';
import 'package:music_app/app/common/theme.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';
import 'package:music_app/library/repository/services.dart'; 
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
          create: (context) => LibraryBloc(appRepo: LibraryRepository()) ..add(FetchLibraryData()),
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