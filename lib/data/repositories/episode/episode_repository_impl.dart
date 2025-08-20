import 'dart:math';

import 'package:app/domain/models/episode.dart';

import '../../graphql/graphql_queries.dart';
import '../../services/graphql_service.dart';
import '../../services/hive_service.dart';
import 'episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final GraphQLService _graphqlService;
  final HiveManager _hiveManager;

  EpisodeRepositoryImpl(this._graphqlService, this._hiveManager);

  @override
  Future<List<Episode>> getEpisodes() async {
    try {
      final result = await _graphqlService.executeQuery(queries['getEpisodes']);
      if (result.hasException) {
        throw result.exception!;
      }
      final data = await result.data?['episodes']['results'] ?? [];
      return data.map((episode) {
        final randomIndex = Random().nextInt(episode['characters'].length);
        final index = int.parse(episode['id']) - 1;
        final hiveData = _hiveManager.listKv[index];
        return Episode(
          id: episode['id'],
          title: episode['name'],
          date: episode['air_date'],
          numberCharacters: episode['characters'].length,
          episodeName: episode['episode'],
          imagePath: episode['characters'][randomIndex]['image'],
          isFavorite: hiveData?[0] ?? false,
          isWatched: hiveData?[1] ?? false,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Episode>> searchEpisodes(String name) async {
    final result = await _graphqlService.executeQuery(queries['getFilteredEpisodes'], variables: {'name': name});
    final data = result.data?['episodes']['results'] ?? [];
    return List<Episode>.from(
      data.map((episode) {
        final index = int.parse(episode['id']) - 1;
        final hiveData = _hiveManager.listKv[index];
        return Episode.fromMap(episode, hiveData);
      }),
    );
  }

  @override
  Future<void> updateEpisodeStatus(int episodeId, bool isFavorite, bool isWatched, String imagePath) async {
    await HiveManager.setValue(episodeId, [isFavorite, isWatched, imagePath]);
  }
}
