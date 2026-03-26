import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../data/repositories/artists/artist_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../../model/artists/artist.dart';
import '../../../../model/joined/song_with_artist.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<SongWithArtist>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.artistRepository,
    required this.playerState,
  }) {
    playerState.addListener(notifyListeners);
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final List<Song> songs = await songRepository.fetchSongs();
      final List<Artist> artists = await artistRepository.fetchArtists();

      // Build a lookup map for O(1) access
      final Map<String, Artist> artistById = {
        for (var a in artists) a.id: a,
      };

      final List<SongWithArtist> joined = songs
          .map((song) => SongWithArtist(
                song: song,
                artist: artistById[song.artistId],
              ))
          .toList();

      songsValue = AsyncValue.success(joined);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
