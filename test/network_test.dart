import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/model/music_data.dart';
import 'package:music_player/repository/message_composer.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

class MockHttpClient extends Mock implements Client {}

class MockUri extends Mock implements Uri {}

void main() {
  late InternetConnectionChecker internetConnectionChecker;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    internetConnectionChecker = InternetConnectionChecker();
    registerFallbackValue(MockUri());
    mockHttpClient = MockHttpClient();
  });

  tearDown(() {
    reset(mockInternetConnectionChecker);
    reset(mockHttpClient);
  });

  group('isConnected', () {
    test('Check if app has connection or not, should return true if there is a connection', () async {
      const tHasConnectionFuture = true;
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => tHasConnectionFuture);
      final result = await internetConnectionChecker.hasConnection;
      expect(result, tHasConnectionFuture);
    });
  });

  group('isNotConnected', () {
    test('Check if app has connection or not, should return false if there is no connection', () async {
      const tHasConnectionFuture = false;
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => tHasConnectionFuture);
      final result = await internetConnectionChecker.hasConnection;
      expect(result, tHasConnectionFuture);
    });
  });

  group('Get Music Data List', () {
    const tTerm = 'k';
    String url = MessageComposer.composeUrl(tTerm);

    test('Verify the URL', () {
      String result = 'https://itunes.apple.com/search?term=k&entity=song&attribute=artistTerm';
      expect(result, url);
    });

    test('Check Music Data List', () async {
      String response = await MessageComposer.sendMessageGet(url);
      Map<String, dynamic> jsonResponse = json.decode(response);
      expect(jsonResponse['resultCount'], 50);

      String tMusic1 = '{wrapperType: track, kind: song, artistId: 368183298, collectionId: 1440881047, trackId: 1440881684, artistName: Kendrick Lamar, collectionName: DAMN., trackName: HUMBLE., collectionCensoredName: DAMN., trackCensoredName: HUMBLE., artistViewUrl: https://music.apple.com/us/artist/kendrick-lamar/368183298?uo=4, collectionViewUrl: https://music.apple.com/us/album/humble/1440881047?i=1440881684&uo=4, trackViewUrl: https://music.apple.com/us/album/humble/1440881047?i=1440881684&uo=4, previewUrl: https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/8c/0d/44/8c0d446c-880d-ff14-20f8-12c4e5f019c1/mzaf_11754589632384701860.plus.aac.p.m4a, artworkUrl30: https://is2-ssl.mzstatic.com/image/thumb/Music112/v4/86/c9/bb/86c9bb30-fe3d-442e-33c1-c106c4d23705/17UMGIM88776.rgb.jpg/30x30bb.jpg, artworkUrl60: https://is2-ssl.mzstatic.com/image/thumb/Music112/v4/86/c9/bb/86c9bb30-fe3d-442e-33c1-c106c4d23705/17UMGIM88776.rgb.jpg/60x60bb.jpg, artworkUrl100: https://is2-ssl.mzstatic.com/image/thumb/Music112/v4/86/c9/bb/86c9bb30-fe3d-442e-33c1-c106c4d23705/17UMGIM88776.rgb.jpg/100x100bb.jpg, collectionPrice: 9.99, trackPrice: 1.29, releaseDate: 2017-03-30T12:00:00Z, collectionExplicitness: explicit, trackExplicitness: explicit, discCount: 1, discNumber: 1, trackCount: 14, trackNumber: 8, trackTimeMillis: 177000, country: USA, currency: USD, primaryGenreName: Hip-Hop/Rap, contentAdvisoryRating: Explicit, isStreamable: true}';
      expect(jsonResponse['results'][0].toString(), tMusic1);

      MusicData tMusic2 = MusicData(
        id: 1440881684,
        artistName: 'Kendrick Lamar',
        albumArt: 'https://is2-ssl.mzstatic.com/image/thumb/Music112/v4/86/c9/bb/86c9bb30-fe3d-442e-33c1-c106c4d23705/17UMGIM88776.rgb.jpg/100x100bb.jpg',
        songAlbum: 'DAMN.',
        songName: 'HUMBLE.',
        songUrl: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/8c/0d/44/8c0d446c-880d-ff14-20f8-12c4e5f019c1/mzaf_11754589632384701860.plus.aac.p.m4a',
        trackTimeMillis: 177000,
      );
      MusicData tMusic2Response = MusicData.fromMapObject(jsonResponse['results'][0]);
      expect(tMusic2Response.toString(), tMusic2.toString());
    });
  });
}