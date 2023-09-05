import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../repositories/services.dart';

part 'audio_query_event.dart';
part 'audio_query_state.dart';

class AudioQueryBloc extends Bloc<AudioQueryEvent, AudioQueryState> {
final AppRepository appRepo;
  AudioQueryBloc({required this.appRepo}) : super(AudioQueryInitial()) {
    on<FetchLocalSongs>(onFetchLocalSongs);
  }

  Future<void> onFetchLocalSongs(FetchLocalSongs event, Emitter<AudioQueryState> emit) async {
    emit(AudioQueryLoading());
    bool hasPermission = await appRepo.checkAndRequestPermissions();
    if (hasPermission){
    try {
      final songData = await appRepo.fetchSonges();
      final albumData = await appRepo.fetchAlbums();
      emit(AudioQueryLoaded(songs: songData, albums: albumData));
    } catch (e) {
      emit(AudioQueryError(error: e.toString()));
      
    }
    } else {
      print('%%%%%% No Permission  $hasPermission');
    }
  }
}
