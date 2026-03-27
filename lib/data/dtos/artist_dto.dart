import '../../model/artists/artist.dart';

class ArtistDto {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageUriKey = 'imageUrl';

  static Artist fromJson(Map<String, dynamic> json) {
    final id = json[idKey] as String?;
    final name = json[nameKey] as String?;
    final genre = json[genreKey] as String?;
    final imageUrl = json[imageUriKey] as String?;

    if (id == null || name == null || genre == null || imageUrl == null) {
      throw const FormatException('Invalid artist payload');
    }

    return Artist(
      id: id,
      name: name,
      genre: genre,
      imageUri: Uri.parse(imageUrl),
    );
  }

  Map<String, dynamic> toJson(Artist artist) {
    return {
      nameKey: artist.name,
      genreKey: artist.genre,
      imageUriKey: artist.imageUri.toString(),
    };
  }
}
