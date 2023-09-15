import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/library/validator/search_form_validator.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchKeywordChanged>(onSearchKeywordChanged);
    on<SearchCanceled>(onSearchCanceled);
  }

  Future<void> onSearchKeywordChanged(
      SearchKeywordChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final List<SongModel> songLibrary = event.songLibrary;
      List<SongModel> data = [];
      for (var song in songLibrary) {
        if (song.title.contains(event.keyword) ||
            (song.artist != null && song.artist!.contains(event.keyword))) {
          data.add(song); 
          print('this is the keyword: ${event.keyword}');
          print(data);
        }
      }
      emit(SearchLoaded(songs: data, isSearching: true));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }

  Future<void> onSearchCanceled(event, Emitter<SearchState> emit) async {
    emit(SearchInitial());
  }
}
