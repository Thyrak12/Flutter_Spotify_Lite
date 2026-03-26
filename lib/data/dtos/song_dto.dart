import '../../model/songs/song.dart';

class SongDto {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String artistKey = 'artistId';
  static const String durationKey = 'duration'; // in ms
  static const String imageUriKey = 'imageUrl';

  static Song fromJson(Map<String, dynamic> json) {
    final id = json[idKey] as String?;
    final title = (json[titleKey] ?? json['name']) as String?;
    final artist = (json[artistKey] ?? json['artist'] ?? json['artists']) as String?;
    final durationMs = (json[durationKey] ?? json['durationMs']) as int?;
    final imageUrl = json[imageUriKey] as String?;

    if (id == null || title == null || artist == null || durationMs == null || imageUrl == null) {
      throw const FormatException('Invalid song payload');
    }

    return Song(
      id: id,
      title: title,
      artist: artist,
      duration: Duration(milliseconds: durationMs),
      imageUri: Uri.parse(imageUrl),
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistKey: song.artist,
      durationKey: song.duration.inMilliseconds,
      imageUriKey: song.imageUri.toString(),
    };
  }
}
