import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/joined/song_with_artist.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    AsyncValue<List<SongWithArtist>> asyncValue = mv.songsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );
        break;
      case AsyncValueState.success:
        List<SongWithArtist> items = asyncValue.data!;
        content = ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => SongTile(
            songWithArtist: items[index],
            isPlaying: mv.isSongPlaying(items[index].song),
            onTap: () {
              mv.start(items[index].song);
            },
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),
          Expanded(child: content),
        ],
      ),
    );
  }
}
