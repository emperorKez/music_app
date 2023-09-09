import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryRepository {
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
    List<SongModel> songs = await audioQuery.querySongs(sortType: SongSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER, );
    return songs;

    //Query Artwork
    //Uint8List artwork = await audioQuery.queryArtwork(id, type)
  }


  fetchAlbums() async {
    // Query Albums
    List<AlbumModel> albums = await audioQuery.queryAlbums();
    return albums;

  }


  fetchGenres() async {
    // Query Albums
    List<GenreModel> genres = await audioQuery.queryGenres();
    
    return genres;

  }
  fetchArtists() async {
    // Query Albums
    List<ArtistModel> artists = await audioQuery.queryArtists();
    return artists;

  }


   Future<Uint8List?> fetchArtwork(int audioId) async {
    // DEFAULT: ArtworkFormat.JPEG, 200 and false
    return await audioQuery.queryArtwork(
        audioId,
        ArtworkType.AUDIO,
      );
  }
}