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
      final List<SongModel> songData = await appRepo.fetchSonges();
      // final defaultSongList = songData;
      final albumData = await appRepo.fetchAlbums();
      final genreData = await appRepo.fetchGenres();
      final artistData = await appRepo.fetchArtists();
      final playlistData = await appRepo.fetchPlaylists();

      // int indexOfFavoritePlaylist = playlistData.indexWhere((e) => e.playlist == 'favorite');
      // if (indexOfFavoritePlaylist < 0){
      //   await appRepo.createPlaylist(name: 'favorite');
      //   final playlistData = await appRepo.fetchPlaylists();
      // }

      // for (var e in playlistData){
      //   if (e.playlist == 'favorite'){}
      // }

      // for (var element in playlistData){
      //   if (element.playlist == 'Recently Added'){
      //     await appRepo.removePlaylist(playlistId: element.id);
      //   }
      // }
      // await appRepo.createPlaylist(name: 'Recently Added');
      // songData.sort((a, b) => a.dateAdded!.compareTo(b.dateAdded!)) ;
      // for (int i = 0; i <= 10; i++){
      //   await appRepo.addToPlaylist(playlistId: playlistData[playlistData.indexWhere((e) => e.playlist == 'Recently Added')].id, audioId: songData[1].id);
      // }


      
      emit(LibraryLoaded(songs: songData, albums: albumData, artists: artistData, genres: genreData, playlists: playlistData));
    } catch (e) {
      emit(LibraryError(error: e.toString()));
      
    }
    }
  }
}
