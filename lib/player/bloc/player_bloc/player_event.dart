// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'player_bloc.dart';

@immutable
class PlayerEvent {}

class PlayerInitialize extends PlayerEvent {
  PlayerInitialize();
}

class PlayerDefaultPlaylist extends PlayerEvent {
  final ConcatenatingAudioSource defaultList;
  final int libraryLength;
  PlayerDefaultPlaylist(
      {required this.defaultList, required this.libraryLength});
}

class ChangePlaylist extends PlayerEvent {
  final ConcatenatingAudioSource playlist;
  final int songIndex;
  ChangePlaylist({required this.playlist, required this.songIndex});
}

class AddToPlaylist extends PlayerEvent {
  final AudioSource audioSource;
  AddToPlaylist({
    required this.audioSource,
  });
}

class ClearPlaylist extends PlayerEvent {}
