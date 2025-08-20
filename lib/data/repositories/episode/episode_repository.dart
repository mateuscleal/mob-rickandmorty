import 'package:app/domain/models/episode.dart';

abstract class EpisodeRepository {
  Future<List<Episode>> getEpisodes();

  Future<List<Episode>> searchEpisodes(String name);

  Future<void> updateEpisodeStatus(int episodeId, bool isFavorite, bool isWatched, String imagePath);
}
