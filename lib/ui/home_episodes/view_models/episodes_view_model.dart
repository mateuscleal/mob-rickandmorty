import 'package:flutter/material.dart';
import '../../../data/repositories/episode/episode_repository_impl.dart';
import '../../../domain/models/episode.dart';

class EpisodesViewModel extends ChangeNotifier {

  late String _filter;
  int _idReference = 0;
  bool _loading = false;
  List<Episode> _episodes = [], _favoriteEpisodes = [];
  EpisodeRepositoryImpl? _repository;


  List<Episode> get episodes => _episodes;
  List<Episode> get favoriteEpisodes => _favoriteEpisodes;
  bool get loading => _loading;
  String get filter => _filter;
  int get idReference => _idReference;

  EpisodesViewModel();

  void initRepository(EpisodeRepositoryImpl repo) {
    _repository = repo;
    _filter = '';
    notifyListeners();
  }

  void setReference(int id) {
    _idReference = id;
    notifyListeners();
  }

  Future<void> fetchEpisodes() async {
    _loading = true;
    notifyListeners();
    _episodes = await _repository!.getEpisodes();
    _loading = false;
    notifyListeners();
  }

  Future<bool> searchEpisodes(String name) async {
    _loading = true;
    notifyListeners();
    if (name.isEmpty) {
      _episodes = await _repository!.getEpisodes();
      _loading = false;
      notifyListeners();
      return false;
    }

    _filter = name;
    final filtered = await _repository!.searchEpisodes(name);
    if (filtered.isEmpty) return false;
    _episodes = filtered;
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<void> toggleFavorite(int episodeId) async {
    final index = _episodes.indexWhere((e) => int.parse(e.id) - 1 == episodeId);
    if (index != -1) {
      final episode = _episodes[index];
      final updated = episode.copyWith(isFavorite: !episode.isFavorite);
      _episodes[index] = updated;
      await _repository!.updateEpisodeStatus(episodeId, updated.isFavorite, updated.isWatched, updated.imagePath);
      notifyListeners();
    }
  }

  Future<void> toggleWatched(int episodeId) async {
    final index = _episodes.indexWhere((e) => int.parse(e.id) - 1 == episodeId);
    if (index != -1) {
      final episode = _episodes[index];
      final updated = episode.copyWith(isWatched: !episode.isWatched);
      _episodes[index] = updated;
      await _repository!.updateEpisodeStatus(episodeId, updated.isFavorite, updated.isWatched, updated.imagePath);
      notifyListeners();
    }
  }
}
