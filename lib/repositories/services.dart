import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AppRepository {
  final OnAudioQuery audioQuery = OnAudioQuery();

  getLocalSongs() async {
    final audioSource = AudioSource ;

  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    return await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
  }


  fetchSonges() async {
    // Query Audios
    List<SongModel> songs = await audioQuery.querySongs(sortType: SongSortType.TITLE, orderType: OrderType.DESC_OR_GREATER);
    return songs;

    //Query Artwork
    //Uint8List artwork = await audioQuery.queryArtwork(id, type)
  }
  fetchAlbums() async {
    // Query Albums
    List<AlbumModel> albums = await audioQuery.queryAlbums();
    return albums;

  }
}