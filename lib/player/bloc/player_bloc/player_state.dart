// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'player_bloc.dart';

@immutable
class PlayerState {
  final AudioPlayer? player;
  final bool nowPlaying;
  final AndroidEqualizer? equalizer;
  final AndroidLoudnessEnhancer? loudnessEnhancer;
  const PlayerState({
    this.nowPlaying = false,
     this.player,
     this.equalizer,this.loudnessEnhancer
  });

  PlayerState copyWith({
    bool? nowPlaying,
    AudioPlayer? player
  }) {
    return PlayerState(
      nowPlaying: nowPlaying ?? this.nowPlaying,
      player: player ?? this.player
    );
  }
}

class PlayerInitial extends PlayerState {
}

class PlayerLoading extends PlayerState {
}

class PlayerLoaded extends PlayerState {
  // final AudioPlayer player;
  const PlayerLoaded({
    required super.player,
    required super.nowPlaying, super.equalizer, super.loudnessEnhancer
  });
}
