part of 'music_list_bloc.dart';

abstract class MusicListEvent extends Equatable {
  const MusicListEvent();

  @override
  List<Object?> get props => [];
}

class MusicListEventGetData extends MusicListEvent{
  final String keyword;

  const MusicListEventGetData(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class MusicListEventSetActiveMusic extends MusicListEvent{
  final MusicData currentMusicData;

  const MusicListEventSetActiveMusic(this.currentMusicData);

  @override
  List<Object?> get props => [currentMusicData];
}

class MusicListEventGetNextSong extends MusicListEvent{}

class MusicListEventGetPreviousSong extends MusicListEvent{}
