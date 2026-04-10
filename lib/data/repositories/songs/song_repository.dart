import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs({bool forceFetch = false});
  
  Future<Song?> fetchSongById(String id, {bool forceFetch = false});

  Future<void> likeSong(String id);
}
