// song_repository_mock.dart

import 'package:flutter/services.dart';

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 2, seconds: 50),
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
  ];

  @override
  int times = 0;
  Future<List<Song>> fetchSongs() async {
    await Future.delayed(Duration(seconds: 2), () {
      times++;
      if (times % 2 == 0) {
        throw Exception("Error Every 2 time refresh !!!!");
      }
    });

    return _songs;
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    // - Simulate a delay of 3 seconds.

    // - After the delay : Find the song of given id in the list of songs and return it

    // - If not found : Throw an error with the message “no song found for id 25 in the database"

    return Future.delayed(Duration.zero); // TO CHANGE !
  }
}
