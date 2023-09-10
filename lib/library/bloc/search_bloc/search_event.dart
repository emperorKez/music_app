part of 'search_bloc.dart';

@immutable
class SearchEvent {}

class SearchKeywordChanged extends SearchEvent {
  final String keyword;
  final List<SongModel> songLibrary;

   SearchKeywordChanged({this.keyword = '', required this.songLibrary});
}

class SearchCanceled extends SearchEvent {}

