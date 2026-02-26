import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/songs/song_repository.dart';
import '../../../model/song.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SongRepository songRepository = context.read<SongRepository>();
    List<Song> songs = songRepository.fetchSongs();

    return Scaffold(
      appBar: AppBar(title: Text("Library")),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) => Text(songs[index].title),
      ),
    );
  }
}
