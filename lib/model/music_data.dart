class MusicData{
  static const String colId = 'trackId';
  static const String colArtistName = 'artistName';
  static const String colAlbumArt = 'artworkUrl100';
  static const String colSongAlbum = 'collectionName';
  static const String colSongName = 'trackName';
  static const String colSongUrl = 'previewUrl';
  static const String colTrackTimeMillis = 'trackTimeMillis';

  int id;
  String artistName;
  String albumArt;
  String songAlbum;
  String songName;
  String songUrl;
  int trackTimeMillis;

  MusicData(
      {
        this.id = 0,
        this.artistName = '',
        this.albumArt = '',
        this.songAlbum = '',
        this.songName = '',
        this.songUrl = '',
        this.trackTimeMillis = 0,
      }
  );

  @override
  String toString() {
    return 'MusicData{id: $id, artistName: $artistName, albumArt: $albumArt, songAlbum: $songAlbum, songName: $songName, songUrl: $songUrl, trackTimeMillis: $trackTimeMillis}';
  }

  factory MusicData.fromMapObject(Map<String, dynamic> map) {
    return MusicData(
      id: map[colId],
      artistName: map[colArtistName],
      albumArt: map[colAlbumArt],
      songAlbum: map[colSongAlbum],
      songName: map[colSongName],
      songUrl: map[colSongUrl],
      trackTimeMillis: map[colTrackTimeMillis],
    );
  }
}