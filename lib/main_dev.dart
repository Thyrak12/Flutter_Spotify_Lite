import 'package:provider/provider.dart';
import 'package:spotify_lite/data/repositories/songs/song_repository_mock.dart';
// import 'package:x_code/spotify/part_1_repositories/data/repositories/songs/song_repository_mock.dart';

import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';

/// Configure provider dependencies for dev environement
List<Provider> get providersLocal {
  return [Provider<SongRepository>(create: (context) => SongRepositoryMock())];
}

void main() {
  mainCommon(providersLocal);
}
