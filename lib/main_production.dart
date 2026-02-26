import 'package:provider/provider.dart';
import 'package:spotify_lite/data/repositories/songs/song_repository_remote.dart';

import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';

/// Configure provider dependencies for production environment
List<Provider> get providersRemote {
  return [
    Provider<SongRepository>(create: (context) => SongRepositoryRemote()),
  ];
}

void main() {
  mainCommon(providersRemote);
}