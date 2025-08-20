import 'package:flutter/material.dart';

import '../../../data/repositories/episode/episode_repository.dart';

class EpisodesViewModel extends ChangeNotifier {

  final String _filter = '';
  int _idReference = 0;
  bool _isLoading = false;
  final EpisodeRepository _repository;

  EpisodesViewModel(this._repository);

  final List<dynamic> _filteredEpisodes = [];
  final List<dynamic> _favoriteEpisodes = [];


  String get filter => _filter;
  bool get isLoading => _isLoading;
  int get idReference => _idReference;
  List<dynamic> get favoriteEpisodes => _favoriteEpisodes;

  List<dynamic> get episodes => _filteredEpisodes.isEmpty ? [] : _filteredEpisodes;

  Future<void> fetchEpisodes() async {

  }

  void setReference(int id) {
    _idReference = id;
    notifyListeners();
  }

  Future<bool> filterEpisodes(String value) async {
    _isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
    return _isLoading;
  }

  void toggleWatchedStatus(int episodeId) async {
    notifyListeners();
  }

  void toggleFavoriteStatus(int episodeId) async {
    notifyListeners();
  }
}
