import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  List<Song>? _songs;

  AsyncValue<List<Song>> value = AsyncValue.loading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  List<Song> get songs => _songs == null ? [] : _songs!;

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    value = AsyncValue.loading();
    notifyListeners();
    // 1 - Fetch songs

    try {
      _songs = await songRepository.fetchSongs();
      value = AsyncValue.success(_songs!);
    } catch (e) {
      value = AsyncValue.error(e);
    } // 2 - notify listeners
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}

enum AsyncValueState { loading, success, error }

class AsyncValue<T> {
  final T? data;
  final Object? error;
  final AsyncValueState state;

  // Main constructor
  AsyncValue({this.data, this.error, required this.state});

  factory AsyncValue.loading() => AsyncValue(state: AsyncValueState.loading);

  factory AsyncValue.success(T data) =>
      AsyncValue(data: data, state: AsyncValueState.success);

  factory AsyncValue.error(Object error) =>
      AsyncValue(error: error, state: AsyncValueState.error);
}
