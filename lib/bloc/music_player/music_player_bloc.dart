import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/model/music_data.dart';
import 'package:music_player/utils/devlog.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final AudioPlayer audioPlayer;
  int currentTrackId;

  MusicPlayerBloc(this.audioPlayer, {this.currentTrackId = -1}) : super(MusicPlayerStateInitial(MusicData())) {
    on<MusicPlayerEventPlayMusic>(_onMusicPlayerEventPlayMusic);
    on<MusicPlayerEventStopMusic>(_onMusicPlayerEventStopMusic);
    on<MusicPlayerEventNextMusic>(_onMusicPlayerEventNextMusic);
    on<MusicPlayerEventPreviousMusic>(_onMusicPlayerEventPreviousMusic);
  }

  @override
  void onChange(Change<MusicPlayerState> change) {
    super.onChange(change);
    DevLog.d(DevLog.arr, change.toString());
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.currentActiveMusicIndex} - ${change.nextState.currentActiveMusicIndex}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.currentActiveMusic} - ${change.nextState.currentActiveMusic}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.isPlaying} - ${change.nextState.isPlaying}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.position} - ${change.nextState.position}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.bufferedPosition} - ${change.nextState.bufferedPosition}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.totalDuration} - ${change.nextState.totalDuration}');
  }

  @override
  void onTransition(Transition<MusicPlayerEvent, MusicPlayerState> transition) {
    super.onTransition(transition);
    DevLog.d(DevLog.arr, transition.toString());
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.currentActiveMusicIndex} - ${transition.nextState.currentActiveMusicIndex}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.currentActiveMusic} - ${transition.nextState.currentActiveMusic}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.isPlaying} - ${transition.nextState.isPlaying}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.position} - ${transition.nextState.position}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.bufferedPosition} - ${transition.nextState.bufferedPosition}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.totalDuration} - ${transition.nextState.totalDuration}');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    DevLog.d(DevLog.arr, '$error $stackTrace');
  }

  Future<void> _onMusicPlayerEventPlayMusic(MusicPlayerEventPlayMusic event, Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_onMusicPlayerEventPlayMusic');
    if (event.musicData.id != currentTrackId){
      await _resetAudioPlayer(emit);
      await _loadMusic(event.musicData);
    }
    await _playMusic(event.musicData, emit);
  }

  Future<void> _onMusicPlayerEventStopMusic(MusicPlayerEventStopMusic event, Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_onMusicPlayerEventStopMusic');
    await audioPlayer.pause();
    emit(MusicPlayerStateMusicIdle(
      state.currentActiveMusic,
      currentActiveMusicIndex: state.currentActiveMusicIndex,
      isPlaying: false,
      position: state.position,
      bufferedPosition: state.bufferedPosition,
      totalDuration: state.totalDuration,
    ));
  }

  Future<void> _onMusicPlayerEventNextMusic(MusicPlayerEventNextMusic event, Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_onMusicPlayerEventNextMusic');
    await _resetAudioPlayer(emit);
    await _loadMusic(event.musicData);
    await _playMusic(event.musicData, emit);
  }

  Future<void> _onMusicPlayerEventPreviousMusic(MusicPlayerEventPreviousMusic event, Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_onMusicPlayerEventPreviousMusic');
    await _resetAudioPlayer(emit);
    await _loadMusic(event.musicData);
    await _playMusic(event.musicData, emit);
  }

  Future<void> _resetAudioPlayer(Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_resetAudioPlayer');
    await audioPlayer.stop();
    currentTrackId = -1;
    emit(MusicPlayerStateMusicIdle(
      MusicData(),
      currentActiveMusicIndex: -1,
      isPlaying: false,
      position: Duration.zero,
      bufferedPosition: Duration.zero,
      totalDuration: Duration.zero,
    ));
  }

  Future<void> _loadMusic(MusicData musicData) async {
    DevLog.d(DevLog.arr, '_loadMusic');
    await audioPlayer.setUrl(musicData.songUrl);
    await audioPlayer.setLoopMode(LoopMode.one);
    currentTrackId = musicData.id;
  }

  Future<void> _playMusic(MusicData musicData, Emitter<MusicPlayerState> emit) async {
    DevLog.d(DevLog.arr, '_playMusic');
    audioPlayer.play();

    // audioPlayer.positionStream.listen((position) {
    //   emit(MusicPlayerStateMusicPlaying(
    //     state.currentActiveMusic,
    //     currentActiveMusicIndex: state.currentActiveMusicIndex,
    //     isPlaying: state.isPlaying,
    //     position: position,
    //     bufferedPosition: state.bufferedPosition,
    //     totalDuration: state.totalDuration,
    //   ));
    // });

    // audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
    //   emit(MusicPlayerStateMusicPlaying(
    //     state.currentActiveMusic,
    //     currentActiveMusicIndex: state.currentActiveMusicIndex,
    //     isPlaying: state.isPlaying,
    //     position: state.position,
    //     bufferedPosition: bufferedPosition,
    //     totalDuration: state.totalDuration,
    //   ));
    // });

    emit(MusicPlayerStateMusicPlaying(
      musicData,
      currentActiveMusicIndex: currentTrackId,
      isPlaying: true,
      position: state.position,
      bufferedPosition: state.bufferedPosition,
      totalDuration: Duration(milliseconds: musicData.trackTimeMillis),
    ));
  }
}
