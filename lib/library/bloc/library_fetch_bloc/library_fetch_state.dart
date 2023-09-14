// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'library_fetch_bloc.dart';

@immutable
class LibraryState {
  // final List<SongModel>? songs;
  // final List<AlbumModel>? albums;
  // final List<GenreModel>? genres;
  // final List<ArtistModel>? artists;
  // const LibraryState({
  //   this.songs,
  //   this.albums,
  //   this.genres,
  //   this.artists
  // });
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<SongModel> songs;
  final List<AlbumModel> albums;
  final List<GenreModel> genres;
  final List<ArtistModel> artists;
  final List<PlaylistModel>? playlists;
  LibraryLoaded(
      {required this.songs,
      required this.albums,
      required this.genres,
      required this.artists,
      this.playlists});
  // const LibraryLoaded({required super.songs, required super.albums});
}

class LibraryError extends LibraryState {
  LibraryError({this.error = 'Something went wrong'});
  final String error;
}
