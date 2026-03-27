import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  final Uri artistsUri = Uri.https('thyrak-test-default-rtdb.firebaseio.com', '/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<Artist> result = [];

      for (final entry in data.entries) {
        final Map<String, dynamic> artistJson = entry.value;

        artistJson[ArtistDto.idKey] = entry.key;

        final artist = ArtistDto.fromJson(artistJson);
        result.add(artist);
      }

      return result;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
  }
}
