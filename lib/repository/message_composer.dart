import 'package:http/http.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/devlog.dart';
import 'package:music_player/utils/http_req_utils.dart';

class MessageComposer{
  static const String startParam = '?';
  static const String nextParam = '&';
  static const String addParam = '=';
  static const String searchAction = 'search';
  static const String paramTerm = 'term';
  static const String paramEntity = 'entity';
  static const String entitySong = 'song';
  static const String paramAttribute = 'attribute';
  static const String attributeArtistTerm = 'artistTerm';

  static String addParamToUrl(String url, String param, String value){
    String paramSeparator = url.endsWith(startParam) ? '' : nextParam;
    return '$url$paramSeparator$param$addParam$value';
  }

  static String composeUrl(String keyword){
    keyword = keyword.replaceAll(' ', '+');
    String url = '${Constants.baseUrl}$searchAction$startParam';
    url = addParamToUrl(url, paramTerm, keyword);
    url = addParamToUrl(url, paramEntity, entitySong);
    url = addParamToUrl(url, paramAttribute, attributeArtistTerm);
    return url;
  }

  static Future<String> sendMessageGet(String url) async{
    Map<String, String> header = HttpRequest.createBaseHeader();
    Response? response = await HttpRequest.httpGetFullResponse(url, header);
    if (response != null){
      DevLog.d(DevLog.arr, 'Response Status Code : ${response.statusCode}');
      DevLog.d(DevLog.arr, 'Response Body : ${response.body}');
      if (response.statusCode == 200){
        return response.body;
      }else {
        DevLog.e(DevLog.arr, 'Invalid Status Code : ${response.statusCode}');
        return '';
      }
    }else {
      DevLog.e(DevLog.arr, 'Http Request Result NUll');
      return '';
    }
  }
}