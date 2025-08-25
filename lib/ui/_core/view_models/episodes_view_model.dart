import 'package:flutter/material.dart';

import '../../../data/repositories/episode/episode_repository_impl.dart';

class EpisodesViewModel extends ChangeNotifier {
  late String _filter;
  int _idReference = 0;
  bool _loading = false;
  List<dynamic> _episodes = [], _favoriteEpisodes = [], _filteredEpisodes = [];
  late EpisodeRepositoryImpl _repository;

  List<dynamic> get episodes => _filteredEpisodes.isEmpty ? _episodes : _filteredEpisodes;

  List<dynamic> get favoriteEpisodes => _favoriteEpisodes;

  bool get loading => _loading;

  String get filter => _filter;

  int get idReference => _idReference;

  void initRepository(EpisodeRepositoryImpl repo) {
    _repository = repo;
    _filter = '';
    fetchEpisodes();
    notifyListeners();
  }

  void setReference(int id) {
    _idReference = id;
    notifyListeners();
  }

  Future<void> fetchEpisodes() async {
    _loading = true;
    notifyListeners();
    _episodes = await _repository.fetchAllEpisodes();
    _loading = false;
    notifyListeners();
  }

  Future<bool> searchEpisodes(String name) async {
    _loading = true;
    notifyListeners();
    if (name.isEmpty) {
      _filteredEpisodes.clear();
      _filter = '';
      _loading = false;
      notifyListeners();
      return false;
    }

    _filter = name;
    _filteredEpisodes = await _repository.searchEpisodes(name);
    if (_filteredEpisodes.isEmpty) return false;
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<void> toggleFavorite(int episodeId) async {
    final index = _episodes.indexWhere((episode) => int.parse(episode.id) - 1 == episodeId);
    if (index != -1) {
      _episodes[index] = _episodes[index].copyWith(isFavorite: true);
      await _repository.updateEpisodeStatus(
        episodeId,
        _episodes[index].isFavorite,
        _episodes[index].isWatched,
        _episodes[index].imagePath,
      );
      notifyListeners();
    }
  }

  Future<void> toggleWatched(int episodeId) async {
    final index = _episodes.indexWhere((episode) => int.parse(episode.id) - 1 == episodeId);
    if (index != -1) {
      _episodes[index] = _episodes[index].copyWith(isWatched: true);
      await _repository.updateEpisodeStatus(
        episodeId,
        _episodes[index].isFavorite,
        _episodes[index].isWatched,
        _episodes[index].imagePath,
      );
      notifyListeners();
    }
  }

  Future<void> getFavoriteEpisodes() async {
    _loading = true;
    notifyListeners();
    _favoriteEpisodes = _episodes.where((episode) => episode.isFavorite).toList();
    _loading = false;
    notifyListeners();
  }
}
