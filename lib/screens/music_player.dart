import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/music_list/music_list_bloc.dart';
import 'package:music_player/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/localizations/locale_helper.dart';
import 'package:music_player/model/music_data.dart';
import 'package:music_player/resources/color_resources.dart';
import 'package:music_player/resources/str_resources.dart';
import 'package:music_player/utils/devlog.dart';
import 'package:music_player/utils/ui_utils.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {

  @override
  void initState() {
    DevLog.d(DevLog.arr, 'Init State MusicPlayerScreen');
    WidgetsBinding.instance?.addPostFrameCallback((_) => _initMethod());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: UIUtils.minimumPadding * 2),
          child: FlutterLogo()
        ),
        title: Text(
          StrRes.appName,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: ColorRes.primary
          ),
        ),
        backgroundColor: ColorRes.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MusicListBloc, MusicListState>(
            listener: _onMusicListBlocListener,
          ),
          BlocListener<MusicPlayerBloc, MusicPlayerState>(
            listener: _onMusicPlayerBlocListener,
          )
        ],
        child: Column(
          children: [
            _createSearchBar(),
            _createMusicList(),
            _createMusicPlayer()
          ],
        ),
      ),
    );
  }

  Widget _createSearchBar(){
    return Container(
      margin: const EdgeInsets.only(
          top: UIUtils.minimumPadding * 2,
          right: UIUtils.minimumPadding * 2,
          left: UIUtils.minimumPadding * 2,
          bottom: UIUtils.minimumPadding
      ),
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(Icons.search),
          hintText: LocaleHelper.getTranslated(context, StrRes.musicSearchHint),
          border: OutlineInputBorder(
            borderSide:
            const BorderSide(color: ColorRes.primary, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) => _loadMusicData(value),
      ),
    );
  }

  Widget _createMusicList(){
    return BlocBuilder<MusicListBloc, MusicListState>(
      builder: (context, state) {
        Widget childWidget = Container();
        if (state.musicDataList.isEmpty){
          childWidget = Center(
            child: Text(
              LocaleHelper.getTranslated(context, StrRes.musicNa),
            ),
          );
        }else {
          childWidget = ListView(
            children: List.generate(state.musicDataList.length, (index){
              return _creatreMusicDataItem(state.musicDataList[index], state.currentActiveMusicData);
            }),
          );
        }

        return Expanded(
          child: childWidget,
        );
      },
    );
  }

  Widget _creatreMusicDataItem(MusicData musicData, MusicData currentPlaying){
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: musicData.albumArt,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      trailing: musicData.id == currentPlaying.id ? const Icon(Icons.play_circle) : null,
      title: Text(
        musicData.songName
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            musicData.artistName
          ),
          Text(
            musicData.songAlbum
          ),
        ],
      ),
      onTap: (){
        _onMusicClicked(musicData);
      },
    );
  }

  Widget _createMusicPlayer(){
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state is MusicPlayerStateMusicIdle){
            DevLog.d(DevLog.arr, 'state is MusicPlayerStateMusicIdle');
            return _createMusicPlayerControl(state);
          }else if (state is MusicPlayerStateMusicPlaying){
            DevLog.d(DevLog.arr, 'state is MusicPlayerStateMusicPlaying');
            return _createMusicPlayerControl(state);
          }else {
            return Container();
          }
        }
    );
  }

  Widget _createMusicPlayerControl(MusicPlayerState state){
    return Container(
      margin: const EdgeInsets.all(UIUtils.minimumPadding),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: (){
                  _onPreviousSongClicked();
                },
                icon: const Icon(
                  Icons.fast_rewind_rounded
                )
              ),
              IconButton(
                onPressed: (){
                  if (state.isPlaying){
                    _onPauseClicked(state.currentActiveMusic);
                  }else {
                    _onPlayClicked(state.currentActiveMusic);
                  }
                },
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                )
              ),
              IconButton(
                onPressed: (){
                  _onNextSongClicked();
                },
                icon: const Icon(
                  Icons.fast_forward_rounded
                )
              ),
            ],
          ),
          _createMusicProgressBar(state),
        ],
      ),
    );
  }

  Widget _createMusicProgressBar(MusicPlayerState state){
    return Container();
  }

  void _initMethod(){
    DevLog.d(DevLog.arr, '_initMethod');
    _loadMusicData('');
  }

  void _loadMusicData(String keyword){
    DevLog.d(DevLog.arr, '_loadMusicData : $keyword');
    BlocProvider.of<MusicListBloc>(context).add(MusicListEventGetData(keyword));
  }

  void _onMusicClicked(MusicData musicData){
    DevLog.d(DevLog.arr, '_onMusicClicked');
    BlocProvider.of<MusicListBloc>(context).add(MusicListEventSetActiveMusic(musicData));
    BlocProvider.of<MusicPlayerBloc>(context).add(MusicPlayerEventPlayMusic(musicData));
  }

  void _onPlayClicked(MusicData musicData){
    DevLog.d(DevLog.arr, '_onPlayClicked');
    BlocProvider.of<MusicPlayerBloc>(context).add(MusicPlayerEventPlayMusic(musicData));
  }

  void _onPauseClicked(MusicData musicData){
    DevLog.d(DevLog.arr, '_onPauseClicked');
    BlocProvider.of<MusicPlayerBloc>(context).add(MusicPlayerEventStopMusic(musicData));
  }

  void _onNextSongClicked(){
    DevLog.d(DevLog.arr, '_onNextSongClicked');
    BlocProvider.of<MusicListBloc>(context).add(MusicListEventGetNextSong());
  }

  void _onPreviousSongClicked(){
    DevLog.d(DevLog.arr, '_onPreviousSongClicked');
    BlocProvider.of<MusicListBloc>(context).add(MusicListEventGetPreviousSong());
  }

  void _onMusicListBlocListener(BuildContext context, MusicListState state){
    DevLog.d(DevLog.arr, '_onMusicListBlocListener');
    if (state is MusicListStateInitial){
      DevLog.d(DevLog.arr, 'state is MusicListStateInitial');
    }else if (state is MusicListStateGettingData){
      DevLog.d(DevLog.arr, 'state is MusicListStateGettingData');
    }else if (state is MusicListStateDataObtained){
      DevLog.d(DevLog.arr, 'state is MusicListStateDataObtained');
    }else if (state is MusicListStateGetNextSong){
      DevLog.d(DevLog.arr, 'state is MusicListStateGetNextSong');
      BlocProvider.of<MusicPlayerBloc>(context).add(MusicPlayerEventNextMusic(state.musicData));
    }else if (state is MusicListStateGetPreviousSong){
      DevLog.d(DevLog.arr, 'state is MusicListStateGetPreviousSong');
      BlocProvider.of<MusicPlayerBloc>(context).add(MusicPlayerEventPreviousMusic(state.musicData));
    }else {
      DevLog.e(DevLog.arr, 'Unhandled State');
    }
  }

  void _onMusicPlayerBlocListener(BuildContext context, MusicPlayerState state){
    DevLog.d(DevLog.arr, '_onMusicPlayerBlocListener');
    if (state is MusicPlayerStateInitial){
      DevLog.d(DevLog.arr, 'state is MusicPlayerStateInitial');
    }else if (state is MusicPlayerStateMusicIdle){
      DevLog.d(DevLog.arr, 'state is MusicPlayerStateMusicIdle');
    }else if (state is MusicPlayerStateMusicPlaying){
      DevLog.d(DevLog.arr, 'state is MusicPlayerStateMusicPlaying');
    }else {
      DevLog.e(DevLog.arr, 'Unhandled State');
    }
  }
}
