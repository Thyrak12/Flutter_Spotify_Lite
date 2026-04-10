import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
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
  Future<List<Artist>> fetchArtists() async {
    final Map<String, dynamic> artistJson = await _fetchArtistsJson();

    final List<Artist> result = [];
    for (final entry in artistJson.entries) {
      result.add(ArtistDto.fromJson(entry.key, entry.value));
    }

    return result;
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final Map<String, dynamic> artistJson = await _fetchArtistsJson();
    final dynamic artistData = artistJson[id];

    if (artistData == null) {
      return null;
    }

    return ArtistDto.fromJson(id, artistData);
  }
}
