import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/library/repository/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'library_fetch_event.dart';
part 'library_fetch_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
final LibraryRepository appRepo;
  LibraryBloc({required this.appRepo}) : super(LibraryInitial()) {
    on<FetchLibraryData>(onFetchLibraryData);
  }

  Future<void> onFetchLibraryData(FetchLibraryData event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    bool hasPermission = await appRepo.checkAndRequestPermissions();
    if (hasPermission){
    try {
      final songData = await appRepo.fetchSonges();
      final albumData = await appRepo.fetchAlbums();
      final genreData = await appRepo.fetchGenres();
      final artistData = await appRepo.fetchArtists();
      final playlistData = await appRepo.fetchPlaylists();
      
      emit(LibraryLoaded(songs: songData, albums: albumData, artists: artistData, genres: genreData));
    } catch (e) {
      emit(LibraryError(error: e.toString()));
      
    }
    }
  }
}
