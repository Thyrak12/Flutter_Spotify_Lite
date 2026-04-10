import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String _baseHost = 'thyrak-test-default-rtdb.firebaseio.com';

  Uri _songsUri() => Uri.https(_baseHost, '/songs.json');
  Uri _songUri(String id) => Uri.https(_baseHost, '/songs/$id.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(_songsUri());

    if (response.statusCode == 200) {
      final Map<String, dynamic> songJson =
          json.decode(response.body) as Map<String, dynamic>;

      if (songJson.isEmpty) {
        return [];
      }

      final List<Song> result = [];

      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      return result;
    } else {
      throw Exception('Failed to load songs (status: ${response.statusCode})');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final http.Response response = await http.get(_songUri(id));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data == null) {
        return null;
      }

      final Map<String, dynamic> songData =
          data as Map<String, dynamic>;

      return SongDto.fromJson(id, songData);
    } else {
      throw Exception('Failed to load song (status: ${response.statusCode})');
    }
  }

  @override
  Future<void> likeSong(String id) async {
    final http.Response response = await http.get(_songUri(id));

    if (response.statusCode == 200) {
      final Map<String, dynamic> songData =
          json.decode(response.body) as Map<String, dynamic>;

      final int currentLikes =
          (songData[SongDto.likesKey] as num?)?.toInt() ?? 0;

      final http.Response updateResponse = await http.patch(
        _songUri(id),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          SongDto.likesKey: currentLikes + 1,
        }),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception('Failed to update likes');
      }
    } else {
      throw Exception('Song not found (status: ${response.statusCode})');
    }
  }
}