import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  List<Artist>? _cachedArtists;

  final Uri artistsUri = Uri.https(
    'thyrak-test-default-rtdb.firebaseio.com',
    '/artists.json',
  );

  Future<Map<String, dynamic>> _fetchArtistsJson() async {
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load artists');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final Map<String, dynamic> artistJson = await _fetchArtistsJson();

    final List<Artist> result = [];
    for (final entry in artistJson.entries) {
      result.add(ArtistDto.fromJson(entry.key, entry.value));
    }

    _cachedArtists = result;
    return result;
  }

  @override
  Future<Artist?> fetchArtistById(String id, {bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      for (final Artist artist in _cachedArtists!) {
        if (artist.id == id) {
          return artist;
        }
      }
    }

    final Map<String, dynamic> artistJson = await _fetchArtistsJson();
    final dynamic artistData = artistJson[id];

    if (artistData == null) {
      return null;
    }

    final Artist artist = ArtistDto.fromJson(id, artistData);

    if (_cachedArtists != null) {
      final int index = _cachedArtists!.indexWhere((item) => item.id == id);
      final List<Artist> updatedArtists = List<Artist>.from(_cachedArtists!);
      if (index == -1) {
        updatedArtists.add(artist);
      } else {
        updatedArtists[index] = artist;
      }
      _cachedArtists = updatedArtists;
    }

    return artist;
  }
}
