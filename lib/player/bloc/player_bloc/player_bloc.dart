import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial()) {
    on<PlayerInitialize>(onPlayerInitialize);
    on<ChangePlaylist>(onChangePlaylist);
    on<AddToPlaylist>(onAddToPlaylist);
    on<ClearPlaylist>(onClearPlaylist);
  }

  Future<void> onPlayerInitialize(
      PlayerInitialize event, Emitter<PlayerState> emit) async {
        try {
          
        
    final equalizer = AndroidEqualizer();
    final loudnessEnhancer = AndroidLoudnessEnhancer();

    final player = AudioPlayer(
        //   audioPipeline: AudioPipeline(androidAudioEffects: [
        // equalizer,
        // loudnessEnhancer,
        // ])
        );

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    int randomNumber = Random().nextInt(event.libraryLength);

    await player.setAudioSource(event.defaultList, initialIndex: randomNumber);

    emit(PlayerLoaded(
        player: player,
        equalizer: equalizer,
        loudnessEnhancer: loudnessEnhancer,
        playlist: event.defaultList));
        } catch (e) {
          emit(PlayerError(err: e.toString()));
        }
  }

  Future<void> onChangePlaylist(
      ChangePlaylist event, Emitter<PlayerState> emit) async {
    final player = state.player;
    emit(PlayerLoading(player: player));
    try {

     final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await player!.setAudioSource(event.playlist, initialIndex: event.songIndex);
    emit(PlayerLoaded(player: player, playlist: event.playlist));
    } catch (e) {
          emit(PlayerError(err: e.toString()));
        }
  }

  Future<void> onAddToPlaylist(
      AddToPlaylist event, Emitter<PlayerState> emit) async {
    final player = state.player;
    emit(PlayerLoading(player: player));
    try {
    ConcatenatingAudioSource? playlist = state.playlist;
    playlist?.add(event.audioSource);

    emit(PlayerLoaded(player: player, playlist: playlist));
    } catch (e) {
          emit(PlayerError(err: e.toString()));
        }
  }

  Future<void> onClearPlaylist(
      ClearPlaylist event, Emitter<PlayerState> emit) async {
    final player = state.player;
    emit(PlayerLoading(player: player));
    try {
    emit(PlayerLoaded(player: player, playlist: null));
    } catch (e) {
          emit(PlayerError(err: e.toString()));
        }
  }
}
