import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https('thyrak-test-default-rtdb.firebaseio.com', '/songs.json');


  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = (json.decode(response.body) as Map<String, dynamic>? ?? {});
      return data.entries
          .map((entry) {
            final songJson = Map<String, dynamic>.from(entry.value as Map);
            songJson[SongDto.idKey] = entry.key;
            return SongDto.fromJson(songJson);
          })
          .toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final songs = await fetchSongs();
    try {
      return songs.firstWhere((song) => song.id == id);
    } catch (_) {
      return null;
    }
  }
}
