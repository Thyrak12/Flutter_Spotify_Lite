// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [];

  @override
  Future<List<Song>> fetchSongs() async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _songs;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<void> likeSong(String id) async {
    return Future.delayed(Duration(seconds: 1), () {
      final int index = _songs.indexWhere((song) => song.id == id);
      if (index == -1) {
        throw Exception("No song with id $id in the database");
      }

      final Song song = _songs[index];
      _songs[index] = Song(
        id: song.id,
        title: song.title,
        artistId: song.artistId,
        duration: song.duration,
        imageUrl: song.imageUrl,
        likes: song.likes + 1,
      );
    });
  }
}
