part of 'music_player_bloc.dart';

abstract class MusicPlayerEvent extends Equatable {
  final MusicData musicData;

  const MusicPlayerEvent(this.musicData);

  @override
  List<Object?> get props => [musicData];
}

class MusicPlayerEventPlayMusic extends MusicPlayerEvent{
  const MusicPlayerEventPlayMusic(MusicData musicData) : super(musicData);
}

class MusicPlayerEventStopMusic extends MusicPlayerEvent{
  const MusicPlayerEventStopMusic(MusicData musicData) : super(musicData);
}

class MusicPlayerEventNextMusic extends MusicPlayerEvent{
  const MusicPlayerEventNextMusic(MusicData musicData) : super(musicData);
}

class MusicPlayerEventPreviousMusic extends MusicPlayerEvent{
  const MusicPlayerEventPreviousMusic(MusicData musicData) : super(musicData);
}
