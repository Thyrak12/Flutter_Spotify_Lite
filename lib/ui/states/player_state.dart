import 'package:flutter/widgets.dart';
import 'package:spotify_lite/model/songs/song.dart';

class PlayerState extends ChangeNotifier {
  bool isPlayed = false;
  Song? song;

  void start(Song newSong) {
    song = newSong;
    isPlayed = true;
    notifyListeners();
  }

  void stop() {
    isPlayed = false;
    notifyListeners();
  }
}
