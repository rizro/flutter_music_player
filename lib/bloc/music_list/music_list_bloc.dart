import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_player/model/music_data.dart';
import 'package:music_player/repository/message_composer.dart';
import 'package:music_player/repository/message_parser.dart';
import 'package:music_player/utils/devlog.dart';

part 'music_list_event.dart';
part 'music_list_state.dart';

class MusicListBloc extends Bloc<MusicListEvent, MusicListState> {
  MusicListBloc() : super(MusicListStateInitial(MusicData())) {
    on<MusicListEventGetData>(_onMusicListEventGetData);
    on<MusicListEventSetActiveMusic>(_onMusicListEventSetActiveMusic);
    on<MusicListEventGetNextSong>(_onMusicListEventGetNextSong);
    on<MusicListEventGetPreviousSong>(_onMusicListEventGetPreviousSong);
  }

  @override
  void onChange(Change<MusicListState> change) {
    super.onChange(change);
    DevLog.d(DevLog.arr, change.toString());
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.currentKeyword} - ${change.nextState.currentKeyword}');
    DevLog.d(DevLog.arr, 'Change : ${change.currentState.musicDataList} - ${change.nextState.musicDataList}');
  }

  @override
  void onTransition(Transition<MusicListEvent, MusicListState> transition) {
    super.onTransition(transition);
    DevLog.d(DevLog.arr, transition.toString());
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.currentKeyword} - ${transition.nextState.currentKeyword}');
    DevLog.d(DevLog.arr, 'Transition : ${transition.currentState.musicDataList} - ${transition.nextState.musicDataList}');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    DevLog.d(DevLog.arr, '$error $stackTrace');
  }

  Future<void> _onMusicListEventGetData(MusicListEventGetData event, Emitter<MusicListState> emit) async {
    DevLog.d(DevLog.arr, '_onMusicListEventGetData');
    String keyword = event.keyword;
    DevLog.d(DevLog.arr, 'Keyword : $keyword');
    emit(MusicListStateGettingData(state.currentActiveMusicData, currentKeyword: keyword, musicDataList: state.musicDataList));
    String url = MessageComposer.composeUrl(keyword);
    DevLog.d(DevLog.arr, 'Url : $url');
    String response = await MessageComposer.sendMessageGet(url);
    DevLog.d(DevLog.arr, 'Response : $response');
    if (response.isEmpty){
      emit(MusicListStateDataObtained(state.currentActiveMusicData, currentKeyword: keyword, musicDataList: const []));
    }else {
      List<MusicData> musicDataList = MessageParser.parseResponse(response);
      emit(MusicListStateDataObtained(state.currentActiveMusicData, currentKeyword: keyword, musicDataList: musicDataList));
    }
  }

  void _onMusicListEventSetActiveMusic(MusicListEventSetActiveMusic event, Emitter<MusicListState> emit){
    DevLog.d(DevLog.arr, '_onMusicListEventSetActiveMusic');
    emit(MusicListStateGettingData(state.currentActiveMusicData, currentKeyword: state.currentKeyword, musicDataList: state.musicDataList));
    emit(MusicListStateInitial(
      event.currentMusicData,
      currentKeyword: state.currentKeyword,
      musicDataList: state.musicDataList
    ));
  }

  void _onMusicListEventGetNextSong(MusicListEventGetNextSong event, Emitter<MusicListState> emit){
    DevLog.d(DevLog.arr, '_onMusicListEventGetNextSong');
    int nextIndex = getCurrentIndex() + 1;
    if (nextIndex == state.musicDataList.length){
      nextIndex = 0;
    }
    emit(MusicListStateGetNextSong(state.musicDataList[nextIndex], currentKeyword: state.currentKeyword, musicDataList: state.musicDataList));
  }

  void _onMusicListEventGetPreviousSong(MusicListEventGetPreviousSong event, Emitter<MusicListState> emit){
    DevLog.d(DevLog.arr, '_onMusicListEventGetPreviousSong');
    int nextIndex = getCurrentIndex() - 1;
    if (nextIndex < 0){
      nextIndex = state.musicDataList.length -1;
    }
    emit(MusicListStateGetPreviousSong(state.musicDataList[nextIndex], currentKeyword: state.currentKeyword, musicDataList: state.musicDataList));
  }

  int getCurrentIndex(){
    for (int i = 0; i < state.musicDataList.length; i++){
      if (state.musicDataList[i].id == state.currentActiveMusicData.id){
        return i;
      }
    }

    return -1;
  }
}
