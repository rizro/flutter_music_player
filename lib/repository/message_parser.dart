import 'dart:convert';

import 'package:music_player/model/music_data.dart';
import 'package:music_player/utils/devlog.dart';

class MessageParser {
  static const String dataCount = 'resultCount';
  static const String rawData = 'results';

  static List<MusicData> parseResponse(String response){
    Map<String, dynamic> jsonResponse = jsonDecode(response);
    DevLog.d(DevLog.arr, 'Result Count : ${jsonResponse[dataCount].toString()}');
    List<MusicData> musicDataList = [];
    List<dynamic> musicList = List<Map>.from(jsonResponse[rawData]);
    for (dynamic music in musicList){MusicData musicData = MusicData.fromMapObject(music);
      musicDataList.add(musicData);
    }
    return musicDataList;
  }
}