// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'player_bloc.dart';

@immutable
class PlayerState {
  final AudioPlayer? player;
  final AndroidEqualizer? equalizer;
  final AndroidLoudnessEnhancer? loudnessEnhancer;
  final ConcatenatingAudioSource? playlist;
  const PlayerState({
     this.player,
     this.playlist,
     this.equalizer,this.loudnessEnhancer
  });

  // PlayerState copyWith({
  //   bool? nowPlaying,
  //   AudioPlayer? player
  // }) {
  //   return PlayerState(
  //     player: player ?? this.player
  //   );
  // }
}

class PlayerInitial extends PlayerState {
}

class PlayerLoading extends PlayerState {
  const PlayerLoading({
    required super.player
  });
}

class PlayerLoaded extends PlayerState {
  // final AudioPlayer player;
  const PlayerLoaded({
    required super.player,
    required super.playlist,
    super.equalizer, super.loudnessEnhancer
  });
}

class PlayerError extends PlayerState {
  final String err;
  const PlayerError({
    required this.err,
  });
}
