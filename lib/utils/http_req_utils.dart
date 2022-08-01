import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/devlog.dart';

class HttpRequest{
  static const String _headersKeyAccept = "Accept";
  static const String _headersKeyContentType = "Content-Type";
  static const String _headersValueJson = "application/json";

  static Future<String> httpPost(String url, String body, Map<String, String> headers) async {
    DevLog.d(DevLog.arr, 'HTTP POST Url : $url');
    DevLog.d(DevLog.arr, 'HTTP POST Body : $body');
    try{
      Uri uriUrl = Uri.parse(url);
      Response response = await post(uriUrl, headers: headers, body: body);
      int statusCode = response.statusCode;
      DevLog.d(DevLog.arr, 'HTTP POST Status Code : $statusCode');
      return response.body;
    }catch(e, s){
      DevLog.d(DevLog.arr, "The exception thrown is $e");
      DevLog.d(DevLog.arr, "STACK TRACE \n $s");
    }

    return '';
  }

  static Future<Response?> httpPostFullResponse(String url, String body, Map<String, String> headers) async {
    DevLog.d(DevLog.arr, 'HTTP POST Url : $url');
    for (String keys in headers.keys){
      DevLog.d(DevLog.arr, 'HTTP Header : $keys - ${headers[keys]}');
    }
    DevLog.d(DevLog.arr, 'HTTP POST Body : $body');
    try{
      Uri uriUrl = Uri.parse(url);
      Response response = await post(uriUrl, headers: headers, body: body).timeout(const Duration(seconds: Constants.httpReqTimeout));
      int statusCode = response.statusCode;
      DevLog.d(DevLog.arr, 'HTTP POST Status Code : $statusCode');
      return response;
    }catch(e, s){
      DevLog.d(DevLog.arr, "The exception thrown is $e");
      DevLog.d(DevLog.arr, "STACK TRACE \n $s");
    }

    return null;
  }

  static Future<HttpClientResponse?> httpPostFullResponseNative(String url, String body, Map<String, String> headers) async {
    DevLog.d(DevLog.arr, 'HTTP POST Url : $url');
    DevLog.d(DevLog.arr, 'HTTP POST Body : $body');
    try{
      Uri uriUrl = Uri.parse(url);
      HttpClient httpClient = HttpClient();
      HttpClientRequest httpClientRequest = await httpClient.postUrl(uriUrl);
      for (String keys in headers.keys){
        DevLog.d(DevLog.arr, 'HTTP Header : $keys - ${headers[keys]}');
        String? value = headers[keys];
        if (value != null){
          httpClientRequest.headers.set(keys, value);
        }
      }
      httpClientRequest.add(utf8.encode(body));
      HttpClientResponse httpClientResponse = await httpClientRequest.close().timeout(const Duration(seconds: Constants.httpReqTimeout));
      int responseStatusCode = httpClientResponse.statusCode;
      String responseBody = await httpClientResponse.transform(utf8.decoder).join();
      httpClient.close();
      DevLog.d(DevLog.arr, 'HTTP POST Status Code : $responseStatusCode');
      DevLog.d(DevLog.arr, 'HTTP POST Body : $responseBody');
      return httpClientResponse;
    }catch(e, s){
      DevLog.d(DevLog.arr, "The exception thrown is $e");
      DevLog.d(DevLog.arr, "STACK TRACE \n $s");
    }

    return null;
  }

  static Future<String> httpGet(String url) async {
    DevLog.d(DevLog.arr, 'HTTP GET Url : $url');
    try{
      Uri uriUrl = Uri.parse(url);
      Response response = await get(uriUrl);
      int statusCode = response.statusCode;
      DevLog.d(DevLog.arr, 'HTTP GET Status Code : $statusCode');
      return response.body;
    }catch(e, s){
      DevLog.d(DevLog.arr, "The exception thrown is $e");
      DevLog.d(DevLog.arr, "STACK TRACE \n $s");
    }

    return '';
  }

  static Future<Response?> httpGetFullResponse(String url, Map<String, String> headers) async {
    DevLog.d(DevLog.arr, 'HTTP GET Url : $url');
    try{
      Uri uriUrl = Uri.parse(url);
      Response response = await get(uriUrl, headers: headers).timeout(const Duration(seconds: Constants.httpReqTimeout));
      int statusCode = response.statusCode;
      DevLog.d(DevLog.arr, 'HTTP GET Status Code : $statusCode');
      return response;
    }catch(e, s){
      DevLog.d(DevLog.arr, "The exception thrown is $e");
      DevLog.d(DevLog.arr, "STACK TRACE \n $s");
    }

    return null;
  }

  static Map<String, String> createBaseHeader({bool preserveHeaderCase = false}){
    Map<String, String> headers = {};
    if (preserveHeaderCase){
      headers[_headersKeyContentType] = _headersValueJson;
      headers[_headersKeyAccept] = _headersValueJson;
    }else {
      headers[HttpHeaders.contentTypeHeader] = _headersValueJson;
      headers[HttpHeaders.acceptHeader] = _headersValueJson;
    }
    return headers;
  }
}