// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'audio_query_bloc.dart';

@immutable
class AudioQueryState {
  final List<SongModel>? songs;
  final List<AlbumModel>? albums;
  const AudioQueryState({
    this.songs,
    this.albums
  });
 }

class AudioQueryInitial extends AudioQueryState {}

class AudioQueryLoading extends AudioQueryState {}

class AudioQueryLoaded extends AudioQueryState {
  const AudioQueryLoaded({required super.songs, required super.albums});
}

class AudioQueryError extends AudioQueryState {
  const AudioQueryError({this.error = 'Something went wrong'});
  final String error;
}
