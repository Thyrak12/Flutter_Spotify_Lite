import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'thyrak-test-default-rtdb.firebaseio.com',
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<Song> result = [];

      for (final entry in data.entries) {
        final Map<String, dynamic> songJson = entry.value;
        print(songJson);

        songJson[SongDto.idKey] = entry.key;

        final song = SongDto.fromJson(songJson);
        result.add(song);
      }

      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {

  }
}
