import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  // final equalizer = AndroidEqualizer();
  // final loudnessEnhancer = AndroidLoudnessEnhancer();

  // late final player = AudioPlayer(
  //     audioPipeline: AudioPipeline(androidAudioEffects: [equalizer,
  //   loudnessEnhancer,
  // ]));

  PlayerBloc() : super(PlayerInitial()) {
    on<PlayerInitialize>(onPlayerInitialize);
  }

  Future<void> onPlayerInitialize(
      PlayerInitialize event, Emitter<PlayerState> emit) async {
    final equalizer = AndroidEqualizer();
    final loudnessEnhancer = AndroidLoudnessEnhancer();

    final player = AudioPlayer(
        audioPipeline: AudioPipeline(androidAudioEffects: [
      equalizer,
      loudnessEnhancer,
    ])
    );



    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    emit(PlayerLoaded(player: player, equalizer: equalizer, loudnessEnhancer: loudnessEnhancer, nowPlaying: true));
  }

  //  @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Release the player's resources when not in use. We use "stop" so that
  //     // if the app resumes later, it will still remember what position to
  //     // resume from.
  //     player.stop();
  //   }

  //  @override
  // Future<void> close() {
  //   player.dispose();
  //   return super.close();
  // }
}
