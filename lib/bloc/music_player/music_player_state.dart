part of 'music_player_bloc.dart';

abstract class MusicPlayerState extends Equatable {
  final int currentActiveMusicIndex;
  final MusicData currentActiveMusic;
  final bool isPlaying;
  final Duration position;
  final Duration bufferedPosition;
  final Duration totalDuration;

  const MusicPlayerState(
      this.currentActiveMusic,
      {
        this.currentActiveMusicIndex = -1,
        this.isPlaying = false,
        this.position = Duration.zero,
        this.bufferedPosition = Duration.zero,
        this.totalDuration = Duration.zero,
      }
  );

  @override
  List<Object> get props => [currentActiveMusicIndex, currentActiveMusic, isPlaying, position, bufferedPosition, totalDuration];
}

class MusicPlayerStateInitial extends MusicPlayerState {
  const MusicPlayerStateInitial(
      MusicData currentActiveMusic,
      {
        int currentActiveMusicIndex = -1,
        bool isPlaying = false,
        Duration position = Duration.zero,
        Duration bufferedPosition = Duration.zero,
        Duration totalDuration = Duration.zero,
      }
  ) : super(
      currentActiveMusic,
      currentActiveMusicIndex: currentActiveMusicIndex,
      isPlaying: isPlaying,
      position: position,
      bufferedPosition: bufferedPosition,
      totalDuration: totalDuration,
  );
}

class MusicPlayerStateMusicIdle extends MusicPlayerState {
  const MusicPlayerStateMusicIdle(
      MusicData currentActiveMusic,
      {
        int currentActiveMusicIndex = -1,
        bool isPlaying = false,
        Duration position = Duration.zero,
        Duration bufferedPosition = Duration.zero,
        Duration totalDuration = Duration.zero,
      }
  ) : super(
    currentActiveMusic,
    currentActiveMusicIndex: currentActiveMusicIndex,
    isPlaying: isPlaying,
    position: position,
    bufferedPosition: bufferedPosition,
    totalDuration: totalDuration,
  );
}

class MusicPlayerStateMusicPlaying extends MusicPlayerState {
  const MusicPlayerStateMusicPlaying(
      MusicData currentActiveMusic,
      {
        int currentActiveMusicIndex = -1,
        bool isPlaying = false,
        Duration position = Duration.zero,
        Duration bufferedPosition = Duration.zero,
        Duration totalDuration = Duration.zero,
      }
  ) : super(
    currentActiveMusic,
    currentActiveMusicIndex: currentActiveMusicIndex,
    isPlaying: isPlaying,
    position: position,
    bufferedPosition: bufferedPosition,
    totalDuration: totalDuration,
  );
}
