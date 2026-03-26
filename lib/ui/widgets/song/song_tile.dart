import 'package:flutter/material.dart';

import '../../../model/joined/song_with_artist.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songWithArtist,
    required this.isPlaying,
    required this.onTap,
  });

  final SongWithArtist songWithArtist;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final song = songWithArtist.song;
    final artist = songWithArtist.artist;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl.toString()),
          ),
          onTap: onTap,
          title: Text(song.title),
          subtitle: artist != null
              ? Text('${artist.name} · ${artist.genre}')
              : null,
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
