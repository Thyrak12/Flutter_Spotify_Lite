import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String _baseHost = 'thyrak-test-default-rtdb.firebaseio.com';
  List<Song>? _cachedSongs;

  Uri _songsUri() => Uri.https(_baseHost, '/songs.json');
  Uri _songUri(String id) => Uri.https(_baseHost, '/songs/$id.json');

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(_songsUri());

    if (response.statusCode == 200) {
      final dynamic decodedJson = json.decode(response.body);
      final Map<String, dynamic> songJson =
          decodedJson == null ? <String, dynamic>{} : decodedJson as Map<String, dynamic>;

      if (songJson.isEmpty) {
        _cachedSongs = [];
        return _cachedSongs!;
      }

      final List<Song> result = [];

      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      _cachedSongs = result;
      return result;
    } else {
      throw Exception('Failed to load songs (status: ${response.statusCode})');
    }
  }

  @override
  Future<Song?> fetchSongById(String id, {bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      for (final Song song in _cachedSongs!) {
        if (song.id == id) {
          return song;
        }
      }
    }

    final http.Response response = await http.get(_songUri(id));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data == null) {
        return null;
      }

      final Map<String, dynamic> songData =
          data as Map<String, dynamic>;

      final Song song = SongDto.fromJson(id, songData);

      if (_cachedSongs != null) {
        final int index = _cachedSongs!.indexWhere((item) => item.id == id);
        final List<Song> updatedSongs = List<Song>.from(_cachedSongs!);
        if (index == -1) {
          updatedSongs.add(song);
        } else {
          updatedSongs[index] = song;
        }
        _cachedSongs = updatedSongs;
      }

      return song;
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

      if (_cachedSongs != null) {
        final int index = _cachedSongs!.indexWhere((song) => song.id == id);
        if (index != -1) {
          final Song likedSong = _cachedSongs![index];
          final List<Song> updatedSongs = List<Song>.from(_cachedSongs!);
          updatedSongs[index] = Song(
            id: likedSong.id,
            title: likedSong.title,
            artistId: likedSong.artistId,
            duration: likedSong.duration,
            imageUrl: likedSong.imageUrl,
            likes: likedSong.likes + 1,
          );
          _cachedSongs = updatedSongs;
        }
      }
    } else {
      throw Exception('Song not found (status: ${response.statusCode})');
    }
  }
}