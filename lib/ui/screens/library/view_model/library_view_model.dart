import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  Future<void> fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs(forceFetch: forceFetch);

      // 2- Fethc artist
      List<Artist> artists = await artistRepository.fetchArtists(forceFetch: forceFetch);

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = [];
      for (final song in songs) {
        final Artist? artist = mapArtist[song.artistId];
        if (artist != null) {
          data.add(LibraryItemData(song: song, artist: artist));
        }
      }

      this.data = AsyncValue.success(data);
    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> refresh() => fetchSong(forceFetch: true);

  bool isSongPlaying(Song song) => playerState.currentSong?.id == song.id;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();

  void likeSong(Song song) async {
    if (data.state != AsyncValueState.success || data.data == null) {
      return;
    }

    final List<LibraryItemData> currentData = data.data!;
    final int songIndex = currentData.indexWhere((item) => item.song.id == song.id);

    if (songIndex == -1) {
      return;
    }

    final LibraryItemData currentItem = currentData[songIndex];
    final Song currentSong = currentItem.song;

    final Song likedSong = Song(
      id: currentSong.id,
      title: currentSong.title,
      artistId: currentSong.artistId,
      duration: currentSong.duration,
      imageUrl: currentSong.imageUrl,
      likes: currentSong.likes + 1,
    );

    final List<LibraryItemData> updatedData = List<LibraryItemData>.from(currentData);
    updatedData[songIndex] = LibraryItemData(song: likedSong, artist: currentItem.artist);
    data = AsyncValue.success(updatedData);
    notifyListeners();

    try {
      await songRepository.likeSong(song.id);
    } catch (_) {
      final List<LibraryItemData> revertedData = List<LibraryItemData>.from(updatedData);
      revertedData[songIndex] = LibraryItemData(song: currentSong, artist: currentItem.artist);
      data = AsyncValue.success(revertedData);
      notifyListeners();
    }
  }
}
