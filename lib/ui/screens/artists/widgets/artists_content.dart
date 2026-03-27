import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/artists/artist.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/artist/artist_tile.dart';
import '../view_model/artists_view_model.dart';

class ArtistsContent extends StatelessWidget {
  const ArtistsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mv = context.watch<ArtistsViewModel>();
    final asyncValue = mv.artistsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;
      case AsyncValueState.success:
        final List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) => ArtistTile(artist: artists[index]),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('Artists', style: AppTextStyles.heading),
          const SizedBox(height: 50),
          Expanded(child: content),
        ],
      ),
    );
  }
}
