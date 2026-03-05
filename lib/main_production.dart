import 'package:provider/provider.dart';
import 'package:nested/nested.dart';
import 'package:spotify_lite/data/repositories/songs/song_repository_remote.dart';
import 'package:spotify_lite/data/repositories/user_history/user_history_repository_mock.dart';

import 'data/repositories/settings/app_settings_repository_mock.dart';
import 'data/repositories/songs/song_repository.dart';
import 'data/repositories/user_history/user_history_repository.dart';
import 'main_common.dart';
import 'ui/states/player_state.dart';
import 'ui/states/settings_state.dart';

/// Configure provider dependencies for production environment
List<SingleChildWidget> get providersRemote {
  final appSettingsRepository = AppSettingsRepositoryMock();

  return [
    // 1 - Inject the song repository
    Provider<SongRepository>(create: (_) => SongRepositoryRemote()),

    // 2 - Inject the user history repository
    Provider<UserHistoryRepository>(create: (_) => UserHistoryRepositoryMock()),

    // 3 - Inject the player state
    ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),

    // 4 - Inject the app setting state
    ChangeNotifierProvider<AppSettingsState>(
      create: (_) => AppSettingsState(repository: appSettingsRepository)
    ),
  ];
}

void main() {
  mainCommon(providersRemote);
}