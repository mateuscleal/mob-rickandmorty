import 'package:app/routing/app_routes.dart';
import 'package:app/ui/home_episodes/view_models/episodes_view_model.dart';
import 'package:app/ui/home_episodes/widgets/episode_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Consumer<EpisodesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.episodes.isEmpty) {
            return const Center(
              child: Text('No episodes found.', style: TextStyle(color: Colors.white)),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Visibility(
                visible: viewModel.filter.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Displaying results for: ${viewModel.filter}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.episodes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == viewModel.episodes.length) {
                      return SizedBox(height: 80);
                    }

                    final episode = viewModel.episodes[index];
                    return GestureDetector(
                      onTap: () {
                        viewModel.setReference(int.parse(episode['id']) - 1);
                        Navigator.of(context).pushNamed(AppRoutes.episodeDetails);
                      },
                      child: EpisodeCard(
                        heroTag: episode['id'],
                        title: episode['name'],
                        date: episode['air_date'],
                        numberCharacters: episode['characters'].length,
                        episode: episode['episode'],
                        imagePath: episode['imagePath'],
                        isWatched: episode['isWatched'],
                        isFavorite: episode['isFavorite'],
                        markAsFavorite: viewModel.toggleFavoriteStatus,
                        markAsWatched: viewModel.toggleWatchedStatus,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
