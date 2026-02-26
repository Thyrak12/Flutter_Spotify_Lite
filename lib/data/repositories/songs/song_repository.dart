import '../../../model/song.dart';

abstract class SongRepository {
  List<Song> fetchSongs();
  
  Song? fetchSongById(String id);
}
