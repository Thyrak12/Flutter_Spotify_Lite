import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../view_model/library_item_data.dart';
import 'library_item_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.grey.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    AsyncValue<List<LibraryItemData>> asyncValue = mv.data;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = _buildEmptyState('Unable to load library\n${asyncValue.error}');
        break;

      case AsyncValueState.success:
        List<LibraryItemData> data = asyncValue.data!;
        if (data.isEmpty) {
          content = _buildEmptyState('No songs found in your library.');
          break;
        }

        content = ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => LibraryItemTile(
            data: data[index],
            isPlaying: mv.isSongPlaying(data[index].song),
            onTap: () {
              if (mv.isSongPlaying(data[index].song)) {
                mv.stop(data[index].song);
              } else {
                mv.start(data[index].song);
              }
            },
            onLike: () => mv.likeSong(data[index].song),
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text('Library', style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
