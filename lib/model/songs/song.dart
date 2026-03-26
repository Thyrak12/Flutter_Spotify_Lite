class Song {
  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final Uri imageUri;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration, required this.imageUri,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, duration: $duration, imageUrl: $imageUri)';
  }
}
