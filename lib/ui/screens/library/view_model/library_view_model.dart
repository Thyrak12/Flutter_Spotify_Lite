import 'package:flutter/material.dart';
import 'package:spotify_lite/data/repositories/songs/song_repository.dart';
import 'package:spotify_lite/model/songs/song.dart';
import 'package:spotify_lite/ui/states/player_state.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository _repository;

  List<Song> _songs = [];
  final PlayerState _playerState;

  LibraryViewModel(this._repository, this._playerState){
    init();
  }

  Future<void> init() async {
    _songs = _repository.fetchSongs();
    _playerState.addListener(onPlayerStateChanged);
    notifyListeners();
  }

  void onPlayerStateChanged() {
    notifyListeners();
  }

  List<Song> get songs => _songs;

  PlayerState? get playerState => _playerState;

  Song? get currentSong => _playerState.currentSong;

  void play(Song song) {
    _playerState.start(song);
  }

  void stop() {
    _playerState.stop();
  }

  bool isPlaying(Song song) {
    return _playerState.currentSong == song;
  }

  void tapSong(Song song) {
    if (_playerState.currentSong == song) {
      _playerState.stop();
    } else {
      _playerState.start(song);
    }
  }
  

  @override
  void dispose() {
    _playerState.removeListener(onPlayerStateChanged);
    super.dispose();
  }
}
