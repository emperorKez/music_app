import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryRepository {
  final OnAudioQuery audioQuery = OnAudioQuery();


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

  fetchPlaylists() async {
    // Query Albums
    List<PlaylistModel> playlists = await audioQuery.queryPlaylists();
    return playlists;

  }

  createPlaylist({required String name}) async {
    await audioQuery.createPlaylist(name);
  }




//   createPlaylist	(PlaylistName, RequestPermission)	bool
// removePlaylist	(PlaylistId, RequestPermission)	bool
// addToPlaylist	[NT-BG](PlaylistId, AudioId, RequestPermission)	bool
// removeFromPlaylist	[NT](PlaylistId, AudioId, RequestPermission)	bool
// renamePlaylist	(PlaylistId, NewName, RequestPermission)	bool
// moveItemTo


   Future<Uint8List?> fetchArtwork(int audioId) async {
    // DEFAULT: ArtworkFormat.JPEG, 200 and false
    return await audioQuery.queryArtwork(
        audioId,
        ArtworkType.AUDIO,
      );
  }
}