part of 'music_list_bloc.dart';

abstract class MusicListState extends Equatable {
  final String currentKeyword;
  final MusicData currentActiveMusicData;
  final List<MusicData> musicDataList;

  const MusicListState(this.currentActiveMusicData, {this.currentKeyword = '', this.musicDataList = const []});

  @override
  List<Object> get props => [currentKeyword, currentActiveMusicData, musicDataList];
}

class MusicListStateInitial extends MusicListState {
  const MusicListStateInitial(MusicData currentActiveMusicData, {String currentKeyword = '', List<MusicData> musicDataList = const []}) : super(currentActiveMusicData, currentKeyword: currentKeyword, musicDataList: musicDataList);
}

class MusicListStateGettingData extends MusicListState{
  const MusicListStateGettingData(MusicData currentActiveMusicData, {String currentKeyword = '', List<MusicData> musicDataList = const []}) : super(currentActiveMusicData, currentKeyword: currentKeyword, musicDataList: musicDataList);
}

class MusicListStateDataObtained extends MusicListState{
  const MusicListStateDataObtained(MusicData currentActiveMusicData, {String currentKeyword = '', List<MusicData> musicDataList = const []}) : super(currentActiveMusicData, currentKeyword: currentKeyword, musicDataList: musicDataList);
}

class MusicListStateGetNextSong extends MusicListState{
  final MusicData musicData;

  const MusicListStateGetNextSong(this.musicData, {String currentKeyword = '', List<MusicData> musicDataList = const []}) : super(musicData, currentKeyword: currentKeyword, musicDataList: musicDataList);

  @override
  List<Object> get props => [currentKeyword, musicDataList, musicData];
}

class MusicListStateGetPreviousSong extends MusicListState{
  final MusicData musicData;

  const MusicListStateGetPreviousSong(this.musicData, {String currentKeyword = '', List<MusicData> musicDataList = const []}) : super(musicData, currentKeyword: currentKeyword, musicDataList: musicDataList);

  @override
  List<Object> get props => [currentKeyword, musicDataList, musicData];
}
