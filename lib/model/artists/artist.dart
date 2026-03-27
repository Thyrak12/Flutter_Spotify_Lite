class Artist {
  final String id;
  final String name;
  final String genre;
  final Uri imageUri;

  Artist({
    required this.id,
    required this.name,
    required this.genre,
    required this.imageUri,
  });

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, genre: $genre, imageUri: $imageUri)';
  }
}
